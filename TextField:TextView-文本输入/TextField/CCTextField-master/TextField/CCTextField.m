//
//  CCTextField.m
//  CCTextField
//
//  Created by cyd on 2017/9/11.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "CCTextField.h"
#import "NSString+CCRegular.h"

// 输入限制
typedef NS_ENUM(NSInteger, CCLimitType){
    CCLimitNone             = 0,       // 全字符
    CCLimitCHZN             = 1 << 0,  // 只能输入中文(用户在输入中文时，会先输入字母，所有如果仅有该限制，就什么也输不进去了)
    CCLimitLetter           = 1 << 1,  // 只能输入字母
    CCLimitNumber           = 1 << 2,  // 只能输入数字
    CCLimitPunctuation      = 1 << 3,  // 只能输入标点
    CCLimitSpecialCharacter = 1 << 4,  // 只能输入特殊字符
    
    // 下面这几个限制，在九宫格输入法时，就不能用了，所以... 它们都不能用，除非能确定用户不用九宫格输入
    CCLimitComma            = 1 << 5,  // 只能输入逗号 ','
    CCLimitAnend            = 1 << 6,  // 只能输入句号 '.'
    CCLimitSpaces           = 1 << 7,  // 只能输入空格 ' '
    CCLimitMinusSign        = 1 << 8,  // 只能输入负号 '-'
};

@interface CCTextField()<UITextFieldDelegate>

@property(nonatomic, assign, readwrite)CCLimitType limit;

@property(nonatomic, assign, readwrite)CCCheckState checkState;

@property(nonatomic, strong, readwrite)UITapGestureRecognizer *tap;

@end

@implementation CCTextField
@synthesize delegate = _delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        super.delegate = self;
        self.returnKeyType = UIReturnKeyDone;
        self.isTapEnd = YES;
        self.minLimit = 0;
        self.maxLimit = INT_MAX;
        
        // 点击手势
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdited:)];

        // 结束编辑事件
        [self addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];

        // 禁止 undo/redo 功能，不然 textDidChanged 方法在做字数限制时，可能会crash
        [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;

        // 键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChanged:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 设置校验类型
-(void)setCheck:(CCCheckType)check
{
    _check = check;

    // 限制初始化
    self.minLimit = 0;
    self.maxLimit = INT_MAX;
    self.limit = CCLimitNone;
    self.secureTextEntry = NO;
    self.keyboardType = UIKeyboardTypeDefault;
    
    switch (check) {
        case CCCheckPassword:
        case CCCheckStrongPassword:
            // 密码 强密码
            self.secureTextEntry = YES;
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case CCCheckAccount:
            // 帐号
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case CCCheckEmail:
            // 邮箱
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case CCCheckDomain:
            // 域名
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case CCCheckZipCode:
            // 邮编
            self.limit = CCLimitNumber;
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case CCCheckTel:
            // 电话
            self.limit = CCLimitNumber | CCLimitPunctuation;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckDate:
            // 日期
            self.limit = CCLimitNumber | CCLimitPunctuation;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckMoney:
            // 金额
            self.limit = CCLimitNumber | CCLimitPunctuation;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckFloat:
            // 浮点数
            self.limit = CCLimitNumber | CCLimitAnend;
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case CCCheckIDCard:
            // 身份证
            self.maxLimit = 18;
            self.limit = CCLimitNumber | CCLimitLetter;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckPhone:
            // 手机
            self.maxLimit = 11;
            self.limit = CCLimitNumber;
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default: break;
    }
}

#pragma mark - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_delegate textFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [_delegate textFieldDidEndEditing:self reason:reason];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_delegate textFieldShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_delegate textFieldShouldEndEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_delegate textFieldShouldClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [_delegate textFieldShouldReturn:self];
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 1.自定义实现输入限制
    if ([_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    // 2.允许回车，不然回车健用不了；允许空字符串，不然删除健用不了
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]){
        return YES;
    }
    
    // 3.字数限制(这里只做用户输入完成后的判断)
    // * 如果没有选中文字，说明输入已完成，此时执行下面的限制判断
    // * 如果有选中文字，说明正在输入，此时不能做限制，因为在中文输入时，必须先输入拼音，这样可能导致最后一个汉字不能输入，但是如果不做限制，用户可能一次输入很多字，导致超出输入限制，这种情况下，我们在 textDidChanged 方法中再做第二次字数限制
    if (!self.markedTextRange) {
        NSString *text = [self.text stringByReplacingCharactersInRange:range withString:string];
        if (self.maxLimit > 0 && text.length > self.maxLimit) {
            return NO;
        }
    }
    
    // 4.检查输入类型
    return [self suitableInput:string];
}

#pragma mark - Action
-(void)endEdited:(UITapGestureRecognizer *)tap{
    if (self.isTapEnd) {
        [tap.view endEditing:YES];
    }
}

-(void)textDidChanged:(UITextField *)textfield{
    if (!self.isFirstResponder) return ;
    
    // 1.字数限制
    NSString * tempString = textfield.text;
    if (textfield.markedTextRange == nil && tempString.length > self.maxLimit && self.maxLimit > 0)
    {
        textfield.text = [tempString substringToIndex:self.maxLimit];
    }
    
    // 2.更新正则校验状态
    [self updateCheckState];
}

#pragma mark - Keyboard
-(void)keyboardWillChanged:(NSNotification *)notify{
    UIWindow *window = [self window];
    if (!window || !self.isFirstResponder) return ;
    
    NSDictionary *dic = [notify userInfo];
    id rect = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    id option = [dic objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    id duration = [dic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGRect frame = [self.superview convertRect:self.frame toView:window];
    CGFloat minY = CGRectGetMinY([rect CGRectValue]);
    CGFloat maxY = CGRectGetMaxY(frame);
    
    // 偏移量
    CGFloat offsetY = minY - maxY;
    // 动画时间
    NSTimeInterval durationValue = [duration floatValue];
    // 动画加速度
    UIViewAnimationOptions optionValue = [option integerValue];
    // 执行动画的view
    UIView *animationView = [self viewController].view;
    if (!animationView) animationView = window;
    
    // 点击手势
    for (UITapGestureRecognizer *tap in window.rootViewController.view.gestureRecognizers) {
        [window.rootViewController.view removeGestureRecognizer:tap];
    }
    
    if (minY >= CGRectGetMaxY(window.frame)) {
        // 收键盘
        [UIView animateWithDuration:durationValue delay:0.0 options:optionValue animations:^{
            animationView.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else if (offsetY < 0){
        // 弹出键盘，需要移动输入框
        [window.rootViewController.view addGestureRecognizer:self.tap];
        
        [UIView animateWithDuration:durationValue delay:0.0 options:optionValue animations:^{
            animationView.transform = CGAffineTransformTranslate(animationView.transform, 0, offsetY);
        } completion:nil];
    } else {
        // 弹出键盘，不需要移动输入框
        [window.rootViewController.view addGestureRecognizer:self.tap];
    }
}

#pragma mark - private
// 更新正则校验状态
-(void)updateCheckState
{
    // 1.空字符串
    if (self.text.length <= 0) {
        self.checkState = CCTextStateEmpty;
        return;
    }
    // 2.超出限制范围
    if (self.maxLimit > 0 && (self.text.length < self.minLimit || self.text.length > self.maxLimit)) {
        self.checkState = CCTextStateNotInLimit;
        return;
    }
    // 3.正则校验
    if ((self.check == CCCheckTel            && ![self.text isTel])          ||
        (self.check == CCCheckDate           && ![self.text isDate])         ||
        (self.check == CCCheckEmail          && ![self.text isEmail])        ||
        (self.check == CCCheckFloat          && ![self.text isFloat])        ||
        (self.check == CCCheckMoney          && ![self.text isMoney])        ||
        (self.check == CCCheckPhone          && ![self.text isPhone])        ||
        (self.check == CCCheckDomain         && ![self.text isDomain])       ||
        (self.check == CCCheckIDCard         && ![self.text isIDCard])       ||
        (self.check == CCCheckAccount        && ![self.text isAccount])      ||
        (self.check == CCCheckZipCode        && ![self.text isZipCode])      ||
        (self.check == CCCheckPassword       && ![self.text isPassword])     ||
        (self.check == CCCheckStrongPassword && ![self.text isStrongPassword])){
        self.checkState = CCTextStateNotRegular;
        return;
    }
    self.checkState = CCTextStateNormal;
}

// 是否允许输入
-(BOOL)suitableInput:(NSString *)text
{
    if (self.limit == CCLimitNone) {
        return YES;
    }
    if ((self.limit & CCLimitCHZN) == CCLimitCHZN) {
        if ([text isCHZN]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitComma) == CCLimitComma) {
        if ([text isComma]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitAnend) == CCLimitAnend) {
        if ([text isAnend]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitLetter) == CCLimitLetter) {
        if ([text isLetter]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitNumber) == CCLimitNumber) {
        if ([text isNumber]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitSpaces) == CCLimitSpaces) {
        if ([text isSpace]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitMinusSign) == CCLimitMinusSign) {
        if ([text isMinusSign]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitPunctuation) == CCLimitPunctuation) {
        if ([text isPunctuation]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitSpecialCharacter) == CCLimitSpecialCharacter) {
        if ([text isSpecialCharacter]) {
            return YES;
        }
    }
    return NO;
}

// 获取view的vc
- (UIViewController *)viewController
{
    if ([[self nextResponder] isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)[self nextResponder];
    }
    for (UIView* next = [self superview]; next; next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
