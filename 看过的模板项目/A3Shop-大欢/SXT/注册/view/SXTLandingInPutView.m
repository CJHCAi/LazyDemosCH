//
//  SXTLandingInPutView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTLandingInPutView.h"

@interface SXTLandingInPutView()<UITextFieldDelegate>
@property (strong, nonatomic)   UILabel *tostLabel;              /** 提示label */
@property (strong, nonatomic)   UITextField *userNameText;              /** 手机号text */
@property (strong, nonatomic)   UITextField *passwordText;              /** 密码text */
@property (strong, nonatomic)   UIButton *nextBtn;              /** 下一步button */
@property (strong, nonatomic)   UIButton *goLoginBtn;              /** 去登录 */
@property (strong, nonatomic)   UILabel *textBackLabel;              /** 输入框背景图 */
@property (strong, nonatomic)   UILabel *textLineLabel;              /** text中间的分割线 */
@end

@implementation SXTLandingInPutView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tostLabel];
        [self addSubview:self.textBackLabel];
        [self addSubview:self.userNameText];
        [self addSubview:self.passwordText];
        [self addSubview:self.textLineLabel];
        [self addSubview:self.nextBtn];
        [self addSubview:self.goLoginBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof (self) weakSelf = self;
    
    [_tostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.top.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).offset(15);
    }];
    
    [_textBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@89);
        make.top.equalTo(weakSelf.tostLabel.mas_bottom);
        make.left.equalTo(weakSelf.mas_left).offset(-1);
        make.right.equalTo(weakSelf.mas_right).offset(1);
    }];
    
    [_userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf).offset(15);
        make.height.equalTo(@44);
        make.top.equalTo(weakSelf.textBackLabel.mas_top);
    }];
    
    [_passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf).offset(15);
        make.height.equalTo(@44);
        make.top.equalTo(weakSelf.userNameText.mas_bottom).offset(1);
    }];
    
    [_textLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(weakSelf.textBackLabel.mas_left).offset(15);
        make.right.equalTo(weakSelf.textBackLabel.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.textBackLabel.mas_centerY);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(16);
        make.right.equalTo(weakSelf.mas_right).offset(-16);
        make.height.equalTo(@35);
        make.top.equalTo(weakSelf.passwordText.mas_bottom).offset(15);
    }];
    
    [_goLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 16));
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.top.equalTo(weakSelf.nextBtn.mas_bottom).offset(23);
    }];
}

- (UILabel *)tostLabel{
    if (!_tostLabel) {
        _tostLabel = [[UILabel alloc]init];
        _tostLabel.text = @"请输入手机号码注册新用户";
        _tostLabel.font = [UIFont systemFontOfSize:14.0];
        _tostLabel.textColor = RGB(81, 81, 81);
    }
    return _tostLabel;
}

- (UILabel *)textBackLabel{
    if (!_textBackLabel) {
        _textBackLabel = [[UILabel alloc]init];
        _textBackLabel.backgroundColor = [UIColor whiteColor];
        _textBackLabel.layer.borderWidth = 1;
        _textBackLabel.layer.borderColor = RGB(188, 188, 188).CGColor;
    }
    return _textBackLabel;
}

- (UITextField *)userNameText{
    if (!_userNameText) {
        _userNameText = [[UITextField alloc]init];
        _userNameText.delegate = self;
        _userNameText.placeholder = @"请输入手机号码";
        [_userNameText addTarget:self action:@selector(userNameTextChangeText:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _userNameText;
}
- (UITextField *)passwordText{
    if (!_passwordText) {
        _passwordText = [[UITextField alloc]init];
        _passwordText.delegate = self;
        _passwordText.placeholder = @"设置账号密码";
        _passwordText.secureTextEntry = YES;
        [_passwordText addTarget:self action:@selector(passwordTextChangeText:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _passwordText;
}

- (UILabel *)textLineLabel{
    if (!_textLineLabel) {
        _textLineLabel = [[UILabel alloc]init];
        _textLineLabel.backgroundColor = RGB(188, 188, 188);
    }
    return _textLineLabel;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_nextBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
        _nextBtn.backgroundColor = RGB(229, 229, 229);
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setTitleColor:RGB(132, 132, 132) forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        _nextBtn.selected = NO;

        [_nextBtn addTarget:self action:@selector(pushNextViewController) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextBtn;
}

- (UIButton *)goLoginBtn{
    if (!_goLoginBtn) {
        _goLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_goLoginBtn setTitle:@"去登录" forState:(UIControlStateNormal)];
        [_goLoginBtn setTitleColor:RGB(56, 145, 241) forState:(UIControlStateNormal)];
        _goLoginBtn.backgroundColor = MainColor;
    }
    return _goLoginBtn;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.userNameText && range.location > 10) {
        return NO;
    }
    return YES;
}
#pragma mark -textChange
//用户名修改内容时调用的方法
- (void)userNameTextChangeText:(UITextField *)textfield{
    
    if (textfield.text.length == 11 && _passwordText.text.length > 5) {
        _nextBtn.backgroundColor = RGB(56, 166, 241);
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.selected = YES;
    }else{
        _nextBtn.backgroundColor = RGB(229, 229, 229);
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.selected = NO;
    }
}
//密码输入框修改内容是调用的方法
- (void)passwordTextChangeText:(UITextField *)textfield{
    
    if (textfield.text.length > 5 && _userNameText.text.length == 11) {
        _nextBtn.backgroundColor = RGB(56, 166, 241);
        _nextBtn.userInteractionEnabled = YES;
    }else{
        _nextBtn.backgroundColor = RGB(229, 229, 229);
        _nextBtn.userInteractionEnabled = NO;
    }
}

- (void)pushNextViewController{
    if(_nextBlock){
        _nextBlock(@{@"userName":_userNameText.text,@"password":_passwordText.text});
    }
}
@end
