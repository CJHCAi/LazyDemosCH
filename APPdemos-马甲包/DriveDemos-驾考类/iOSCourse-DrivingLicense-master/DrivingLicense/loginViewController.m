//
//  loginViewController.m
//  DrivingLicense
//
//  Created by 孙伊凡 on 17/2/19.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()

@property (nonatomic, strong) UIButton *signUpBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *signUpBtnSmall;
@property (nonatomic, strong) UIButton *loginBtnSmall;

@end

@implementation loginViewController {
    BOOL isHiddenBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
  
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT)];
    imgView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:imgView];
    
    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT);
    [self.view addSubview:effectView];

    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake((SCREEM_WIDTH - SCREEM_WIDTH * 0.6) / 2 + 20, (self.view.frame.size.height - 30) / 2.5, SCREEM_WIDTH * 0.6, 30)];
    name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入你的用户名" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    name.textColor = [UIColor whiteColor];
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    name.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:name];
    
    UIView *nameLineView = [[UIView alloc] initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame) + 1, name.frame.size.width, 1)];
    nameLineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:nameLineView];
    
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame) + name.frame.size.height / 2, SCREEM_WIDTH * 0.6, 30)];
    password.placeholder = @"密码";
    password.textColor = [UIColor whiteColor];
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入你的密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    password.secureTextEntry = YES;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:password];
    
    
    UIView *passwordLineView = [[UIView alloc] initWithFrame:CGRectMake(password.frame.origin.x, CGRectGetMaxY(password.frame) + 1, password.frame.size.width, 1)];
    passwordLineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:passwordLineView];
    
    UIImageView *nameImg = [[UIImageView alloc] initWithFrame:CGRectMake(name.frame.origin.x - 30, name.frame.origin.y, 28, 30)];
    nameImg.image = [UIImage imageNamed:@"name"];
    [self.view addSubview:nameImg];
    
    UIImageView *passwordImg = [[UIImageView alloc] initWithFrame:CGRectMake(password.frame.origin.x - 32, password.frame.origin.y, 30, 30)];
    passwordImg.image = [UIImage imageNamed:@"password"];
    [self.view addSubview:passwordImg];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - name.frame.size.width) / 2, CGRectGetMaxY(password.frame) + name.frame.size.height * 2, name.frame.size.width, name.frame.size.height)];
    self.loginBtn = loginBtn;
    loginBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setFont:[UIFont systemFontOfSize:14]];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn addTarget:self action:@selector(loginBtnMethon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x, loginBtn.frame.origin.y, loginBtn.frame.size.width, loginBtn.frame.size.height)];
    [self.view addSubview:signUpBtn];
    self.signUpBtn = signUpBtn;
    signUpBtn.backgroundColor = [UIColor colorWithRed:0 green:205/255.0 blue:0 alpha:1];
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signUpBtn setFont:[UIFont systemFontOfSize:14]];
    [signUpBtn setTintColor:[UIColor whiteColor]];
    [signUpBtn addTarget:self action:@selector(signUpBtnMethon) forControlEvents:UIControlEventTouchUpInside];
    signUpBtn.hidden = YES;
    isHiddenBtn = YES;

    
    UIButton *signUpBtnSmall = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - loginBtn.frame.size.width / 2, CGRectGetMaxY(loginBtn.frame) + 5, loginBtn.frame.size.width / 2, 15)];
    [signUpBtnSmall setTitle:@"没有账号？点击注册" forState:UIControlStateNormal];
    self.signUpBtnSmall = signUpBtnSmall;
    signUpBtnSmall.font = [UIFont systemFontOfSize:10];
    [signUpBtnSmall setTitleColor:[UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    [signUpBtnSmall addTarget:self action:@selector(signUpBtnSmallMethon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtnSmall];
    
    UIButton *loginBtnSmall = [[UIButton alloc] initWithFrame:CGRectMake(signUpBtnSmall.frame.origin.x, signUpBtnSmall.frame.origin.y, signUpBtnSmall.frame.size.width, signUpBtnSmall.frame.size.height)];
    [loginBtnSmall setTitle:@"已有账号？点击前往" forState:UIControlStateNormal];
    [loginBtnSmall setTitleColor:[UIColor colorWithRed:0 green:205/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:loginBtnSmall];
    self.loginBtnSmall = loginBtnSmall;
    [loginBtnSmall addTarget:self action:@selector(loginBtnSmallMethon) forControlEvents:UIControlEventTouchUpInside];
    loginBtnSmall.hidden = YES;
    loginBtnSmall.font = [UIFont systemFontOfSize:10];
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 登录
- (void)loginBtnMethon {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpBtnSmallMethon {
    self.signUpBtn.hidden = NO;
    self.loginBtn.hidden = YES;
    self.loginBtnSmall.hidden = NO;
    self.signUpBtnSmall.hidden = YES;
}

// 注册
- (void)signUpBtnMethon {
   
}

- (void)loginBtnSmallMethon {
    self.signUpBtn.hidden = YES;
    self.loginBtn.hidden = NO;
    self.loginBtnSmall.hidden = YES;
    self.signUpBtnSmall.hidden = NO;
}

@end
