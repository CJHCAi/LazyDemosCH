/*
 The MIT License (MIT)
 Copyright © 2018 Scott Ban, <scottban@126.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


#import "BDStepper.h"

#define defaultW 25
#define UICOLOR_HEX(_color) UICOLOR_RGB_Alpha(_color,1)
#define UICOLOR_BIG [UIColor colorWithRed:106.0f/255 green:115.0f/255 blue: 125.0f/255 alpha:1.0f]
#define PingFangSCMedium @"PingFangSC-Medium"
#define PingFangSCRegular @"PingFangSC-Regular"
#define FontMaker(_fontName,_size) [UIFont fontWithName:_fontName size:_size]

@interface BDStepper()
@property (nonatomic,strong) UIButton *minusBtn,*plusBtn;
@property (nonatomic,strong) UIView *lineSepLeft,*lineSepRight; //分割线
@property (nonatomic,strong) UITextField *textField;
@end
@implementation BDStepper

- (id)new
{
    return [self initWithFrame:CGRectZero];
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _canEdit = YES;
        
        self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.textField = [[UITextField alloc] init];
        self.lineSepLeft = [[UIView alloc] init];
        self.lineSepRight = [[UIView alloc] init];
        
        [self addSubview:self.minusBtn];
        [self addSubview:self.plusBtn];
        [self addSubview:self.textField];
        [self addSubview:self.lineSepLeft];
        [self addSubview:self.lineSepRight];
        
        [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
        self.minusBtn.titleLabel.font = FontMaker(PingFangSCRegular, 12);
        [self.minusBtn addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchDown];
        
        [self.plusBtn setTitle:@"+" forState:UIControlStateNormal];
        self.plusBtn.titleLabel.font = FontMaker(PingFangSCRegular, 12);
        [self.plusBtn addTarget:self action:@selector(plus) forControlEvents:UIControlEventTouchDown];

        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textField.font = FontMaker(PingFangSCRegular, 12);
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.text = @"0";
        
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        
        [self setEditableStyle];
        
        //layout use masonry
        [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(self);
            make.width.mas_equalTo(defaultW);
        }];
        
        [self.lineSepLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.minusBtn.mas_right);
            make.top.and.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
        
        [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.and.bottom.equalTo(self);
            make.width.mas_equalTo(defaultW);
        }];
        
        [self.lineSepRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.plusBtn.mas_left);
            make.top.and.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.left.equalTo(self.lineSepLeft.mas_right);
            make.right.equalTo(self.lineSepRight.mas_left);
        }];
        
        [self.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setEditableStyle
{
    self.layer.borderColor= UICOLOR_HEX(0x666666).CGColor;

    self.lineSepLeft.backgroundColor =
    self.lineSepRight.backgroundColor=
    self.textField.textColor = UICOLOR_HEX(0x666666);
    
    [self.minusBtn setTitleColor:UICOLOR_HEX(0x666666) forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:UICOLOR_HEX(0x666666) forState:UIControlStateNormal];
}

- (void)setUnEditableStyle
{
    self.layer.borderColor= UICOLOR_HEX(0xcccccc).CGColor;
    
    self.lineSepLeft.backgroundColor =
    self.lineSepRight.backgroundColor=
    self.textField.textColor = UICOLOR_HEX(0xcccccc);
    
    [self.minusBtn setTitleColor:UICOLOR_HEX(0xcccccc) forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:UICOLOR_HEX(0xcccccc) forState:UIControlStateNormal];
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    
    if (canEdit) {
        [self setEditableStyle];
    }else{
        [self setUnEditableStyle];
    }
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    self.textField.text = [NSString stringWithFormat:@"%li",(long)number];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"] && object == self.textField) {
        NSString *newStr = change[@"new"];
//        _number = [newStr integerValue];
        
//        if (self.valueChangedCallback) {
//            self.valueChangedCallback();
//        }
    }
}

#pragma mark - action

- (void)minus
{
    if (self.canEdit) {
        _number--;
        if (_number<0) {
            _number = 0;
        }
        self.textField.text = [NSString stringWithFormat:@"%li",(long)_number];
    }
    
    if (self.valueChangedCallback) {
        self.valueChangedCallback();
    }
}

- (void)plus
{
    if (self.canEdit) {
        _number++;
        self.textField.text = [NSString stringWithFormat:@"%li",(long)_number];
    }
    if (self.valueChangedCallback) {
        self.valueChangedCallback();
    }
}

- (void)dealloc
{
    [self removeObserver:self.textField forKeyPath:@"text"];
}
@end
