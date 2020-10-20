//
//  UILabel+Corner.h
//  coder
//
//  Created by Allen Zhong on 15/5/7.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Corner)

+(UIButton *) cornerButton:(UIColor *) bgColor text:(NSString *) text font:(UIFont *)font textColor:(UIColor *) textColor;
+(UIButton *) cornerButton:(UIColor *) bgColor text:(NSString *) text font:(UIFont *)font;
+(UIButton *) cornerButton:(UIColor *) bgColor text:(NSString *) text;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com