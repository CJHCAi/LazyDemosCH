//
//  GCUploader.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/7/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@class GCFile, GCUploads;

@interface GCUploader : AFHTTPClient {
    
}

@property (strong, nonatomic) NSNumber *assetsUploadedCount;
@property (strong, nonatomic) NSNumber *assetsTotalCount;

@property (strong, nonatomic) NSNumber *maxFileSize;

+ (GCUploader *)sharedUploader;
+ (NSString *)generateTimestamp;

- (void)uploadImages:(NSArray *)images inAlbumWithID:(NSNumber *)albumID progress:(void (^) (CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^) (NSArray *assets))success failure:(void (^)(NSError *error))failure;


//                      THE FOLLOWING UPLOADER METHODS ARE DEPRECATED                   //

/*
- (void)uploadFiles:(NSArray *)files progress:(void (^) (CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^) (NSArray *assets))success failure:(void (^)(NSError *error))failure;
- (void)uploadFiles:(NSArray *)files inAlbumsWithIDs:(NSArray *)albumIDs progress:(void (^) (CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads))progress success:(void (^) (NSArray *assets))success failure:(void (^)(NSError *error))failure;
*/

@end
