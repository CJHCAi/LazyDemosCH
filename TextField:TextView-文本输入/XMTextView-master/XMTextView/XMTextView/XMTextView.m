//
//  XMTextView.m
//  XMTextView
//
//  Created by XM on 2018/6/29.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "XMTextView.h"
#import "UITextView+XMExtension.h"

@interface XMTextView ()<UITextViewDelegate>

/** textView */
@property (nonatomic, weak) UITextView *textView;
/** num */
@property (nonatomic, weak) UILabel *numLabel;
/** 是否基本信息初始化了 */
@property (nonatomic, assign) BOOL isConfigInit;
/** 占位文字 */
@property (nonatomic, copy) NSString *tempText;

@end

@implementation XMTextView

- (UITextView *)textView{
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.textAlignment = NSTextAlignmentJustified;
        [self addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:numLabel];
        _numLabel = numLabel;
    }
    return _numLabel;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 未初始化
        if (!self.isConfigInit){
            
            // 添加配置
            [self addConfig];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 未初始化
        if (!self.isConfigInit){
            
            // 添加配置
            [self addConfig];
        }
    }
    return self;
}

#pragma mark - 添加配置
- (void)addConfig{
    
    self.isSetBorder = YES;
    self.borderLineWidth = 1;
    self.borderLineColor = [UIColor lightGrayColor];
    self.topSpace = 8;
    self.leftAndRightSpace = 8;
    self.textMaxNum = 200;
    self.textColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:14];
    self.placeholder = @"请输入内容";
    self.placeholderColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.maxNumColor = [UIColor blackColor];
    self.maxNumFont = [UIFont systemFontOfSize:12];
    self.maxNumState = XMMaxNumStateNormal;
    
    self.isConfigInit = YES;
    
    // 显示内容
    [self showContent];
}

- (void)setIsSetBorder:(BOOL)isSetBorder{
    
    _isSetBorder = isSetBorder;
    
    [self showContent];
}

- (void)setTextMaxNum:(int)textMaxNum{
    
    _textMaxNum = textMaxNum;
    
    [self showContent];
}

- (void)setText:(NSString *)text{
    
    _text = text;
    self.tempText = text;
    [self showContent];
}

- (void)setBorderLineColor:(UIColor *)borderLineColor{
    
    _borderLineColor = borderLineColor;
    
    [self showContent];
}

- (void)setBorderLineWidth:(CGFloat)borderLineWidth{
    
    _borderLineWidth = borderLineWidth;
    
    [self showContent];
}

- (void)setTextColor:(UIColor *)textColor{
    
    _textColor = textColor;
    
    [self showContent];
}

- (void)setTextFont:(UIFont *)textFont{
    
    _textFont = textFont;
    
    [self showContent];
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    
    [self showContent];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    _placeholderColor = placeholderColor;
    
    [self showContent];
}

- (void)setMaxNumColor:(UIColor *)maxNumColor{
    
    _maxNumColor = maxNumColor;
    
    [self showContent];
}

- (void)setMaxNumFont:(UIFont *)maxNumFont{
    
    _maxNumFont = maxNumFont;
    
    [self showContent];
}

- (void)setMaxNumState:(XMMaxNumState)maxNumState{
    
    _maxNumState = maxNumState;
    
    [self showContent];
}

#pragma mark - 显示内容
- (void)showContent{
    
    // 布局
    [self layoutFrame];
    
    // 重新配置信息
    if (self.isSetBorder) {
        self.layer.borderWidth = self.borderLineWidth;
        self.layer.borderColor = self.borderLineColor.CGColor;
    }else{
        self.layer.borderWidth = 0.00;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    self.textView.textColor = self.textColor;
    self.textView.font = self.textFont;
    self.numLabel.textColor = self.maxNumColor;
    self.numLabel.font = self.maxNumFont;
    
    self.textView.placeholder = self.placeholder;
    self.textView.placeholderColor = self.placeholderColor;
    
    self.textView.text = self.tempText;
    
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.textView.text.length>self.textMaxNum) {
        self.textView.text = [self.textView.text substringToIndex:self.textMaxNum];
    }
    
    if (self.maxNumState == XMMaxNumStateNormal) {
        
        self.numLabel.text = [NSString stringWithFormat:@"%d/%d",self.textView.text.length,self.textMaxNum];
    }else{
        
        self.numLabel.text = [NSString stringWithFormat:@"%d",self.textMaxNum-self.textView.text.length];
    }
    
    if (self.textViewListening) {
        self.textViewListening(self.textView.text);
    }
    self.tempText = self.textView.text;
}

#pragma mark - 布局
- (void)layoutFrame{
    
    self.numLabel.frame = CGRectMake(self.leftAndRightSpace, self.frame.size.height-30, self.frame.size.width-2*self.leftAndRightSpace, 30);
    self.textView.frame = CGRectMake(self.leftAndRightSpace, self.topSpace, self.numLabel.frame.size.width, self.frame.size.height-40);
}

- (void)dealloc{
    
    //    NSLog(@"dealloc");
    [self removeFromSuperview];
}

@end
