//
//  UIImageView+HKWeb.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HKWeb)
- (void)hk_sd_setImageWithURL:(NSString*)url placeholderImage:(nullable UIImage *)placeholder;
@end
