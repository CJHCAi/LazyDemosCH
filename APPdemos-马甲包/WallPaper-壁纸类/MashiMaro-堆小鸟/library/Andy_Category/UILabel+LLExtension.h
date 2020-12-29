//
//  UILabel+LLExtension.h
//  Andy_Category
//
//  Created by 933 on 15/12/29.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LLExtension)

/**
 *  创建Label
 *
 *  @param frame         frame
 *  @param title         文字
 *  @param textColor     文字颜色
 *  @param textAlignment 对齐方式
 *  @param font          字体
 */

+(instancetype)LL_createLabelWithFrame:(CGRect)frame
                                 text:(NSString *)text
                            titleColor:(UIColor *)textColor
                         textAlignment:(NSTextAlignment)textAlignment
                                  font:(UIFont *)font;

/**
 *  自适应Label
 *
 *  @param frame          frame
 *  @param title          文字
 *  @param textColor      文字颜色
 *  @param font           字体
 *  @param numberOfLines  行数
 */
+(instancetype)LL_createAdaptiveLabelWithFrame:(CGRect)frame
                                  text:(NSString *)text
                            titleColor:(UIColor *)textColor
                                  font:(UIFont *)font
                         numberOfLines:(NSInteger)numberOfLines;



@end
