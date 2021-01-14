//
//  YHWaterMarkView.m
//  YHWaterMarkExample
//
//  Created by wanyehua on 2018/7/4.
//  Copyright © 2018年 万叶华. All rights reserved.
//
// 屏幕宽度
#define UISCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define UISCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "YHWaterMarkView.h"

@interface YHWaterMarkView()
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) UIColor *titleColor;
@end

@implementation YHWaterMarkView

static inline double radians (double degrees) {return degrees * M_PI/180;}

- (id)initWithFrame:(CGRect)frame WithBackgroundColor:(UIColor *)backgroundColor TitleColor:(UIColor *)titleColor UserName:(NSString *)userName PostName:(NSString *)postName {
    if (self = [super initWithFrame:frame]) {
        _userName = userName;
        _postName = postName;
        _titleColor = titleColor;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(context, radians(45.));
    
    NSString *bar = @"--";
    NSString *excessiveText = [[_userName stringByAppendingString:bar]stringByAppendingString:_postName];
    
    NSString *text;
    for (int i = 0; i<excessiveText.length-1; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *rangeText = [[excessiveText substringWithRange:range] stringByAppendingString:@""];
        
        if (text == nil) {
            text = rangeText.copy;
        } else {
            text = [text stringByAppendingString:rangeText];
        }
    }
    
    text = [text stringByAppendingString:[excessiveText substringFromIndex:excessiveText.length-1]];
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,_titleColor,NSForegroundColorAttributeName, nil];
    
    // 画了4个不同位置的水印
    CGFloat Offset = CGRectGetHeight(self.frame)/3;
    CGRect frame1 = CGRectMake(Offset/2+Offset/3+20, Offset/2+Offset/6, UISCREEN_HEIGHT, Offset);// 左上
    CGRect frame2 = CGRectMake(Offset*2, Offset+Offset/4, UISCREEN_HEIGHT, Offset);// 左下
    CGRect frame3 = CGRectMake(Offset/2, -Offset/2, UISCREEN_HEIGHT, Offset); // 右上
    CGRect frame4 = CGRectMake(Offset+Offset/2, Offset/12, UISCREEN_HEIGHT, Offset); // 右下
    
    [text drawInRect:frame1 withAttributes:attributes];
    [text drawInRect:frame2 withAttributes:attributes];
    [text drawInRect:frame3 withAttributes:attributes];
    [text drawInRect:frame4 withAttributes:attributes];
}
@end
