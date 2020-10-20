//
//  NSObject+ZJUIExtension.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (ZJUIExtension)

//创建UILabel
+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                      color:(UIColor *)color
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)textAlignment;

//创建UITextField
+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        placeholder:(NSString *)placeholder
                              color:(UIColor *)color
                               font:(UIFont *)font
                    secureTextEntry:(BOOL)secureTextEntry
                           delegate:(id)delegate;

//创建UITextView
+ (UITextView *)textViewWithFrame:(CGRect)frame
                             text:(NSString *)text
                            color:(UIColor *)color
                             font:(UIFont *)font
                    textAlignment:(NSTextAlignment)textAlignment;

//创建UIButton
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                        color:(UIColor *)color
                         font:(UIFont *)font
              backgroundImage:(UIImage *)backgroundImage
                       target:(id)target
                       action:(SEL)action;

//创建UIImageView
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(UIImage *)image;

@end
