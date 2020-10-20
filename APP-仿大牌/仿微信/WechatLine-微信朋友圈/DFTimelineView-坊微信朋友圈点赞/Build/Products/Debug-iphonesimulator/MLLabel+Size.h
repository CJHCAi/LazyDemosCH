//
//  MLLabel+Size.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/10/3.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLLabel.h"
#import "MLLinkLabel.h"

@interface MLLabel (Size)

+(CGSize) getViewSize:(NSAttributedString *)attributedText maxWidth:(CGFloat) maxWidth font:(UIFont *) font lineHeight:(CGFloat) lineHeight lines:(NSUInteger)lines;


+(CGSize) getViewSizeByString:(NSString *)text maxWidth:(CGFloat) maxWidth font:(UIFont *) font lineHeight:(CGFloat) lineHeight lines:(NSUInteger)lines;

+(CGSize) getViewSizeByString:(NSString *)text maxWidth:(CGFloat) maxWidth font:(UIFont *) font;

+(CGSize) getViewSizeByString:(NSString *)text font:(UIFont *) font;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com