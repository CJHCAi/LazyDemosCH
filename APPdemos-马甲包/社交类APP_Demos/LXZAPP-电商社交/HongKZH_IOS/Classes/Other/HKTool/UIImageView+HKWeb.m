//
//  UIImageView+HKWeb.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "UIImageView+HKWeb.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (HKWeb)
- (void)hk_sd_setImageWithURL:(NSString*)url placeholderImage:(nullable UIImage *)placeholder {
    NSURL *imageUrl = [NSURL URLWithString:url];
    [self sd_setImageWithURL:imageUrl placeholderImage:placeholder ];
}
@end
