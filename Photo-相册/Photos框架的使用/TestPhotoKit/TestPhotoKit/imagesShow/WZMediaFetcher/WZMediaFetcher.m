//
//  WZMediaFetcher.m
//  WZPhotoPicker
//
//  Created by admin on 17/6/7.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZMediaFetcher.h"


@implementation WZMediaAsset
#pragma mark - WZMediaAsset
-(void)setAsset:(PHAsset *)asset {
    _asset = [asset isKindOfClass:[PHAsset class]]?asset:nil;
}

- (void)fetchThumbnailImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler {
    [WZMediaFetcher fetchThumbnailWithAsset:_asset  synchronous:synchronous handler:^(UIImage *thumbnail) {
        _imageThumbnail = thumbnail;
        if (handler) {handler(thumbnail);};
    }];
}

- (void)fetchOrigionImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler {
    [WZMediaFetcher fetchOrigionWith:_asset synchronous:synchronous handler:^(UIImage *origion) {
        if (handler) {handler(origion);};
    }];
}

@end

#pragma mark - WZMediaAssetCollection
@implementation WZMediaAssetCollection

- (void)customCoverWithMediaAsset:(WZMediaAsset *)mediaAsset withCoverHandler:(void(^)(UIImage *image))handler {
    if ([mediaAsset isKindOfClass:[WZMediaAsset class]]) {
        _coverAssset = mediaAsset;
        if (handler) {
            [WZMediaFetcher fetchThumbnailWithAsset:mediaAsset.asset synchronous:false handler:^(UIImage *thumbnail) {
                handler(thumbnail);
            }];
        }
    }
}

- (void)coverHandler:(void(^)(UIImage *image))handler {
    [self customCoverWithMediaAsset:self.coverAssset withCoverHandler:handler];
}

#pragma mark - Accessor
- (NSArray <WZMediaAsset *>*)mediaAssetArray {
    if (!_mediaAssetArray) {
        _mediaAssetArray = [NSArray array];
    }
    return _mediaAssetArray;
}

- (WZMediaAsset *)coverAssset {
    if (!_coverAssset) {
        if (self.mediaAssetArray.count > 0) {
            _coverAssset = self.mediaAssetArray[0];
        }
    }
    return _coverAssset;
}

@end

#pragma mark - WZMediaPicker
@implementation WZMediaFetcher

#pragma mark - Fetch Picture
+ (NSMutableArray <WZMediaAssetCollection *> *)fetchAssetCollection {
    //智能相册
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    //按照 PHAssetCollection 的startDate 升序排序
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true]];
    
    /*
     PHAssetCollectionTypeAlbum PHAssetCollectionSubtypeAlbumRegular  :qq 微博  我的相簿（自定义的相簿）
     PHAssetCollectionTypeSmartAlbum PHAssetCollectionSubtypeSmartAlbumUserLibrary 胶卷中的图（包含video）
     PHAssetCollectionTypeSmartAlbum PHAssetCollectionSubtypeAlbumRegular 智能相簿（包含image video audio类型 ）
     */
    
    PHFetchResult *result_smartAlbums = [PHAssetCollection
                                         fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                         subtype:PHAssetCollectionSubtypeAlbumRegular
                                         options:fetchOptions];
    
    NSMutableArray <WZMediaAssetCollection *>* mmediaAssetArrayCollection = [[self class] universalMediaAssetCollectionWith:result_smartAlbums];
    return mmediaAssetArrayCollection;
}

+ ( NSMutableArray <WZMediaAssetCollection *>*)universalMediaAssetCollectionWith:(PHFetchResult *)result_smartAlbums {
    NSMutableArray <WZMediaAssetCollection *>* mmediaAssetArrayCollection = [NSMutableArray array];
    
    for (PHAssetCollection *assetCollection in result_smartAlbums) {
        PHFetchResult<PHAsset *> *fetchResoult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[[self class] configImageOptions]];
        
        //过滤无图片的fetchResoult 配置数据源
        if (fetchResoult.count) {
            
            WZMediaAssetCollection *mediaAssetCollection = [[WZMediaAssetCollection alloc] init];
            mediaAssetCollection.assetCollection = assetCollection;
            mediaAssetCollection.title = assetCollection.localizedTitle;
            [mmediaAssetArrayCollection addObject:mediaAssetCollection];
            
            NSMutableArray <WZMediaAsset *>*mmediaAssetArray = [NSMutableArray array];
            for (PHAsset *asset in fetchResoult) {
                WZMediaAsset *object = [[WZMediaAsset alloc] init];
                object.asset = asset;
                [mmediaAssetArray addObject:object];
            }
            
            mediaAssetCollection.mediaAssetArray = [NSArray arrayWithArray:mmediaAssetArray];
        }
    }
    return mmediaAssetArrayCollection;
}


//+ (NSArray <WZMediaAssetCollection *> *)customMediaAssetCollectionOnlyImageAsset {
//    
//}
//+ (NSArray <WZMediaAssetCollection *> *)customMediaAssetCollectionOnlyVideoAsset {
//    
//}
////获取个人创建的相册的集合<也有视频/图片类型>
//+ (NSArray <WZMediaAssetCollection *> *)customMediaAssetCollectionOnlyImageHybirdVideoAsset {
//    NSMutableArray <WZMediaAssetCollection *>* mmediaAssetArrayCollection = [NSMutableArray array];
//    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    for (PHAssetCollection *assetCollection in customCollections) {
//        PHFetchResult<PHAsset *> *fetchResoult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[[self class] configImageOptions]];
//        
//        //过滤无图片的fetchResoult 配置数据源
//        if (fetchResoult.count) {
//            WZMediaAssetCollection *mediaAssetCollection = [[WZMediaAssetCollection alloc] init];
//            mediaAssetCollection.assetCollection = assetCollection;
//            mediaAssetCollection.title = assetCollection.localizedTitle;
//            [mmediaAssetArrayCollection addObject:mediaAssetCollection];
//            NSMutableArray <WZMediaAsset *>*mmediaAssetArray = [NSMutableArray array];
//            for (PHAsset *asset in fetchResoult) {
//                WZMediaAsset *object = [[WZMediaAsset alloc] init];
//                object.asset = asset;
//                [mmediaAssetArray addObject:object];
//            }
//            mediaAssetCollection.mediaAssetArray = [NSArray arrayWithArray:mmediaAssetArray];
//        }
//    }
//    return mmediaAssetArrayCollection;
//}
//

/*
 //  用户自定义的资源
 PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
 for (PHAssetCollection *collection in customCollections) {
 PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
 [nameArr addObject:collection.localizedTitle];
 [assetArr addObject:assets];
 }
 */



+ (int32_t)fetchThumbnailWithAsset:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *thumbnail))handler {
    CGSize targetSize = WZMEDIAASSET_THUMBNAILSIZE;
    PHImageRequestID imageRequestID = [self fetchImageWithAsset:mediaAsset targetSize:targetSize synchronous:synchronous handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result);
        }
    }];
    return imageRequestID;
}

+ (int32_t)fetchOrigionWith:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *origion))handler {
    CGSize targetSize = CGSizeMake(mediaAsset.pixelWidth, mediaAsset.pixelHeight);
    PHImageRequestID imageRequestID = [self fetchImageWithAsset:mediaAsset targetSize:targetSize synchronous:synchronous handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result);
        }
    }];
    return imageRequestID;
}

+ (int32_t)fetchImageWithAsset:(PHAsset *)mediaAsset costumSize:(CGSize)customSize synchronous:(BOOL)synchronous handler:(void(^)(UIImage *image))handler {
    PHImageRequestID imageRequestID = [self fetchImageWithAsset:mediaAsset targetSize:customSize synchronous:synchronous handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result);
        }
    }];
    return imageRequestID;
}

+ (int32_t)fetchImageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize synchronous:(BOOL)synchronous handler:(void (^)(UIImage * _Nullable result, NSDictionary * _Nullable info))handler {
    //图片请求选项配置 同步异步配置
    PHImageRequestOptions *imageRequestOption = [self configImageRequestOption];
    if (synchronous) {
        //增加同步配置
        imageRequestOption = [self configSynchronousImageRequestOptionWith:imageRequestOption];
    }
    
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:imageRequestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result, info);
        }
    }];
    return imageRequestID;
}

+ (int32_t)fetchImageWithAsset:(PHAsset *)asset synchronous:(BOOL)synchronous handler:(void (^)(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info))handler {
    //图片请求选项配置
    //图片请求选项配置 同步异步配置
    PHImageRequestOptions *imageRequestOption = [self configImageRequestOption];
    if (synchronous) {
        //同步配置
        imageRequestOption = [self configSynchronousImageRequestOptionWith:imageRequestOption];
    }
    
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (handler) {
            handler(imageData, dataUTI, orientation, info);
        }
    }];
    return imageRequestID;
}

#pragma mark - 配置
//过滤出image类型的资源
+ (PHFetchOptions *)configImageOptions {
    PHFetchOptions *fetchResoultOption = [[PHFetchOptions alloc] init];
    fetchResoultOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];//按照日期降序排序
    fetchResoultOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];//过滤剩下照片类型
    return fetchResoultOption;
}




+ (PHImageRequestOptions *)configImageRequestOption {
    //图片请求选项配置
    PHImageRequestOptions *imageRequestOption = [[PHImageRequestOptions alloc] init];
    //图片版本:最新
    imageRequestOption.version = PHImageRequestOptionsVersionCurrent;
    //非同步
    imageRequestOption.synchronous = false;
    //图片交付模式:快速
    imageRequestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //图片请求模式:精确的
    imageRequestOption.resizeMode = PHImageRequestOptionsResizeModeExact;
    //用于对原始尺寸的图像进行裁剪，基于比例坐标。resizeMode 为 Exact 时有效。
    //  imageRequestOption.normalizedCropRect = CGRectMake(0, 0, 100, 100);
    
    return imageRequestOption;
}

//同步配置
+ (PHImageRequestOptions *)configSynchronousImageRequestOptionWith:(PHImageRequestOptions *)imageRequestOption {
    imageRequestOption.synchronous = true;
    return imageRequestOption;
}


//+ (void)fetchOrigionWith:(PHAsset *)mediaAsset handler:(void(^)(UIImage *origion, NSString *origionPath))handler {
//    CGSize targetSize = CGSizeMake(mediaAsset.pixelWidth, mediaAsset.pixelHeight);
////    if (targetSize.height <= 300 || targetSize.width <= 300) {
////        NSLog(@"< 300");
////    }
//    [self fetchImageWithAsset:mediaAsset targetSize:targetSize handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        //写进file中
//        NSString *path = nil;
//        if ([info[@"PHImageFileURLKey"] isKindOfClass:[NSURL class]]) {
//            NSURL * fileUrl = info[@"PHImageFileURLKey"];
//
//            //存放在tmp中 可随时更换目录
//            path = [NSString stringWithFormat:@"%@/%@", [[self class] wz_filePath:WZSearchPathDirectoryTemporary fileName:@"WZFileStorage"], fileUrl.lastPathComponent];
//
//            //保存所在文件
//            if ([[self class] wz_fileExistsAtPath:path]) {
//                //文件已经存在
//                NSLog(@"文件已经存在");
//            } else {
//                if ([[self class] wz_createFolder:WZSearchPathDirectoryTemporary folderName:@"WZFileStorage"]) {
//                    @autoreleasepool {
//                        NSData *resultData = UIImagePNGRepresentation(result);
//                        if (![resultData writeToFile:path atomically:true]) {
//                            path = nil;
//                        } else {
//                            NSLog(@"创建成功");
//                        }
//                    }
//                } else {
//                    //创建失败 path 不存在
//                    path = nil;
//                }
//            }
//        }
//
//        UIImage *targetImage = nil;
//        if (!path) {
//            targetImage = result;
//        }
//
//        //二保存其一 因为:原图的缓存太大了,不能每次都加上原图
//        if (handler) {
//            handler(targetImage, path);
//        }
//    }];
//}


//    [[PHImageManager defaultManager] requestImageDataForAsset:mediaAsset.asset options:imageRequestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//        UIImage *origion  = [UIImage imageWithData:imageData];
//
//        CGSize targetSize = [self size:origion.size adjustLargestUnit:150];
//        UIImage *thumbnail = [self image:origion byScalingToSize:targetSize];
////
//        mediaAsset.mediaType = WZMediaTypePhoto;
//        mediaAsset.thumbnail = thumbnail;
//        mediaAsset.origion = origion;
//        if (handler) {
//            handler(origion, origion);
//        }
//    }];


//+ (CGSize)size:(CGSize)size adjustLargestUnit:(CGFloat)largestUnit {
//    if (largestUnit == 0.0) {
//        return CGSizeZero;
//    } else if (size.height > 0) {
//        CGFloat scale = size.width / size.height;
//        CGFloat newWidth = 0.0;
//        CGFloat newHeight = 0.0;
//
//        if (scale > 1.0) {
//            //宽大于高
//            newWidth = largestUnit;
//            newHeight = largestUnit / scale;
//        } else {
//            //高大于宽
//            newWidth = largestUnit * scale;
//            newHeight = largestUnit;
//        }
//        return CGSizeMake(newWidth, newHeight);
//    }
//
//    return CGSizeZero;
//}

//+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
//    UIImage *sourceImage = image;
//    UIImage *newImage = nil;
//
//    UIGraphicsBeginImageContext(targetSize);
//
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = CGPointZero;
//    thumbnailRect.size.width  = targetSize.width;
//    thumbnailRect.size.height = targetSize.height;
//
//    [sourceImage drawInRect:thumbnailRect];
//
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage ;
//}

#pragma mark - Fetch Video
+ (int32_t)fetchVideoWith:(PHAsset *)asset {
    PHVideoRequestOptions *videoRequsetOptions = [[PHVideoRequestOptions alloc] init];
    videoRequsetOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    videoRequsetOptions.networkAccessAllowed = false;
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequsetOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
    }];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:videoRequsetOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
    }];
    
    [[PHImageManager defaultManager] requestExportSessionForVideo:asset options:videoRequsetOptions exportPreset:@"" resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        
    }];
    
    
    return imageRequestID;
}



#pragma mark - Fetch Audio
@end
