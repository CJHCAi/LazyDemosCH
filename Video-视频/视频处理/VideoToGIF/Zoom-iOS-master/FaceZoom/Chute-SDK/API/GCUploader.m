//
//  GCUploader.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/7/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCUploader.h"
#import "GCClient.h"
#import "GCResponseStatus.h"
#import "GCFile.h"
#import "GCUploads.h"
#import "GCResponse.h"
#import "AFJSONRequestOperation.h"
#import "GCUploadingAsset.h"
#import "GCUploadInfo.h"
#import "AFHTTPRequestOperation.h"
#import "GCAsset.h"
#import "GCServiceAsset.h"
#import "GCImageData.h"
#import "GCLog.h"

static NSString * const kGCFiles = @"files";
static NSString * const kGCAlbums = @"albums";
static NSString * const kGCData = @"data";
static NSString * const kGCAuthorization = @"Authorization";
static NSString * const kGCDate = @"Date";
static NSString * const kGCContentType = @"Content-Type";
static int const kGCUploaderMaxConcurrentOperationCount = 1;

static NSString * const kGCBaseURLString = @"https://upload.getchute.com/v2";
//static NSString * const kGCBaseURLString = @"http://localhost:8000";
static dispatch_queue_t serialQueue;

@implementation GCUploader

@synthesize assetsUploadedCount, assetsTotalCount, maxFileSize;

+ (GCUploader *)sharedUploader {
    static GCUploader *_sharedUploader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.getchute.gcuploader.serialqueue", NULL);
        _sharedUploader = [[GCUploader alloc] initWithBaseURL:[NSURL URLWithString:kGCBaseURLString]];
    });
    
    [_sharedUploader setParameterEncoding:AFJSONParameterEncoding];
    
    return _sharedUploader;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    /*
     NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kGCClient];
     GCClient *client = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     
     if (client) {
     self = client;
     return self;
     }
     */
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    //    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    //        if (status == AFNetworkReachabilityStatusNotReachable) {
    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Internet connection detected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //            [alertView show];
    //        }
    //    }];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    //	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self.operationQueue setMaxConcurrentOperationCount:kGCUploaderMaxConcurrentOperationCount];
    
    return self;
}

+ (NSString *)generateTimestamp
{
    //var timestamp =  ("" + (d.getTime()-d.getMilliseconds())/1000 + "-" + Math.random()).replace("0.", "")
    
    NSDate *date = [NSDate date];
    NSNumber *epochTime = @(floor([date timeIntervalSince1970]));
    NSString *timestamp = [NSString stringWithFormat:@"%@-%u%u", epochTime, arc4random(), arc4random()];
    return [timestamp substringToIndex:28];
}


- (void)uploadImages:(NSArray *)images inAlbumWithID:(NSNumber *)albumID progress:(void (^) (CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^) (NSArray *assets))success failure:(void (^)(NSError *error))failure
{
    __block NSMutableArray *operations = [NSMutableArray new];
    __block NSMutableArray *assets = [NSMutableArray new];
    __block NSUInteger totalNumberOfUploads = [images count];
    __block NSInteger numberOfCompletedUploads = 0;
    __block CGFloat currentProgress = 0.0;
    
    GCClient *apiClient = [GCClient sharedClient];
    
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = obj;
        
        NSString *path = [NSString stringWithFormat:@"albums/%@/assets/upload", albumID];
        
         NSMutableURLRequest *request = [self multipartFormRequestWithMethod:kGCClientPOST path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

             [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"filedata"  fileName:@"asset.jpg" mimeType:@"application/octet-stream"];
         }];
        
        [request setValue:[apiClient authorizationToken] forHTTPHeaderField:kGCAuthorization];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            currentProgress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
            progress(currentProgress, numberOfCompletedUploads, totalNumberOfUploads);
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [apiClient parseJSON:responseDictionary withFactoryClass:[GCAsset class] success:^(GCResponse *response) {
                [assets addObject:[response.data objectAtIndex:0]];
            }];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            GCLogWarning([error localizedDescription]);
        }];
        
        [operations addObject:operation];
    }];
    
    [self enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        numberOfCompletedUploads = numberOfCompletedOperations;
        totalNumberOfUploads = totalNumberOfOperations;
        progress(0.0, numberOfCompletedUploads, totalNumberOfUploads);
    } completionBlock:^(NSArray *operations) {
        success([NSArray arrayWithArray:assets]);
    }];
}

//                      THE FOLLOWING UPLOADER METHODS ARE DEPRECATED                      //

/*

- (void)uploadFiles:(NSArray *)files progress:(void (^) (CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^) (NSArray *assets))success failure:(void (^)(NSError *error))failure
{
    [self requestFilesForUpload:files inAlbumsWithIDs:nil success:^(GCUploads *uploads) {
        [self uploadData:uploads progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
            progress(currentUploadProgress, numberOfCompletedUploads, totalNumberOfUploads);
        } success:^(GCUploads *uploads) {
            [self completeUpload:uploads success:^(NSArray *assets) {
                success(assets);
            } failure:^(NSError *error) {
                failure(error);
            }];
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)uploadFiles:(NSArray *)files inAlbumsWithIDs:(NSArray *)albumIDs progress:(void (^) (CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^) (NSArray *assets))success failure:(void (^)(NSError *error))failure
{
    [self requestFilesForUpload:files inAlbumsWithIDs:albumIDs success:^(GCUploads *uploads) {
        [self uploadData:uploads progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
            progress(currentUploadProgress, numberOfCompletedUploads, totalNumberOfUploads);
        } success:^(GCUploads *uploads) {
            [self completeUpload:uploads success:^(NSArray *assets) {
                success(assets);
            } failure:^(NSError *error) {
                failure(error);
            }];
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)requestFilesForUpload:(NSArray *)files inAlbumsWithIDs:(NSArray *)albumIDs success:(void (^)(GCUploads *uploads))success failure:(void (^)(NSError *error))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    __block NSMutableArray *fileDictionaries = [[NSMutableArray alloc] initWithCapacity:[files count]];
    
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GCFile *file = (GCFile *)obj;
        [fileDictionaries addObject:[file serialize]];
    }];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{kGCFiles:fileDictionaries}];
    if (albumIDs)
        [params setObject:albumIDs forKey:kGCAlbums];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"uploads" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        GCUploads *uploads = [GCUploads uploadsFromDictionary:[JSON objectForKey:kGCData]];
        success(uploads);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"<KXLog> Failure: %@", JSON);
        
        failure(error);
        
    }];
    [apiClient enqueueHTTPRequestOperation:operation];
}


- (void)uploadData:(GCUploads *)uploads progress:(void (^)(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^)(GCUploads *uploads))success
{
       
    __block NSMutableArray *operations = [NSMutableArray new];
    __block NSUInteger totalNumberOfUploads = [uploads.assets count];
    __block NSInteger numberOfCompletedUploads = 0;
    __block CGFloat currentProgress = 0.0;
    
    [uploads.assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GCUploadingAsset *asset = obj;
        NSMutableURLRequest *request = [self requestWithMethod:kGCClientPUT path:asset.uploadInfo.uploadUrl parameters:nil];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:asset.uploadInfo.filePath];
        [request setHTTPBody:[[GCImageData dataWithUIImage:image] data]];
        
        
//        NSMutableURLRequest *request = [self multipartFormRequestWithMethod:kGCClientPUT path:asset.uploadInfo.uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            NSString *name = asset.caption ? asset.caption : @"";
//            // If the image is already in an instance variable
//            UIImage *image = [[UIImage alloc] initWithContentsOfFile:asset.uploadInfo.filePath];
//            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:name fileName:@"image1.jpg" mimeType:@"image/jpeg"];
//            // If the image is on disk
////            [formData appendPartWithFileURL:[NSURL fileURLWithPath:asset.uploadInfo.filePath] name:name error:nil];
//        }];
 
        
        [request setValue:asset.uploadInfo.signature forHTTPHeaderField:kGCAuthorization];
        [request setValue:asset.uploadInfo.date forHTTPHeaderField:kGCDate];
        [request setValue:asset.uploadInfo.contentType forHTTPHeaderField:kGCContentType];
        [request setValue:@"public-read" forHTTPHeaderField:@"x-amz-acl"];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            currentProgress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
            NSLog(@"<KXLog> %@ progress: %f", asset.url, currentProgress);
            progress(currentProgress, numberOfCompletedUploads, totalNumberOfUploads);
        }];
        
        [operations addObject:operation];
    }];
    [self enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        numberOfCompletedUploads = numberOfCompletedUploads;
        totalNumberOfUploads = totalNumberOfOperations;
        progress(currentProgress, numberOfCompletedUploads, totalNumberOfUploads);
        NSLog(@"<KXLog> %d out of %d is uploaded", numberOfCompletedUploads, totalNumberOfUploads);
    } completionBlock:^(NSArray *operations) {
        success(uploads);
    }];
    
}

- (void)completeUpload:(GCUploads *)uploads success:(void (^) (NSArray *assets))success failure:(void (^) (NSError *error))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    NSString *path = [NSString stringWithFormat:@"uploads/%@/complete", uploads.id];
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:nil];
    __block NSMutableArray *assets = [NSMutableArray new];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
        [uploads.assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GCUploadingAsset *uploadingAsset = obj;
            
            [GCServiceAsset getAssetWithID:uploadingAsset.id success:^(GCResponseStatus *responseStatus, GCAsset *asset) {
                [assets addObject:asset];
                
                if ([assets count] == [uploads.assets count])
                    success(assets);
                
            } failure:^(NSError *error) {
                failure(error);
            }];
            
        }];

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error);
    }];
    [apiClient enqueueHTTPRequestOperation:operation];
}

*/

@end
