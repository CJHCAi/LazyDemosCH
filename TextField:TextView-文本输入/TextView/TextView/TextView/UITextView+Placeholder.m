//
//  UITextView+Placeholder.m
//  TextView
//
//  Created by 初程程 on 2017/7/6.
//  Copyright © 2017年 初程程. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>
static const char placeholderKey = '\3';
static const char placeholderColorKey = '\4';
static const char placeholderLabelKey = '\5';
static const char maxInputLengthKey = '\6';
static UILabel *placeholderLabel;
@implementation UITextView (Placeholder)

+ (void)load{
    Method dealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method ccc_dealloc = class_getInstanceMethod(self, @selector(ccc_dealloc));
    method_exchangeImplementations(dealloc, ccc_dealloc);
    
    Method initWithFrame = class_getInstanceMethod(self, NSSelectorFromString(@"initWithFrame:"));
    Method ccc_initWithFrame = class_getInstanceMethod(self, @selector(ccc_initWithFrame:));
    method_exchangeImplementations(initWithFrame, ccc_initWithFrame);

    Method drawRect = class_getInstanceMethod(self, NSSelectorFromString(@"drawRect:"));
    Method ccc_drawRect = class_getInstanceMethod(self, @selector(ccc_drawRect:));
    method_exchangeImplementations(drawRect, ccc_drawRect);
    
    Method setText = class_getInstanceMethod(self, NSSelectorFromString(@"setText:"));
    Method ccc_setText = class_getInstanceMethod(self, @selector(ccc_setText:));
    method_exchangeImplementations(setText, ccc_setText);
    
    Method setFont = class_getInstanceMethod(self, NSSelectorFromString(@"setFont:"));
    Method ccc_setFont = class_getInstanceMethod(self, @selector(ccc_setFont:));
    method_exchangeImplementations(setFont, ccc_setFont);
    
    Method setAttributedText = class_getInstanceMethod(self, NSSelectorFromString(@"setAttributedText:"));
    Method ccc_setAttributedText = class_getInstanceMethod(self, @selector(ccc_setAttributedText:));
    method_exchangeImplementations(setAttributedText, ccc_setAttributedText);
}
- (void)drawRect:(CGRect)rect{
    
}
- (void)ccc_drawRect:(CGRect)rect{
    
    
    if (self.hasText) {
        return;
    }
    /**
     placeholder文字的绘制情况跟自身的text 属性相关，
     所以要重写set方法去调用drawRect方法（setNeedsDisplay）
     **/
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:self.placeholderAttributes];
}
- (instancetype)ccc_initWithFrame:(CGRect)frame{
    [self ccc_initWithFrame:frame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ccc_textViewDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    return self;
}
- (void)ccc_dealloc{
    if (self==[UITextView class]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
        
    }
}
- (void)setPlacehoderLabel:(UILabel *)placehoderLabel{
    objc_setAssociatedObject(self, &placeholderLabelKey, placehoderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (void)setPlaceholder:(NSString *)placeholder{
    
    objc_setAssociatedObject(self, &placeholderKey, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}
- (void)setPlaceholderAttributes:(NSDictionary *)placeholderAttributes{
    objc_setAssociatedObject(self, &placeholderColorKey, placeholderAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}
- (void)setMaxInputLength:(NSInteger)maxInputLength{
    objc_setAssociatedObject(self, &maxInputLengthKey, @(maxInputLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)maxInputLength{
    NSNumber *inputNumber = objc_getAssociatedObject(self, &maxInputLengthKey);
    return inputNumber.integerValue;
}
- (NSString *)placeholder{
    return objc_getAssociatedObject(self, &placeholderKey);
}
- (NSDictionary *)placeholderAttributes{
    return objc_getAssociatedObject(self, &placeholderColorKey);
}
- (UILabel *)placehoderLabel{
    return objc_getAssociatedObject(self, &placeholderLabelKey);
}
- (void)ccc_setText:(NSString *)text{
    [self ccc_setText:text];
    [self setNeedsDisplay];
}
- (void)ccc_setAttributedText:(NSAttributedString *)attributedText{
    [self ccc_setAttributedText:attributedText];
    [self setNeedsDisplay];
}
- (void)ccc_setFont:(UIFont *)font{
    [self ccc_setFont:font];
    [self setNeedsDisplay];
}
- (void)ccc_textViewDidChangeNotification:(NSNotification *)notification{
    [self setNeedsDisplay];
    if (self.maxInputLength<=0) {
        return;
    }
    NSString *InputMethodType = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    // 如果当前输入法为汉语输入法
    if ([InputMethodType isEqualToString:@"zh-Hans"]) {
        
        // 获取选中部分
        UITextRange *selectedRange = [self markedTextRange];
        
        //获取选中部分的偏移量, 此部分为用户未决定输入部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 当没有标记部分时截取字符串
        if (position == nil) {
            self.text = [self textViewCurrentText];
        }
    }else {
        self.text = [self textViewCurrentText];
    }
}
- (NSString *)textViewCurrentText{
    return self.text.length>self.maxInputLength?[self.text substringToIndex:self.maxInputLength]:self.text;
}
@end
