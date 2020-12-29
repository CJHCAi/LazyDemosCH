//
//  UIImageView+SD.m
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UIImageView+SD.h"
#import "UIImageView+WebCache.h"


@implementation UIImageView (SD)




-(void)headImageWithUrlStr:(NSString *)urlStr genInt:(int)gen{
     if(urlStr==nil) return;
    
    NSString *phImage = @"";
    if (gen == 1) {
        phImage = @"comment_default_avatar_man";
    } else if (gen == 0) {
        phImage = @"comment_default_avatar_woman";
    } else {
        // 得不到性别
        phImage = @"united_102_102";
    }
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:phImage]];
    
}



/**
 *  imageView展示网络图片
 *
 *  @param urlStr  图片地址
 *  @param phImage 占位图片
 */
-(void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage{
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
        
    [self sd_setImageWithURL:url placeholderImage:phImage];
}

-(void)imageWithUrlStr:(NSString *)urlStr phRSImage:(UIImage *)phImage{

    [self sd_setImageWithURL:[NSURL URLWithString:urlStr ] placeholderImage:phImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.contentMode = UIViewContentModeScaleAspectFill;
    }];
}


/**
 *  带有进度的网络图片展示
 *
 *  @param urlStr         图片地址
 *  @param phImage        占位图片
 *  @param progressBlock  进度
 *  @param completedBlock 完成
 */
-(void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock{
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;

    [self sd_setImageWithURL:url placeholderImage:phImage options:options progress:progressBlock completed:completedBlock];
}

-(void)groupHeadImageWithUrlStr:(NSString *)urlStr phImage:(NSString *)phImage
{
    NSURL *url=[NSURL URLWithString:urlStr];

    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:phImage]];
    
}

@end
