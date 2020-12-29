//
//  UIButton+ZSYYWebImage.m
//  HandsUp
//
//  Created by wanghui on 2018/5/12.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import "UIButton+ZSYYWebImage.h"
#import "UIButton+WebCache.h"
@implementation UIButton (ZSYYWebImage)
- (void)hk_setBackgroundImageWithURL:(nullable NSString *)imageURL
                              forState:(UIControlState)state
                           placeholder:(nullable UIImage *)placeholder{
    NSURL *url =[NSURL URLWithString:imageURL];
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder];
    
}
- (void)zsYY_setBackgroundImageWithURL:(nullable NSString *)imageURL
                              forState:(UIControlState)state
                           placeholder:(nullable UIImage *)placeholder{
    NSURL *url =[NSURL URLWithString:imageURL];
    [self yy_setBackgroundImageWithURL:url forState:state placeholder:placeholder];
    
}
- (void)zsyy_setBackgroundImageWithURL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                          completion:(nullable YYWebImageCompletionBlock)completion{
    [self yy_setBackgroundImageWithURL:[NSURL URLWithString:imageURL] forState:state placeholder:placeholder options:options completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        completion(image,url,from,stage,error);
    }];
}
- (void)zsyy_cancelBackgroundImageRequestForState:(UIControlState)state{
    [self yy_cancelBackgroundImageRequestForState:state];
}
- (void)zsyy_cancelImageRequestForState:(UIControlState)state{
    [self yy_cancelImageRequestForState:state];
}
@end
