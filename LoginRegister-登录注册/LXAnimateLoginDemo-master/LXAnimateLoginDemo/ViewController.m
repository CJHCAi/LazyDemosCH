//
//  ViewController.m
//  LXAnimateLoginDemo
//
//  Created by LX Zeng on 2018/12/7.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *usrName;
@property (nonatomic, strong) UITextField *usrPwd;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化view
    [self setupView];
}

#pragma mark - 初始化view
- (void)setupView {
    // 视频
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"login" ofType:@"mp4"]];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    [player play];
    // 蒙板
    UIImageView *maskImgView = [[UIImageView alloc] init];
    [self.view addSubview:maskImgView];
    [maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    maskImgView.image = ImageNamed(@"black");
    
    // 登录
    UILabel *loginLabel = [[UILabel alloc] init];
    [self.view addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(SYS_NavigationBar_HEIGHT+5.5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(81, 36.5));
    }];
    loginLabel.font = AppFont(40);
    loginLabel.textColor = AppHTMLColor(@"ffffff");
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.text = @"登录";
    
    // 请输入用户名
    UIView *userView = [[UIImageView alloc] init];
    [self.view addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    userView.userInteractionEnabled = YES;
    
    UIImageView *bgImgView1 = [[UIImageView alloc] init];
    [userView addSubview:bgImgView1];
    [bgImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView.mas_left).with.offset(0);
        make.top.equalTo(userView.mas_top).with.offset(0);
        make.right.equalTo(userView.mas_right).with.offset(0);
        make.bottom.equalTo(userView.mas_bottom).with.offset(0);
    }];
    bgImgView1.alpha = 0;
    bgImgView1.image = ImageNamed(@"box");
    
    UIImageView *iconImgView1 = [[UIImageView alloc] init];
    [userView addSubview:iconImgView1];
    [iconImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView.mas_left).with.offset(50.5);
        make.centerY.equalTo(userView);
        make.size.mas_equalTo(CGSizeMake(15.5, 18));
    }];
    iconImgView1.alpha = 0;
    iconImgView1.image = ImageNamed(@"user");
    
    self.usrName = [[UITextField alloc] init];
    [userView addSubview:self.usrName];
    [self.usrName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView1.mas_right).with.offset(26.5);
        make.right.equalTo(userView.mas_right).with.offset(-26.5);
        make.centerY.equalTo(userView);
        make.height.mas_equalTo(14);
    }];
    self.usrName.alpha = 0;
    self.usrName.font = AppFont(15);
    self.usrName.textColor = AppHTMLColor(@"ffffff");
    self.usrName.textAlignment = NSTextAlignmentLeft;
    NSString *placeholder1 = @"请输入用户名";
    NSMutableAttributedString *attrsPlaceholder1 = [[NSMutableAttributedString alloc] initWithString:placeholder1];
    [attrsPlaceholder1 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"e5e5e5") range:NSMakeRange(0, placeholder1.length)];
    self.usrName.attributedPlaceholder = attrsPlaceholder1;
    self.usrName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 请输入密码
    UIView *passwordView = [[UIImageView alloc] init];
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    passwordView.userInteractionEnabled = YES;
    
    UIImageView *bgImgView2 = [[UIImageView alloc] init];
    [passwordView addSubview:bgImgView2];
    [bgImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.mas_left).with.offset(0);
        make.top.equalTo(passwordView.mas_top).with.offset(0);
        make.right.equalTo(passwordView.mas_right).with.offset(0);
        make.bottom.equalTo(passwordView.mas_bottom).with.offset(0);
    }];
    bgImgView2.alpha = 0;
    bgImgView2.image = ImageNamed(@"box");
    
    UIImageView *iconImgView2 = [[UIImageView alloc] init];
    [passwordView addSubview:iconImgView2];
    [iconImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.mas_left).with.offset(51);
        make.centerY.equalTo(passwordView);
        make.size.mas_equalTo(CGSizeMake(16, 17));
    }];
    iconImgView2.alpha = 0;
    iconImgView2.image = ImageNamed(@"password");
    
    self.usrPwd = [[UITextField alloc] init];
    [passwordView addSubview:self.usrPwd];
    [self.usrPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView2.mas_right).with.offset(27.5);
        make.right.equalTo(passwordView.mas_right).with.offset(-27.5);
        make.centerY.equalTo(passwordView);
        make.height.mas_equalTo(14);
    }];
    self.usrPwd.alpha = 0;
    self.usrPwd.font = AppFont(15);
    self.usrPwd.textColor = AppHTMLColor(@"ffffff");
    self.usrPwd.textAlignment = NSTextAlignmentLeft;
    NSString *placeholder2 = @"请输入密码";
    NSMutableAttributedString *attrsPlaceholder2 = [[NSMutableAttributedString alloc] initWithString:placeholder2];
    [attrsPlaceholder2 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"e5e5e5") range:NSMakeRange(0, placeholder2.length)];
    self.usrPwd.attributedPlaceholder = attrsPlaceholder2;
    self.usrPwd.secureTextEntry = YES;
    
    // 确认
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).with.offset(55);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    loginBtn.alpha = 0;
    [loginBtn setBackgroundImage:ImageNamed(@"confirm") forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:ImageNamed(@"confirm") forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册账号
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(55.5);
        make.top.equalTo(loginBtn.mas_bottom).with.offset(30.5);
        make.size.mas_equalTo(CGSizeMake(55, 12.5));
    }];
    registerBtn.alpha = 0;
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    NSMutableAttributedString *attrs1 = [[NSMutableAttributedString alloc] initWithString:registerBtn.currentTitle];
    [attrs1 addAttribute:NSFontAttributeName value:AppFont(13) range:[registerBtn.currentTitle rangeOfString:registerBtn.currentTitle]];
    [attrs1 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"f5f5f5") range:[registerBtn.currentTitle rangeOfString:registerBtn.currentTitle]];
    [registerBtn setAttributedTitle:attrs1 forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 忘记密码？
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(30.5);
        make.right.equalTo(self.view.mas_right).with.offset(-56);
        make.size.mas_equalTo(CGSizeMake(70, 12.5));
    }];
    resetBtn.alpha = 0;
    [resetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    NSMutableAttributedString *attrs2 = [[NSMutableAttributedString alloc] initWithString:resetBtn.currentTitle];
    [attrs2 addAttribute:NSFontAttributeName value:AppFont(13) range:[resetBtn.currentTitle rangeOfString:resetBtn.currentTitle]];
    [attrs2 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"f5f5f5") range:[resetBtn.currentTitle rangeOfString:resetBtn.currentTitle]];
    [resetBtn setAttributedTitle:attrs2 forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
#warning 这里可以设置，APP每次启动是否播放视频
    // 动画
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:App_Run_count_KEY] + 1;
    if (runCount == 1) {
        [player play];
        
        [UIView animateWithDuration:1.0 animations:^{
            bgImgView1.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{
                iconImgView1.alpha = 1;
                self.usrName.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0 animations:^{
                    bgImgView2.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1.0 animations:^{
                        iconImgView2.alpha = 1;
                        self.usrPwd.alpha = 1;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:1.5 animations:^{
                            loginBtn.alpha = 1;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:1.5 animations:^{
                                registerBtn.alpha = 1;
                                resetBtn.alpha = 1;
                            }];
                        }];
                    }];
                }];
            }];
        }];
    } else {
        bgImgView1.alpha = 1;
        iconImgView1.alpha = 1;
        self.usrName.alpha = 1;
        bgImgView2.alpha = 1;
        iconImgView2.alpha = 1;
        self.usrPwd.alpha = 1;
        loginBtn.alpha = 1;
        registerBtn.alpha = 1;
        resetBtn.alpha = 1;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:App_Run_count_KEY];
}

#pragma mark - 登录
- (void)loginBtnClick:(UIButton *)sender {
    NSLog(@"=====登录=====");
}

#pragma mark - 注册
- (void)registerBtnClick:(UIButton *)sender {
    NSLog(@"=====注册=====");
}

#pragma mark - 忘记密码
- (void)resetBtnClick:(UIButton *)sender {
    NSLog(@"=====忘记密码=====");
}

@end
