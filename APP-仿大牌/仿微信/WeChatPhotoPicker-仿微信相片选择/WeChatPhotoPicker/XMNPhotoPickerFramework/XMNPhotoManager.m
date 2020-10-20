//
//  XMNPhotoManager.m
//  XMNPhotoPickerFrameworkExample
//
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//



#import "XMNPhotoManager.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@implementation XMNPhotoManager
@synthesize assetLibrary = _assetLibrary;


#pragma mark - Life Cycle

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static id manager;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

#pragma mark - Methods


- (BOOL)hasAuthorized {
    if (iOS8Later) {
        return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
    }else {
        return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized;
    }
}

- (NSUInteger)authorizationStatus {
    
    if (iOS8Later) {
        return [PHPhotoLibrary authorizationStatus];
    }else {
        return [ALAssetsLibrary authorizationStatus];
    }
}


/// ========================================
/// @name   获取Album相册相关方法
/// ========================================

/**
 *  获取所有的相册
 *
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAlbumsPickingVideoEnable:(BOOL)pickingVideoEnable
                    completionBlock:(void(^_Nonnull)(NSArray<XMNAlbumModel *> * _Nullable albums))completionBlock {
    
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        /*** 目前不用这个判断 --- 嘴爷 20160526 ***/
//        if (!pickingVideoEnable) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
        // For iOS 9, We need to show ScreenShots Album && SelfPortraits Album
        if (iOS9Later) {
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
        }
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
        
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection  , NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"=====%ld", (long)collection.assetCollectionSubtype);
            /*** 目前不用这个判断 --- 嘴爷 20160526 ***/
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType != %ld", PHAssetMediaTypeImage];
            }else{
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            }
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count > 0 && ![[collection.localizedTitle lowercaseString] containsString:@"delegate"]) {
                if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
                    [albumArr insertObject:[XMNAlbumModel albumWithResult:[fetchResult copy] name:[collection.localizedTitle copy]] atIndex:0];
                } else {
                    [albumArr addObject:[XMNAlbumModel albumWithResult:[fetchResult copy] name:[collection.localizedTitle copy]]];
                }
            }
        }];
        
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
                [albumArr insertObject:[XMNAlbumModel albumWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
            } else {
                [albumArr addObject:[XMNAlbumModel albumWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        completionBlock ? completionBlock(albumArr) : nil;
    }else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                NSLog(@"group nil will do it");
                completionBlock ? completionBlock(albumArr) : nil;
            }
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[XMNAlbumModel albumWithResult:group name:name] atIndex:0];
            } else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]) {
                [albumArr insertObject:[XMNAlbumModel albumWithResult:group name:name] atIndex:1];
            } else {
                [albumArr addObject:[XMNAlbumModel albumWithResult:group name:name]];
            }
        } failureBlock:nil];
        completionBlock ? completionBlock(albumArr) : nil;
    }
}


/**
 *  获取相册中的所有图片,视频
 *
 *  @param result             对应相册  PHFetchResult or ALAssetsGroup<ALAsset>
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAssetsFromResult:(id _Nonnull)result
         pickingVideoEnable:(BOOL)pickingVideoEnable
            completionBlock:(void(^_Nonnull)(NSArray<XMNAssetModel *> * _Nullable assets))completionBlock {
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        for (PHAsset *asset in result) {
            XMNAssetType type = [self _assetTypeWithOriginType:asset.mediaType];
#ifdef iOS9Later
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                type = XMNAssetTypeLivePhoto;
            }
#endif
            NSString *timeLength = type == XMNAssetTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
            timeLength = [self _timeStringFromSeconds:[timeLength intValue]];
            [photoArr addObject:[XMNAssetModel modelWithAsset:asset type:type timeLength:timeLength]];
        }
        completionBlock ? completionBlock(photoArr) : nil;
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        if (!pickingVideoEnable) [gruop setAssetsFilter:[ALAssetsFilter allPhotos]];
        [gruop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            /// Allow picking video
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[result valueForProperty:ALAssetPropertyDuration] integerValue];
                NSString *timeLength = [NSString stringWithFormat:@"%0.0f",duration];
                timeLength = [self _timeStringFromSeconds:timeLength.floatValue];
                [photoArr addObject:[XMNAssetModel modelWithAsset:result type:XMNAssetTypeVideo timeLength:timeLength]];
            } else {
                [photoArr addObject:[XMNAssetModel modelWithAsset:result type:XMNAssetTypePhoto]];
            }
        }];
        completionBlock ? completionBlock(photoArr) : nil;
    }
}


- (XMNAssetType)_assetTypeWithOriginType:(PHAssetMediaType)originType {
    
    if (originType == PHAssetMediaTypeVideo) {
        return XMNAssetTypeVideo;
    }else if (originType == PHAssetMediaTypeAudio) {
        return XMNAssetTypeAudio;
    }
    return XMNAssetTypePhoto;
}

- (NSString *)_timeStringFromSeconds:(int)seconds {
    NSString *newTime = @"";
    if (seconds < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",seconds];
    } else if (seconds < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",seconds];
    } else {
        NSInteger min = seconds / 60;
        NSInteger sec = seconds - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

/// ========================================
/// @name   获取Asset对应信息相关方法
/// ========================================


/**
 *  根据提供的asset 获取原图图片
 *  使用异步获取asset的原图图片
 *  @param asset           具体资源 <PHAsset or ALAsset>
 *  @param completionBlock 回到block
 */
- (void)getOriginImageWithAsset:(id _Nonnull)asset
                completionBlock:(void(^_Nonnull)(UIImage * _Nullable image))completionBlock {
    
    __block UIImage *resultImage;
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOption = [[PHImageRequestOptions alloc] init];
        imageRequestOption.synchronous = YES;
        [self.cachingImageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            resultImage = result;
            completionBlock ? completionBlock(resultImage) : nil;
        }];
    } else {

        CGImageRef fullResolutionImageRef = [[(ALAsset *)asset defaultRepresentation] fullResolutionImage];
        // 通过 fullResolutionImage 获取到的的高清图实际上并不带上在照片应用中使用“编辑”处理的效果，需要额外在 AlAssetRepresentation 中获取这些信息
        NSString *adjustment = [[[(ALAsset *)asset defaultRepresentation] metadata] objectForKey:@"AdjustmentXMP"];
        if (adjustment) {
            // 如果有在照片应用中使用“编辑”效果，则需要获取这些编辑后的滤镜，手工叠加到原图中
            NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
            CIImage *tempImage = [CIImage imageWithCGImage:fullResolutionImageRef];
            
            NSError *error;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                         inputImageExtent:tempImage.extent
                                                                    error:&error];
            CIContext *context = [CIContext contextWithOptions:nil];
            if (filterArray && !error) {
                for (CIFilter *filter in filterArray) {
                    [filter setValue:tempImage forKey:kCIInputImageKey];
                    tempImage = [filter outputImage];
                }
                fullResolutionImageRef = [context createCGImage:tempImage fromRect:[tempImage extent]];
            }
        }
        // 生成最终返回的 UIImage，同时把图片的 orientation 也补充上去
        resultImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:[[asset defaultRepresentation] scale] orientation:(UIImageOrientation)[[asset defaultRepresentation] orientation]];
        completionBlock ? completionBlock(resultImage) : nil;
    }
}


/**
 *  根据提供的asset获取缩略图
 *  使用同步方法获取
 *  @param asset           具体的asset资源 PHAsset or ALAsset
 *  @param size            缩略图大小
 *  @param completionBlock 回调block
 */
- (void)getThumbnailWithAsset:(id _Nonnull)asset
                         size:(CGSize)size
              completionBlock:(void(^_Nonnull)(UIImage *_Nullable image))completionBlock {
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        CGFloat screenScale = [UIScreen mainScreen].scale;
        [self.cachingImageManager requestImageForAsset:asset targetSize:CGSizeMake(size.width * screenScale, size.height * screenScale) contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            completionBlock ? completionBlock(result) : nil;
        }];
    } else {
        CGImageRef thumbnailImageRef = [asset thumbnail];
        if (thumbnailImageRef) {
            completionBlock ? completionBlock([UIImage imageWithCGImage:thumbnailImageRef]) : nil;
        }
    }
}

/**
 *  根据asset 获取屏幕预览图
 *
 *  @param asset           提供的asset资源 PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getPreviewImageWithAsset:(id _Nonnull)asset
                 completionBlock:(void(^_Nonnull)(UIImage * _Nullable image))completionBlock {
    [self getThumbnailWithAsset:asset size:[UIScreen mainScreen].bounds.size completionBlock:completionBlock];
}

/**
 *  根据asset 获取图片的方向
 *
 *  @param asset           PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getImageOrientationWithAsset:(id _Nonnull)asset
                     completionBlock:(void(^_Nonnull)(UIImageOrientation imageOrientation))completionBlock {
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [self.cachingImageManager requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            completionBlock ? completionBlock(orientation) : nil;
        }];
    } else {
        completionBlock ? completionBlock([[asset valueForProperty:@"ALAssetPropertyOrientation"] integerValue]) : nil;
    }
}

- (void)getAssetSizeWithAsset:(id)asset completionBlock:(void(^)(CGFloat size))completionBlock {
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            completionBlock ? completionBlock(imageData.length) : nil;
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        completionBlock ? completionBlock(representation.size) : nil;
    }
}


/**
 *  根据asset获取图片的相关信息
 *  包括图片名称等信息
 *  @param asset           PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getAssetNameWithAsset:(id _Nonnull)asset completionBlock:(void(^ _Nonnull)(NSString *_Nullable info))completionBlock {
    if ([asset isKindOfClass:[PHAsset class]]) {
        if (iOS9Later) {
            PHAssetResource *assetResource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
            completionBlock ? completionBlock(assetResource ? [assetResource originalFilename] : @"unknown") : nil;
        }else {
            PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
            imageRequestOptions.synchronous = YES;
            [self.cachingImageManager requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                NSLog(@"11");
                completionBlock ? completionBlock(                [info[@"PHImageFileURLKey"] lastPathComponent]) : nil;
            }];
        }
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        completionBlock ? completionBlock([representation filename]) : nil;
    }
}
/**
 *  根据asset获取Video信息
 *
 *  @param asset           PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getVideoInfoWithAsset:(id _Nonnull)asset
              completionBlock:(void(^ _Nonnull)(AVPlayerItem * _Nullable playerItem,NSDictionary * _Nullable playetItemInfo))completionBlock {
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            completionBlock ? completionBlock(playerItem,info) : nil;
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
        NSString *uti = [defaultRepresentation UTI];
        NSURL *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoURL];
        completionBlock ? completionBlock(playerItem,nil) : nil;
    }
}


#pragma mark - Getters

- (PHCachingImageManager *)cachingImageManager {
    return [[PHCachingImageManager alloc] init];
}

- (ALAssetsLibrary *)assetLibrary {
    if (!_assetLibrary) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}

#pragma clang diagnostic pop
@end
