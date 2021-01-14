//
//  UIImage+Fit.h
//  QQ_Zone
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Fit)

/**
 *  传入图片名称,返回拉伸好的图片
 */
+ (UIImage *)resizeImage:(NSString *)imageName;

@end
