//
//  MovFromLivePhoto.m
//  MovFromLivePhoto
//
//  Created by verba8888 on 2015/10/19.
//  Copyright © 2015年 verba8888. All rights reserved.
//

#import "MovFromLivePhoto.h"

@interface MovFromLivePhoto()

@property(nonatomic)NSMutableArray *photoAssets;

@end

@implementation MovFromLivePhoto

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self initialize];
    
    return self;
}

-(void) initialize
{
    
}

#pragma mark -

-(NSMutableArray*)getLivePhotoPHAssets
{
    
    _photoAssets = [NSMutableArray array];
    
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (asset.mediaType == 1 && asset.mediaSubtypes == 8) {
            [_photoAssets addObject:asset];
        }
        
    }];
    
    return _photoAssets;
}

-(void)saveMovFileFromLivePhotoPHAsset:(PHAsset*)asset
{
    PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    
    [[PHImageManager defaultManager]requestImageDataForAsset:asset
                                                     options:imageRequestOptions
                                               resultHandler:^(NSData *imageData, NSString *dataUTI,UIImageOrientation orientation,NSDictionary *info)
     {
         if ([info objectForKey:@"PHImageFileURLKey"]) {
             
             NSArray *resArray = [PHAssetResource assetResourcesForAsset:asset];
             
             [resArray enumerateObjectsUsingBlock:^(PHAssetResource *  _Nonnull resorce, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                 
                 if ([resorce.originalFilename hasSuffix:@".MOV"]) {
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *documentsDirectory = [paths objectAtIndex:0];
                     
                     NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
                     NSString *result = [[path absoluteString] stringByReplacingOccurrencesOfString:@".JPG" withString:@".MOV"];
                     NSArray *filePath = [result componentsSeparatedByString:@"/"];
                     
                     NSString *savePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[filePath lastObject]];
                     
                     [[PHAssetResourceManager defaultManager]writeDataForAssetResource:resorce
                                                                                toFile:[NSURL fileURLWithPath:savePath]
                                                                               options:nil completionHandler:^(NSError * _Nullable error) {
                                                                                   
                                                                                   if (!error) {
                                                                                       //save
                                                                                       //NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:savePath]];
                                                                                       UISaveVideoAtPathToSavedPhotosAlbum(savePath,nil,nil,nil);
                                                                                       
                                                                                       //delete from app data
                                                                                       [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
                                                                                   }
                                                                                   
                                                                               }];
                     
                 }
             }];
         }
     }];
}
@end
