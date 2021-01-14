//
//  LoginViewController.m
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *remPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;

// 登录的View
@property (weak, nonatomic) IBOutlet UIView *loginView;
// 提示的View
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

/*
 点击按钮之后登录
 */
- (IBAction)login;
/*
 记住密码
 */
- (IBAction)remPassword:(UIButton *)sender;
/*
 自动登录
 */
- (IBAction)autoLogin:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)login {
    // 0.退出键盘
    [self.view endEditing:YES];
    
    // 1.拿到帐号和密码
    NSString *account = self.accountField.text;
    NSString *password = self.passwordField.text;
    
    // 2.判断帐号和密码是否为空
    if (account.length == 0 || password.length == 0) {
        // 给用户提示
        [self showError:@"帐号或者密码不能为空"];
        
        return;
    }
    
    // 3.拿到用户的帐号和密码,去服务器请求,判断帐号和密码是否正确
    CGFloat duration = 0.0;
    [self.activityView startAnimating];
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([account isEqualToString:@"123"] && [password isEqualToString:@"123"]) { // 登录成功,到下一个界面
            // self.view.window.rootViewController = [[MainViewController alloc] init];
            MainViewController *mainVc = [[MainViewController alloc] init];
            [self presentViewController:mainVc animated:YES completion:nil];
        } else { // 登录失败
            // 给用户提示
            [self showError:@"帐号或者密码错误"];
        }
        
        [self.activityView stopAnimating];
        self.view.userInteractionEnabled = YES;
    });
}

- (void)showError:(NSString *)error
{
    // 1.弹出弹窗
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    // 2.给登录按钮一个动画效果
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnim.values = @[@-10, @0, @10, @0];
    shakeAnim.repeatCount = 3;
    shakeAnim.duration = 0.1;
    [self.loginView.layer addAnimation:shakeAnim forKey:nil];
}


#pragma mark - 自动登录和记住密码
- (IBAction)remPassword:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected == NO) {
        self.autoLoginBtn.selected = NO;
    }
}

- (IBAction)autoLogin:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected == YES) {
        self.remPasswordBtn.selected = YES;
    }
}


#pragma mark - 实现TextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountField) { // 点击了next
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) { // 点击了down
        [self login];
    }
    
    return YES;
}

@end
