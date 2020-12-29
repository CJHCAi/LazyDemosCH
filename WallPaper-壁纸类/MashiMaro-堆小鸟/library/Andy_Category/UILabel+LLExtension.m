//
//  UILabel+LLExtension.m
//  Andy_Category
//
//  Created by 933 on 15/12/29.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "UILabel+LLExtension.h"

@implementation UILabel (LLExtension)

//普通的文字label
+(instancetype)LL_createLabelWithFrame:(CGRect)frame
                                  text:(NSString *)text
                            titleColor:(UIColor *)textColor
                         textAlignment:(NSTextAlignment)textAlignment
                                  font:(UIFont *)font
{
    UILabel *l = [[UILabel alloc]initWithFrame:frame];
    l.text = text;
    l.textColor = textColor;
    l.textAlignment = textAlignment;
    l.font = font;
    return l;
}
//根据字符串长度自适应label
+(instancetype)LL_createAdaptiveLabelWithFrame:(CGRect)frame
                                          text:(NSString *)text
                                    titleColor:(UIColor *)textColor
                                          font:(UIFont *)font
                                 numberOfLines:(NSInteger)numberOfLines
{
    UILabel *l = [[UILabel alloc]initWithFrame:frame];
    l.lineBreakMode = NSLineBreakByWordWrapping;
    l.numberOfLines = 0;
    l.textColor = textColor;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 5.0f;
    [att addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, text.length)];
    [att addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    l.attributedText = att;
    CGSize size = [l sizeThatFits:CGSizeMake(l.frame.size.width, MAXFLOAT)];
    frame = l.frame;
    frame.size.height = size.height;
    [l setFrame:frame];
    return l;
}

@end
