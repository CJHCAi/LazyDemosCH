//
//  UITextField+DynamicFontSize.m
//  Created by kcandr on 16/12/14.

#import <Foundation/Foundation.h>
#import "UITextField+DynamicFontSize.h"
#import "IQLabelView.h"

@implementation UITextField (DynamicFontSize)

#define CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE 101
#define CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE 9

- (void)adjustsFontSizeToFillItsContents
{
    NSString *text = self.text;
    
    for (int i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE; i > CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE; i--) {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                             attributes:@{ NSFontAttributeName : font }];
        
        CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        
        if (CGRectGetHeight(rectSize) <= CGRectGetHeight(self.frame)) {
            ((IQLabelView *)self.superview).fontSize = (CGFloat)i-1;
            break;
        }
    }
}

- (void)adjustsFontSizeToFillRect:(CGRect)newBounds
{
    NSString *text = self.text;
    
    for (int i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE; i > CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE; i--) {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                             attributes:@{ NSFontAttributeName : font }];
        
        CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(newBounds)-24, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        
        if (CGRectGetHeight(rectSize) <= CGRectGetHeight(newBounds)) {
            ((IQLabelView *)self.superview).fontSize = (CGFloat)i-1;
            break;
        }
    }
}

- (void)adjustsWidthToFillItsContents
{
    NSString *text = self.text;
    UIFont *font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{ NSFontAttributeName : font }];
    
    CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame)-24)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
    
    float w1 = (ceilf(rectSize.size.width) + 24 < 50) ? self.frame.size.width : ceilf(rectSize.size.width) + 24;
    float h1 =(ceilf(rectSize.size.height) + 24 < 50) ? 50 : ceilf(rectSize.size.height) + 24;
    
    CGRect viewFrame = self.superview.bounds;
    viewFrame.size.width = w1 + 24;
    viewFrame.size.height = h1;
    self.superview.bounds = viewFrame;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
