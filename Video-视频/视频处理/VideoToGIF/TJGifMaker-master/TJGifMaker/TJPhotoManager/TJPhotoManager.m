//
//  TJPhotoManager.m
//  TJGifMaker
//
//  Created by TanJian on 17/6/16.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJPhotoManager.h"

@implementation TJPhotoManager

-(instancetype)manager{
    
    static TJPhotoManager *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [TJPhotoManager new];
        
    });
    return shareInstance;
    
}

+ (PHFetchResult<PHAsset *> *)getFetchResultWithMediaType:(PHAssetMediaType)mediaType ascend:(BOOL)ascend{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
        options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascend]];
    return  [PHAsset fetchAssetsWithMediaType:mediaType options:options];
}

+ (NSArray *)getPhotosWithPHFetchResult:(PHFetchResult *)result original:(BOOL)original{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    for (PHAsset *asset in result) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            
            [arr addObject:result];
        }];
    }
    
    return arr;
}

@end
