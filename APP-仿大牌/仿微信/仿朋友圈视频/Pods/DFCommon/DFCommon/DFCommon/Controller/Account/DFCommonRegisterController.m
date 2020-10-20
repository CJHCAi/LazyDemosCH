//
//  DFCommonRegisterController.m
//  coder
//
//  Created by Allen Zhong on 15/5/7.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFCommonRegisterController.h"
#import "UIButton+Corner.h"

#import "UIBarButtonItem+Lite.h"

#define VerifyCodeResendInterval 60

@interface DFCommonRegisterController()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *phoneNumTextField;
@property (nonatomic,strong) UITextField *verifyCodeTextField;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UIButton *verifyCodeButton;


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger second;


@property (nonatomic, strong) NSString *phoneNum;
@end


@implementation DFCommonRegisterController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = UITableViewStyleGrouped;
        self.title = @"注册";
        _second = VerifyCodeResendInterval;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
    
}

-(void) initView
{
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView:)];
    [self.view addGestureRecognizer:rec];
    
    
}


-(UIBarButtonItem *)rightBarButtonItem
{
    return [UIBarButtonItem text:@"下一步" selector:@selector(onNextStep:) target:self];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSString *identifier = [NSString stringWithFormat:@"cell_%ld",(long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    switch (row) {
            case 0:
        {
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                UIImageView *phoneImageView = [self getIconImageView:@"phone_line_dark"];
                [cell.contentView addSubview:phoneImageView];
                
                _phoneNumTextField =[self getTextField];
                _phoneNumTextField.placeholder = @"手机号";
                [cell.contentView addSubview:_phoneNumTextField];
                
            }
            break;
        }
            case 1:
        {
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                
                UIImageView *codeImageView = [self getIconImageView:@"more_line_dark"];
                [cell.contentView addSubview:codeImageView];
                

                _verifyCodeTextField = [self getTextField];
                _verifyCodeTextField.placeholder = @"验证码";
                [cell.contentView addSubview:_verifyCodeTextField];
                
                
                _verifyCodeButton = [UIButton cornerButton:[self mainColor] text:@"获取验证码" font:[UIFont systemFontOfSize:14]];
                _verifyCodeButton.frame = CGRectMake(self.view.frame.size.width-100, 16, 90, 30);
                [_verifyCodeButton addTarget:self action:@selector(onSendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_verifyCodeButton];
            }
            
            
            break;
        }
            case 2:
        {
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                UIImageView *passwordImageView = [self getIconImageView:@"unlock_line_dark"];
                [cell.contentView addSubview:passwordImageView];

                _passwordTextField = [self getTextField];
                _passwordTextField.placeholder = @"设定一个密码";
                _passwordTextField.delegate = self;
                _passwordTextField.secureTextEntry = YES;
                [cell.contentView addSubview:_passwordTextField];
                
                }
            
            break;
        }
        default:
            break;
    }
    
//    _phoneNumTextField.text = @"18680551729";
//    _verifyCodeTextField.text = @"123456";
//    _passwordTextField.text = @"123456";

    return cell;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_passwordTextField resignFirstResponder];
    return YES;
}



#pragma mark - Method

-(UIImageView *) getIconImageView:(NSString *)icon
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 32, 32)];
    iconImageView.image = [UIImage imageNamed:icon];
    iconImageView.hidden = YES;
    return iconImageView;
}

-(UITextField *) getTextField
{
    UITextField  *textField = [[UITextField alloc] initWithFrame:CGRectMake(23, 0, self.view.frame.size.width, 65)];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTextField.borderStyle = UITextBorderStyleNone;
    return textField;
}


-(UIColor *) mainColor
{
    return [UIColor darkGrayColor];
}



-(void) onTapView:(UITapGestureRecognizer *) rec
{
    [_passwordTextField resignFirstResponder];
    [_phoneNumTextField resignFirstResponder];
    [_verifyCodeTextField resignFirstResponder];
}




-(void) onSendVerifyCode:(UIButton *) button
{
    if ([_phoneNumTextField.text isEqualToString:@""]) {
        [self hudShowText:@"请填写手机号"];
        return;
    }
    
    [self onSendVerifyCode];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];

    _verifyCodeButton.userInteractionEnabled = NO;
    _verifyCodeButton.backgroundColor = [UIColor lightGrayColor];

    _phoneNum = _phoneNumTextField.text;
}



-(void) countDown:(NSTimer *) timer
{
    if (_second == 0) {
        _second = VerifyCodeResendInterval;
        _verifyCodeButton.userInteractionEnabled = YES;
        _verifyCodeButton.backgroundColor = [self mainColor];
        [_verifyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer invalidate];
    }else{
        _second--;
        [_verifyCodeButton setTitle:[NSString stringWithFormat:@"%lu秒后重发",(unsigned long)_second] forState:UIControlStateNormal];
    }
}



-(void) onSendVerifyCode
{
    
}


-(void)onNextStep
{
    
}



-(NSString *) getPhoneNum
{
    return _phoneNumTextField.text;
}
-(NSString *) getCode
{
    return _verifyCodeTextField.text;
}
-(NSString *) getPassword
{
    return _passwordTextField.text;
}




-(void) onNextStep:(id) sender
{
    
    if ([[self getPhoneNum] isEqualToString:@""]) {
        [self hudShowText:@"请填写手机号"];
        return;
    }
    
    if ([[self getPassword] isEqualToString:@""]) {
        [self hudShowText:@"请填写密码"];
        return;
    }
    
    
    if ([[self getPassword] isEqualToString:@""]) {
        [self hudShowText:@"请填写密码"];
        return;
    }
    
    
    [self.timer invalidate];
    
    [self onNextStep];
}


@end
