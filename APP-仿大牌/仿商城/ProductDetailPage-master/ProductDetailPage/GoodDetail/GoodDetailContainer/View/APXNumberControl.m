//
//  APXNumberControl.m
//  ZhongHeBao
//
//  Created by 云无心 on 17/1/3.
//  Copyright © 2017年 zhbservice. All rights reserved.
//

#import "APXNumberControl.h"

static CGFloat const   kbtnWidth = 30.f;
static CGFloat const   klineWidth = .5f;
static CGFloat const   kFieldWidth = 66.f;

@interface APXNumberControl() <UITextFieldDelegate>
@property (nonatomic, strong) UILabel   *tipLabel;
@property (nonatomic, strong) UIButton  *decreaseButton;
@property (nonatomic, strong) UIButton  *increaseButton;
@property (nonatomic, strong) UITextField *textField;

/** 自己画border,用图片会发虚 **/
@property (nonatomic, strong) CALayer *decreaseLeftLayer;
@property (nonatomic, strong) CALayer *decreaseUpLayer;
@property (nonatomic, strong) CALayer *decreaseDownLayer;

@property (nonatomic, strong) CALayer *increaseRightLayer;
@property (nonatomic, strong) CALayer *increaseUpLayer;
@property (nonatomic, strong) CALayer *increaseDownLayer;

@property (nonatomic, strong) UIColor *enableColor;
@property (nonatomic, strong) UIColor *disableColor;

@end

@implementation APXNumberControl

- (id)initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        [self addTextFieldBorder];
        [self addButtonBorder];
    }
    return self;
}

- (void)commonInit {
    
    self.minNumber = 1;
    self.maxNumber = 200;
    self.backgroundColor = [UIColor clearColor];
    
    [self setupContentView];
    [self setupContentConstraints];
}

- (void)setupContentView
{
    [self addSubview:self.tipLabel];
    [self addSubview:self.decreaseButton];
    [self addSubview:self.textField];
    [self addSubview:self.increaseButton];
}

- (void)setupContentConstraints
{
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self).offset(15);
        make.leading.mas_equalTo(self.mas_trailing).offset(15.f);
    }];
    [self.decreaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.increaseButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kbtnWidth, kbtnWidth));
        make.leading.mas_equalTo(self.tipLabel);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.increaseButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(66, kbtnWidth));
        make.leading.mas_equalTo(self.decreaseButton.mas_trailing);
    }];
    [self.increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kbtnWidth, kbtnWidth));
        make.leading.mas_equalTo(self.textField.mas_trailing);
    }];
}

#pragma mark - border 用系统border会虚,自己加layer
- (void)addTextFieldBorder
{
    // 在此处,无frame,只能写死
    CALayer *borderUp = [CALayer layer];
    CALayer *borderDown = [CALayer layer];
    CALayer *borderLeft = [CALayer layer];
    CALayer *borderRight = [CALayer layer];
    
    
    borderUp.backgroundColor = self.enableColor.CGColor;
    borderDown.backgroundColor = self.enableColor.CGColor;
    borderRight.backgroundColor = self.enableColor.CGColor;
    borderLeft.backgroundColor = self.enableColor.CGColor;
    
    borderUp.frame = CGRectMake(0, 0, kFieldWidth, klineWidth);
    borderDown.frame = CGRectMake(0, kbtnWidth-klineWidth, kFieldWidth, klineWidth);
    borderLeft.frame = CGRectMake(0, 0, klineWidth, kbtnWidth);
    borderRight.frame = CGRectMake(kFieldWidth-klineWidth, 0, klineWidth, kbtnWidth);
    
    [self.textField.layer addSublayer:borderUp];
    [self.textField.layer addSublayer:borderDown];
    [self.textField.layer addSublayer:borderLeft];
    [self.textField.layer addSublayer:borderRight];
}
- (void)addButtonBorder
{
    [self.decreaseButton.layer addSublayer:self.decreaseLeftLayer];
    [self.decreaseButton.layer addSublayer:self.decreaseUpLayer];
    [self.decreaseButton.layer addSublayer:self.decreaseDownLayer];
    
    [self.increaseButton.layer addSublayer:self.increaseRightLayer];
    [self.increaseButton.layer addSublayer:self.increaseUpLayer];
    [self.increaseButton.layer addSublayer:self.increaseDownLayer];
}


#pragma mark -- Action
// 根据输入值,修改加减按钮的enable
- (void)enableButtonWithValue:(NSInteger) currentNumber {
    _increaseButton.enabled = (currentNumber < _maxNumber);
    _decreaseButton.enabled = (currentNumber > _minNumber);
    
    self.decreaseLeftLayer.backgroundColor = _decreaseButton.enabled ? self.enableColor.CGColor : self.disableColor.CGColor;
    self.decreaseUpLayer.backgroundColor = _decreaseButton.enabled ? self.enableColor.CGColor : self.disableColor.CGColor;
    self.decreaseDownLayer.backgroundColor = _decreaseButton.enabled ? self.enableColor.CGColor : self.disableColor.CGColor;
    
    self.increaseRightLayer.backgroundColor = _increaseButton.enabled ? self.enableColor.CGColor : self.disableColor.CGColor;
    self.increaseUpLayer.backgroundColor = _increaseButton.enabled ? self.enableColor.CGColor : self.disableColor.CGColor;
    self.increaseDownLayer.backgroundColor = _increaseButton.enabled ? self.enableColor.CGColor : self.disableColor.CGColor;
}

#pragma mark -- setter
// 输入值Number,如果Number>max Number=max. 如果Number<min Number=min.
- (void)setMaxNumber:(NSInteger)maxNumber {
    _maxNumber = maxNumber;
    NSInteger currentNumber = [self.textField.text integerValue];
    if (currentNumber > _maxNumber) {
        self.currentValue = currentNumber = _maxNumber;
    }
    [self enableButtonWithValue:currentNumber];
}
- (void)setMinNumber:(NSInteger)minNumber {
    _minNumber = minNumber;
    NSInteger currentNumber = [self.textField.text integerValue];
    if (currentNumber < _minNumber) {
        self.currentValue = currentNumber = _minNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (IBAction)decreaseButtonAction:(id)sender {
    NSInteger currentNumber = [self.textField.text integerValue];
    currentNumber--;
    if (currentNumber >= _minNumber) {
        self.currentValue = currentNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (IBAction)increaseButtonAction:(id)sender {
    NSInteger currentNumber = [self.textField.text integerValue];
    currentNumber++;
    if (currentNumber <= _maxNumber) {
        self.currentValue = currentNumber;
    } else {
        currentNumber = _maxNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (void)setCurrentValue:(NSInteger)currentValue {
    NSInteger result = currentValue;
    if (result > _maxNumber) {
        result = _maxNumber;
    }
    if (result < _minNumber) {
        result = _minNumber;
    }
    self.textField.text = [NSString stringWithFormat:@"%@", @(result)];
    
}


#pragma mark -- getter

- (UITextField *)inputTextField {
    return self.textField;
}

- (UILabel *)leftTipLabel {
    return self.tipLabel;
}

- (NSInteger)currentValue {
    NSInteger currentNumber = [self.textField.text integerValue];
    return currentNumber;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = ColorWithHex(0x555555);
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.text = @"数量";
    }
    return _tipLabel;
}

- (UIButton *)decreaseButton {
    if (!_decreaseButton) {
        _decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_decreaseButton setImage:[UIImage imageNamed:@"bigreduce"] forState:UIControlStateNormal];
        [_decreaseButton setImage:[UIImage imageNamed:@"bigreduce_disable"] forState:UIControlStateDisabled];
        [_decreaseButton addTarget:self action:@selector(decreaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decreaseButton;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = ColorWithHex(0x555555);
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        _textField.text = @"1";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.font = [UIFont boldSystemFontOfSize:14];
//        _textField.layer.borderColor = ColorWithHex(0x555555).CGColor;
//        _textField.layer.borderWidth = .5f;
    }
    return _textField;
}

- (UIButton *)increaseButton {
    if (!_increaseButton) {
        _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseButton setImage:[UIImage imageNamed:@"bigplus"] forState:UIControlStateNormal];
        [_increaseButton setImage:[UIImage imageNamed:@"bigplus_disable"] forState:UIControlStateDisabled];
        [_increaseButton addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseButton;
}

- (UIColor *)enableColor
{
    if (!_enableColor) {
        _enableColor = ColorWithHex(0x555555);
    }
    return _enableColor;
}
- (UIColor *)disableColor
{
    if (!_disableColor) {
        _disableColor = ColorWithHex(0xCCCCCC);
    }
    return _disableColor;
}

- (CALayer *)decreaseLeftLayer
{
    if (!_decreaseLeftLayer) {
        _decreaseLeftLayer = [[CALayer alloc] init];
        _decreaseLeftLayer.frame = CGRectMake(0, 0, klineWidth, kbtnWidth);
    }
    return _decreaseLeftLayer;
}
- (CALayer *)decreaseUpLayer
{
    if (!_decreaseUpLayer) {
        _decreaseUpLayer = [[CALayer alloc] init];
        _decreaseUpLayer.frame = CGRectMake(0, 0, kbtnWidth, klineWidth);
    }
    return _decreaseUpLayer;
}
- (CALayer *)decreaseDownLayer
{
    if (!_decreaseDownLayer) {
        _decreaseDownLayer = [[CALayer alloc] init];
        _decreaseDownLayer.frame = CGRectMake(0, kbtnWidth-klineWidth, kbtnWidth, klineWidth);
    }
    return _decreaseDownLayer;
}
- (CALayer *)increaseRightLayer
{
    if (!_increaseRightLayer) {
        _increaseRightLayer = [[CALayer alloc] init];
        _increaseRightLayer.frame = CGRectMake(kbtnWidth-klineWidth, 0, klineWidth, kbtnWidth);
    }
    return _increaseRightLayer;
}
- (CALayer *)increaseUpLayer
{
    if (!_increaseUpLayer) {
        _increaseUpLayer = [[CALayer alloc] init];
        _increaseUpLayer.frame = CGRectMake(0, 0, kbtnWidth, klineWidth);
    }
    return _increaseUpLayer;
}
- (CALayer *)increaseDownLayer
{
    if (!_increaseDownLayer) {
        _increaseDownLayer = [[CALayer alloc] init];
        _increaseDownLayer.frame = CGRectMake(0, kbtnWidth-klineWidth, kbtnWidth, klineWidth);
    }
    return _increaseDownLayer;
}
#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.currentValue = _minNumber;
        [self enableButtonWithValue:self.currentValue];
    }else{
        self.currentValue = [textField.text integerValue];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *result = [NSMutableString stringWithString:textField.text];
    [result replaceCharactersInRange:range withString:string];
    if (result.length == 0) {
        return YES;
    }
    NSInteger currentNumber = [result integerValue];
    if (currentNumber <= _maxNumber && currentNumber >= _minNumber) {
        // 修改加减button的enable
        [self enableButtonWithValue:currentNumber];
        return YES;
    }
    
    //fix bug http://10.167.201.231:9090/browse/ZHBAPP-1026
    if (currentNumber > _maxNumber) {
        
        self.currentValue = _maxNumber;
        [self enableButtonWithValue:currentNumber];
    }

    
    return NO;
}

@end
