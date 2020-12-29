//
//  UIButton+ZSYYWebImage.h
//  HandsUp
//
//  Created by wanghui on 2018/5/12.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+YYWebImage.h"
#import "YYWebImageManager.h"
#import "YYWebImageOperation.h"
@interface UIButton (ZSYYWebImage)
- (void)hk_setBackgroundImageWithURL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder;
- (void)zsYY_setBackgroundImageWithURL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder;
- (void)zsyy_setBackgroundImageWithURL:(nullable NSString *)imageURL
                              forState:(UIControlState)state
                           placeholder:(nullable UIImage *)placeholder
                               options:(YYWebImageOptions)options
                            completion:(nullable YYWebImageCompletionBlock)completion;
- (void)zsyy_cancelBackgroundImageRequestForState:(UIControlState)state;
- (void)zsyy_cancelImageRequestForState:(UIControlState)state;
@end
