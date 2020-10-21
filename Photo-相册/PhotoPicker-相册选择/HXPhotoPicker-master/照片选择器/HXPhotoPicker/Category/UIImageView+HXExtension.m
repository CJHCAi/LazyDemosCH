//
//  UIImageView+HXExtension.m
//  照片选择器
//
//  Created by 洪欣 on 2018/2/14.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import "UIImageView+HXExtension.h"
#import "HXPhotoDefine.h"
#import "HXPhotoModel.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
#elif __has_include("UIImageView+WebCache.h")
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#endif


#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#elif __has_include("YYWebImage.h")
#import "YYWebImage.h"
#elif __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#elif __has_include("YYKit.h")
#import "YYKit.h"
#endif

@implementation UIImageView (HXExtension)

- (void)hx_setImageWithModel:(HXPhotoModel *)model progress:(void (^)(CGFloat progress, HXPhotoModel *model))progressBlock completed:(void (^)(UIImage * image, NSError * error, HXPhotoModel * model))completedBlock {
    [self hx_setImageWithModel:model original:YES progress:progressBlock completed:completedBlock];
}

- (void)hx_setImageWithModel:(HXPhotoModel *)model original:(BOOL)original progress:(void (^)(CGFloat progress, HXPhotoModel *model))progressBlock completed:(void (^)(UIImage * image, NSError * error, HXPhotoModel * model))completedBlock {
    if (!model.networkThumbURL) model.networkThumbURL = model.networkPhotoUrl;
    HXWeakSelf
#if HasYYKitOrWebImage
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    [manager.cache getImageForKey:[manager cacheKeyForURL:model.networkPhotoUrl]  withType:YYImageCacheTypeAll withBlock:^(UIImage * _Nullable image, YYImageCacheType type) {
        if (image) {
            if (!original) model.loadOriginalImage = YES;
            weakSelf.image = image;
//            model.networkImageSize = imageData.length;
            model.imageSize = weakSelf.image.size;
            model.thumbPhoto = weakSelf.image;
            model.previewPhoto = weakSelf.image;
            model.downloadComplete = YES;
            model.downloadError = NO;
            if (completedBlock) {
                completedBlock(weakSelf.image, nil, model);
            }
        }else {
            NSURL *url = original ? model.networkPhotoUrl : model.networkThumbURL;
            [weakSelf yy_setImageWithURL:url placeholder:model.thumbPhoto options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                model.receivedSize = receivedSize;
                model.expectedSize = expectedSize;
//                model.networkImageSize = expectedSize;
                CGFloat progress = (CGFloat)receivedSize / expectedSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(progress, model);
                    }
                });
            } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                return image;
            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                if (error != nil) {
                    model.downloadError = YES;
                    model.downloadComplete = YES;
                }else {
                    if (image) {
                        weakSelf.image = image;
                        model.imageSize = image.size;
                        model.thumbPhoto = image;
                        model.previewPhoto = image;
                        model.downloadComplete = YES;
                        model.downloadError = NO;
                    }
                }
                if (completedBlock) {
                    completedBlock(image,error,model);
                }
            }];
        }
    }];
    /*
    [manager.cache getImageDataForKey:[manager cacheKeyForURL:model.networkPhotoUrl] withBlock:^(NSData * _Nullable imageData) {
        if (imageData) {
            if (!original) model.loadOriginalImage = YES;
            UIImage *image = [manager.cache getImageForKey:[manager cacheKeyForURL:model.networkPhotoUrl] withType:YYImageCacheTypeAll];
            weakSelf.image = image;
            model.networkImageSize = imageData.length;
            model.imageSize = weakSelf.image.size;
            model.thumbPhoto = weakSelf.image;
            model.previewPhoto = weakSelf.image;
            model.downloadComplete = YES;
            model.downloadError = NO;
            if (completedBlock) {
                completedBlock(weakSelf.image, nil, model);
            }
        }else {
            NSURL *url = original ? model.networkPhotoUrl : model.networkThumbURL;
            [weakSelf yy_setImageWithURL:url placeholder:model.thumbPhoto options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                model.receivedSize = receivedSize;
                model.expectedSize = expectedSize;
                model.networkImageSize = expectedSize;
                CGFloat progress = (CGFloat)receivedSize / expectedSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(progress, model);
                    }
                });
            } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {

                return image;
            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                if (error != nil) {
                    model.downloadError = YES;
                    model.downloadComplete = YES;
                }else {
                    if (image) {
                        weakSelf.image = image;
                        model.imageSize = image.size;
                        model.thumbPhoto = image;
                        model.previewPhoto = image;
                        model.downloadComplete = YES;
                        model.downloadError = NO;
                    }
                }
                if (completedBlock) {
                    completedBlock(image,error,model);
                }
            }];
        }
    }];
    */
#elif HasSDWebImage
    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:model.networkPhotoUrl];
    [[SDWebImageManager sharedManager].imageCache queryImageForKey:cacheKey options:SDWebImageQueryMemoryData context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        if (image) {
            weakSelf.image = image;
//            if (data) {
//                model.networkImageSize = data.length;
//            }
            model.imageSize = image.size;
            model.thumbPhoto = image;
            model.previewPhoto = image;
            model.downloadComplete = YES;
            model.downloadError = NO;
            if (completedBlock) {
                completedBlock(image, nil, model);
            }
        }else {
            if (!original) model.loadOriginalImage = image;
            NSURL *url = (original || image) ? model.networkPhotoUrl : model.networkThumbURL;
            [weakSelf sd_setImageWithURL:url placeholderImage:model.thumbPhoto options:0 context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                model.receivedSize = receivedSize;
                model.expectedSize = expectedSize;
//                model.networkImageSize = expectedSize;
                CGFloat progress = (CGFloat)receivedSize / expectedSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(progress, model);
                    }
                });
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error != nil) {
                    model.downloadError = YES;
                    model.downloadComplete = YES;
                }else {
                    if (image) {
                        weakSelf.image = image;
                        model.imageSize = image.size;
                        model.thumbPhoto = image;
                        model.previewPhoto = image;
                        model.downloadComplete = YES;
                        model.downloadError = NO;
                    }
                }
                if (completedBlock) {
                    completedBlock(image,error,model);
                }
            }];
        }
    }]; 
#else
    NSAssert(NO, @"请导入YYWebImage/SDWebImage后再使用网络图片功能");
#endif
}
@end
