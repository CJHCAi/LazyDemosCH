//
//  ZQPhotoFetcher.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQPhotoFetcher.h"
#import "ZQPublic.h"


#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)



@implementation ZQPhotoFetcher

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZQPhotoFetcher *fetcher;
    dispatch_once(&onceToken, ^{
        fetcher = [[self alloc] init];
    });
    return fetcher;
}

#pragma mark - 返回YES如果得到了授权
+ (BOOL)authorizationStatusAuthorized {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}


#pragma mark - exceed Alert

+ (void)exceedMaxImagesCountAlert:(NSInteger)maxImagesCount
                     presentingVC:(UIViewController * _Nonnull)vc
                            navVC:(ZQAlbumNavVC * _Nonnull)navVC
{
    NSString *message;
    if (navVC.albumDelegate &&
        [navVC.albumDelegate respondsToSelector:@selector(ZQAlbumNavVCExceedMaxImageCountMessage:)])
    {
        message = [navVC.albumDelegate ZQAlbumNavVCExceedMaxImageCountMessage:navVC.maxImagesCount];
    }
    else {
        message = [NSString stringWithFormat:_LocalizedString(@"PHOTO_MAX_SELECTION"), maxImagesCount];
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil
                                                                    message:message
                                                             preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:_LocalizedString(@"OPERATION_OK")
                                                 style:(UIAlertActionStyleDefault)
                                               handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:ok];
    [vc presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - Get photos


+ (NSArray<ZQAlbumModel*> *)getAllAlbumsWithType:(ZQAlbumType)type
{
    //moments不需要取，和其他相册重复
    NSMutableArray *systems = [[ZQPhotoFetcher getSystemAlbums:type] mutableCopy];
    NSArray        *customs = [ZQPhotoFetcher getCustomAlbums:type];
    [systems addObjectsFromArray:customs];
    
    return [systems copy];
}

+ (NSArray *)getSystemAlbums:(ZQAlbumType)type {
    NSMutableArray *albumArr = [NSMutableArray new];
    PHFetchOptions *options = [ZQPhotoFetcher fetchOptionWithType:type];
    PHAssetCollectionSubtype subType = PHAssetCollectionSubtypeAny;
    if (type == ZQAlbumTypeVideo) {
        subType = PHAssetCollectionSubtypeSmartAlbumVideos;
    }
    PHFetchResult *systemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                           subtype:subType
                                                                           options:nil];
    //取相册的封面，照片数目，名字
    for (PHAssetCollection *collection in systemAlbums) {
        if ([ZQPhotoFetcher collectionShouldSkip:collection albumType:type]) {
            continue;
        }
        ZQAlbumModel *model = [[ZQAlbumModel alloc] initWithPHAssetCollection:collection options:options];
        if (model.count > 0) {
            NSLog(@"%@", collection.localizedTitle);
            if([model.name isEqualToString:_LocalizedString(@"All Photos")]) {
                [albumArr insertObject:model atIndex:0];
            }
            else {
                [albumArr addObject:model];
            }
        }
    }
    return albumArr;
}

+ (NSArray<ZQAlbumModel*> *)getCustomAlbums:(ZQAlbumType)type {
    NSMutableArray *albumArr = [NSMutableArray new];
    PHFetchOptions *options = [ZQPhotoFetcher fetchOptionWithType:type];
    
    PHFetchResult *customResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                           subtype:PHAssetCollectionSubtypeAny
                                                                           options:nil];
    
    for (PHAssetCollection *collection in customResult) {
        ZQAlbumModel *model = [[ZQAlbumModel alloc] initWithPHAssetCollection:collection options:options];
        if (model.count > 0) {
            NSLog(@"%@", collection.localizedTitle);
            [albumArr addObject:model];
        }
    }
    return albumArr;
}


+ (PHFetchOptions *)fetchOptionWithType:(ZQAlbumType)type {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    switch (type) {
        case ZQAlbumTypePhoto: {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            break;
        }
        case ZQAlbumTypeVideo: {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            break;
        }
        case ZQAlbumTypeVideoAndPhoto: {
            break;
        }
    }
    return option;
}

+ (BOOL)collectionShouldSkip:(PHAssetCollection *)collection albumType:(ZQAlbumType)type {
    if (type == ZQAlbumTypePhoto && [collection.localizedTitle isEqualToString:_LocalizedString(@"Videos")]) {
        return YES;
    }
    if ([collection.localizedTitle isEqualToString:_LocalizedString(@"Hidden")]) {
        return YES;
    }
    if ([collection.localizedTitle isEqualToString:_LocalizedString(@"Recently Deleted")]) {
        return YES;
    }
    return NO;
}



+ (NSArray<ZQPhotoModel*> *)getAllPhotosInAlbum:(ZQAlbumModel *_Nonnull)collection
{
    PHFetchResult *result = collection.fetchResult;
    NSArray *assets = [result objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.count)]];
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (PHAsset *asset in assets) {
        ZQPhotoModel *model = [[ZQPhotoModel alloc] initWithPHAsset:asset];
        [mArr addObject:model];
    }
    
    return [mArr copy];
    
}


#pragma mark - 获取单张照片

+ (PHImageRequestID)getAlbumCoverFromAlbum:(ZQAlbumModel *_Nonnull)collection
                                completion:(ZQPhotoCompletion)completion
{
    PHAsset *lastPhoto = [(PHFetchResult *)collection.fetchResult lastObject];
    return [self getPhotoFastWithAssets:lastPhoto
                             photoWidth:40
                             completion:completion];
}

+ (PHImageRequestID)getPhotoFastWithAssets:(PHAsset *_Nonnull)asset
                                photoWidth:(CGFloat)photoWidth
                                completion:(ZQPhotoCompletion)completion
{
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.resizeMode = PHImageRequestOptionsResizeModeExact;//fast 200*200
    return [self getPhotoWithAssets:asset
                         photoWidth:photoWidth
                         completion:completion
                             option:option];
}


/*
Default deliveryMode is PHImageRequestOptionsDeliveryModeOpportunistic.
ResultHandler may be called synchronously on the calling thread if any image data is immediately available.
 If the image data returned in this first pass is of insufficient quality, resultHandler will be called again, asychronously on the main thread at a later time with the "correct" results.
 If the request is cancelled, resultHandler may not be called at all.
*/
//返回的是原图，原始大小，960*1280
+ (PHImageRequestID)getPhotoWithAssets:(PHAsset *_Nonnull)asset
                            photoWidth:(CGFloat)photoWidth
                            completion:(ZQPhotoCompletion)completion {
    //option为nil时返回的是原图
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    return [self getPhotoWithAssets:asset
                         photoWidth:photoWidth
                         completion:completion
                             option:option];
}




+ (PHImageRequestID)getPhotoWithAssets:(PHAsset *)asset
                            photoWidth:(CGFloat)photoWidth
                            completion:(ZQPhotoCompletion)completion
                                option:(PHImageRequestOptions *)option
{
    CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
    CGFloat multiple = 2;//[UIScreen mainScreen].scale;
    CGFloat pixelWidth = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    CGSize size = CGSizeMake(pixelWidth, pixelHeight);
    //in main thread
    //默认是asynchronous,resultHandler会被系统调用多次。如果设置成synchronous，则只调用一次
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                            targetSize:size
                                                                           contentMode:(PHImageContentModeAspectFit)
                                                                               options:option
                                                                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
                                  {
                                      if ([ZQPhotoFetcher isFetchSuccess:info]) {
                                          if (completion) {
                                            completion(result, info);
                                          }
                                      }
                                      //download photo from icloud
                                      if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                                          [ZQPhotoFetcher downloadFromiCloud:asset size:size completion:completion];
                                      }
                                      
                                  }];
    
    
    return requestID;
}
+ (BOOL)isFetchSuccess:(NSDictionary*)info {
    return ([[info objectForKey:PHImageCancelledKey] boolValue] == 0 &&
            [[info objectForKey:PHImageErrorKey] boolValue] == 0 &&
            [[info objectForKey:PHImageResultIsInCloudKey] boolValue] == 0);
}
+ (void)downloadFromiCloud:(PHAsset *)asset
                      size:(CGSize)size
                completion:(ZQPhotoCompletion)completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    NSLog(@"main: %d", [NSThread isMainThread]);
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:option
                                                resultHandler:^(NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info)
     {
         UIImage *resultImage = [UIImage imageWithData:imageData scale:0.9];
         resultImage = [self scaleImage:resultImage toSize:size];
         
         if (completion) {
             ZQPhotoCompletion comp = [completion copy];
             if (resultImage.imageAsset == nil) {//下载失败但resultImage!=nil
                 comp(nil, info);
             }
             else if (resultImage) {
                 NSLog(@"=============== icloud");
                 comp(resultImage, info);
             }
         }
         
     }];
    

}

+ (void)cancelRequest:(PHImageRequestID)requestID {
    [[PHImageManager defaultManager] cancelImageRequest:requestID];
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Video

+ (PHImageRequestID)getVideoWithAssets:(PHAsset *_Nonnull)asset
                            completion:(ZQVideoCompletion)completion
{
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestPlayerItemForVideo:asset
                                                                                    options:nil
                                                                              resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                                                                                  
        if (completion) {
            completion(playerItem, info);
        }
    }];
    return requestID;
}

+ (void)exportVideoDegradedWithAssets:(PHAsset *_Nonnull)asset
                             progress:(void(^)(CGFloat progress))progressBlock
                           completion:(void(^_Nullable)(AVAsset* _Nullable playerAsset, NSDictionary* _Nullable info, NSURL* _Nullable url))completion {
    
    //这个opt貌似没有卵用，
//    PHVideoRequestOptions *opt = [[PHVideoRequestOptions alloc] init];
//    opt.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
    
    ______WS();
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                    options:nil
                                              resultHandler:^(AVAsset * _Nullable asset,
                                                              AVAudioMix * _Nullable audioMix,
                                                              NSDictionary * _Nullable info)
    {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *outputString = [NSString stringWithFormat:@"%@/export-%@.m4a", docPath, dateString];
        NSLog(@"压缩后视频本地路径：%@", outputString);
        NSURL *outputURL = [NSURL fileURLWithPath:outputString];
        [wSelf convertVideoToLowQuailtyWithInputAsset:asset
                                            outputURL:outputURL
                                             progress:^(CGFloat progress) {
                                                 if (progressBlock) {
                                                     progressBlock(progress);
                                                 }
                                             }
                                              handler:^(AVAssetExportSession *exportSession) {
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                if (completion) {
                    completion(asset, info, outputURL);
                }
            }
            else if (exportSession.status == AVAssetExportSessionStatusFailed){
                NSError *error = exportSession.error;
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
        
    }];
}
+ (void)convertVideoToLowQuailtyWithInputAsset:(AVAsset*)asset
                                     outputURL:(NSURL*)outputURL
                                      progress:(void(^)(CGFloat progress))progressBlock
                                       handler:(void (^)(AVAssetExportSession*))handler

{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    uint64_t intervalInSecs = (uint64_t)0.1;
    uint64_t leewayInSecs = (uint64_t)0;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, intervalInSecs * NSEC_PER_SEC, leewayInSecs * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"export: %f", exportSession.progress);
        if (exportSession.progress > 0.99) {
            dispatch_source_cancel(timer);
        }
        progressBlock(exportSession.progress);
        
    });
    dispatch_resume(timer);
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
}


@end
