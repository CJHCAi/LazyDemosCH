//
//  UIButton+SD.m
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UIButton+SD.h"
#import "UIButton+WebCache.h"


@implementation UIButton (SD)

/**
 *  imageView展示网络图片
 *
 *  @param urlStr  图片地址
 *  @param phImage 占位图片
 */
-(void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage{
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:phImage];
}

- (void)LH_imageWithURL:(NSString *)url placeHolder:(UIImage *)image {
    if (url == nil) {
        return;
    }
    
    NSURL *imgURL = [NSURL URLWithString:url];
    [self sd_setBackgroundImageWithURL:imgURL forState:UIControlStateNormal placeholderImage:image];
}




/**
 *  带有进度的网络图片展示
 *
 *  @param urlStr         图片地址
 *  @param phImage        占位图片
 *  @param completedBlock 完成
 */
-(void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage state:(UIControlState)state completedBlock:(SDWebImageCompletionBlock)completedBlock{
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;

    [self sd_setImageWithURL:url forState:state placeholderImage:phImage options:options completed:completedBlock];
}


-(void)headImageWithUrlStr:(NSString *)urlStr genInt:(int)gen{
    
    if(urlStr==nil) return;
    
    NSString *phImage = @"";
    if (gen == 1) {
        phImage = @"comment_default_avatar_man";
    }else{
        phImage = @"comment_default_avatar_woman";
    }
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:phImage]];
    
    
}
-(void)headImageWithUrlStrBack:(NSString *)urlStr genInt:(int)gen{
    
    if(urlStr==nil) return;
    
    NSString *phImage = @"";
    if (gen == 1) {
        phImage = @"comment_default_avatar_man";
    }else{
        phImage = @"comment_default_avatar_woman";
    }
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:phImage]];
    
    
}
-(void)headImageWithUrlStrBtnImage:(NSString *)urlStr genInt:(int)gen{
    if(urlStr==nil) return;
    
    NSString *phImage = @"";
    if (gen == 1) {
        phImage = @"comment_default_avatar_man";
    }else{
        phImage = @"comment_default_avatar_woman";
    }
    
    
    NSURL *url=[NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:phImage]];
}
@end
