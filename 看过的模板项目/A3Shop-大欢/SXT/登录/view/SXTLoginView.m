//
//  SXTLoginView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/21.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTLoginView.h"

@interface SXTLoginView()<UITextFieldDelegate>

@property (strong, nonatomic)   UITextField *userNameText;              /** 手机号text */
@property (strong, nonatomic)   UITextField *passwordText;              /** 密码text */
@property (strong, nonatomic)   UIButton *LoginBtn;              /** 登录button */
@property (strong, nonatomic)   UIButton *goLandingBtn;              /** 去注册 */
@property (strong, nonatomic)   UILabel *textBackLabel;              /** 输入框背景图 */
@property (strong, nonatomic)   UILabel *textLineLabel;              /** text中间的分割线 */

@end

@implementation SXTLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textBackLabel];
        [self addSubview:self.userNameText];
        [self addSubview:self.passwordText];
        [self addSubview:self.textLineLabel];
        [self addSubview:self.LoginBtn];
        [self addSubview:self.goLandingBtn];

    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof (self) weakSelf = self;
    
    [_textBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@89);
        make.top.equalTo(weakSelf.mas_top).offset(15);
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
    
    [_LoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(16);
        make.right.equalTo(weakSelf.mas_right).offset(-16);
        make.height.equalTo(@35);
        make.top.equalTo(weakSelf.passwordText.mas_bottom).offset(15);
    }];
    
    [_goLandingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 16));
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.top.equalTo(weakSelf.LoginBtn.mas_bottom).offset(23);
    }];
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
        _passwordText.placeholder = @"请输入密码";
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

- (UIButton *)LoginBtn{
    if (!_LoginBtn) {
        _LoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_LoginBtn setTitle:@"登 录" forState:(UIControlStateNormal)];
        _LoginBtn.backgroundColor = RGB(229, 229, 229);
        _LoginBtn.userInteractionEnabled = NO;
        [_LoginBtn setTitleColor:RGB(132, 132, 132) forState:(UIControlStateNormal)];
        [_LoginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        _LoginBtn.selected = NO;
        
        [_LoginBtn addTarget:self action:@selector(pushNextViewController) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _LoginBtn;
}

- (UIButton *)goLandingBtn{
    if (!_goLandingBtn) {
        _goLandingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_goLandingBtn setTitle:@"去注册" forState:(UIControlStateNormal)];
        [_goLandingBtn setTitleColor:RGB(56, 145, 241) forState:(UIControlStateNormal)];
        _goLandingBtn.backgroundColor = MainColor;
    }
    return _goLandingBtn;
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
        _LoginBtn.backgroundColor = RGB(56, 166, 241);
        _LoginBtn.userInteractionEnabled = YES;
        _LoginBtn.selected = YES;
    }else{
        _LoginBtn.backgroundColor = RGB(229, 229, 229);
        _LoginBtn.userInteractionEnabled = NO;
        _LoginBtn.selected = NO;
    }
}
//密码输入框修改内容是调用的方法
- (void)passwordTextChangeText:(UITextField *)textfield{
    
    if (textfield.text.length > 5 && _userNameText.text.length == 11) {
        _LoginBtn.backgroundColor = RGB(56, 166, 241);
        _LoginBtn.userInteractionEnabled = YES;
    }else{
        _LoginBtn.backgroundColor = RGB(229, 229, 229);
        _LoginBtn.userInteractionEnabled = NO;
    }
}

- (void)pushNextViewController{
    if(_loginBlock){
        _loginBlock(@{@"LoginName":_userNameText.text,@"Lpassword":_passwordText.text});
    }
}
@end
