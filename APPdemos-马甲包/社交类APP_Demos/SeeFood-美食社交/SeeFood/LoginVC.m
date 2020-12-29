//
//  LoginVC.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "XMPPManager.h"
#import "CoreDataManager.h"
#import "HyTransitions.h"
#import "HyLoglnButton.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "PrefixHeader.pch"
#import <BmobSDK/Bmob.h>

@interface LoginVC () <XMPPStreamDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate> {
    CGRect _frameDefault;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) HyLoglnButton *button;
@property (strong, nonatomic) UserModel *userModel;
@property (weak, nonatomic) IBOutlet UIButton *reg;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //  初始化UI
    [self initUI];
}

//  初始化UI
- (void)initUI {
    _frameDefault = self.view.frame;
    _userName.delegate = self;
    _password.delegate = self;
    
    //  添加button
    _button = [[HyLoglnButton alloc] initWithFrame:CGRectMake(0, 0, 225, 45)];
    _button.hidden = YES;
    [_button setBackgroundColor:[UIColor colorWithRed:0.945 green:0.294 blue:0.157 alpha:1.000]];
    [self.view addSubview:_button];
    [_button setTitle:@"Login" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _button.center = CGPointMake(KScreenWidth / 2, _reg.frame.origin.y - 40);
    _button.hidden = NO;
    _button.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _button.alpha = 1;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginAction:(id)sender {
        //  服务器登陆
    [self loginOnline];
}

#pragma mark - 键盘控制
//  触摸空白处隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignRespondersForTextFields];
}

//  输入焦点切换
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userName) {
        [_password becomeFirstResponder];
    }else {
        [self resignRespondersForTextFields];
    }
    return YES;
}

//  文本框输入view上移
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = -textField.tag * textField.frame.size.height;
    [UIView animateWithDuration:0.24 animations:^{
        [self.view setFrame:newFrame];
    }completion:nil];
}

//  键盘消失恢复frame
-(void)resignRespondersForTextFields {
    [UIView animateWithDuration:0.24 animations:^{
        [self.view setFrame:_frameDefault];
    }completion:nil];
    
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
}

#pragma mark - button动画
//  本地登陆
- (void)localLogine {
    [_button setTitle:@"" forState:UIControlStateNormal];
    //  错误信息
    NSString *error = [self checkUserDetails];
    if (![error isEqualToString:@""]) {
        [self loginFailedWithError:error];
    }else {
        [self loginSucceed];
    }
}

//  登陆成功
-(void)loginSucceed {
    typeof(self) __weak weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_button ExitAnimationCompletion:^{
            [weak didPresentControllerButtonTouch];
        }];
    });
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.logUsername = _userName.text;
    
    [[CoreDataManager shareInstance]insertDataWithUsername:_userName.text];
}

//  登陆失败
-(void)loginFailedWithError:(NSString *)error {
    typeof(self) __weak weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_button ErrorRevertAnimationCompletion:^{
            [weak didPresentControllerButtonTouch];
        }];
    });
    //  打印出错信息
    [self performSelector:@selector(buttonReforme:) withObject:error afterDelay:1.2];
}

-(void)loginOnline {
    __block NSString *message = @"";
//    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
//    [bquery whereKey:@"username" equalTo:_userName.text];
    typeof(self) __weak weak = self;
//    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (error) {
//            //  没有该用户名
//            message = [NSString stringWithFormat:@"Username dose no exist!"];
//            [weak loginFailedWithError:message];
//        }else {
//            BmobUser *user = [array lastObject];
//
////            NSString *pass = user.password;
////            if ([pass isEqualToString:_password.text]) {
////                //  登陆成功
////                [weak loginSucceed];
////            }else {
////                message = [NSString stringWithFormat:@"Roung password!"];
////                [weak loginFailedWithError:message];
////            }
//        }
//    }];
    [BmobUser loginWithUsernameInBackground:_userName.text password:_password.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            message = [NSString stringWithFormat:@"Roung password!"];
            [weak loginFailedWithError:message];
        }else {
            //  登陆成功
            [weak loginSucceed];
        }
    }];
}

//  检查信息
-(NSString *)checkUserDetails {
    NSString *message = @"";
    
    if(![[CoreDataManager shareInstance]checkPassword:_password.text withUsername:_userName.text]) {
        message = [NSString stringWithFormat:@"Roung password!"];
    }
    if (![[CoreDataManager shareInstance]checkUsername:_userName.text]){
        message = [NSString stringWithFormat:@"Username dose no exist!"];
    }
    if ([_userName.text length] < 3){
        message = [NSString stringWithFormat:@"Username is too short!"];
    }
    return message;
}

//  打印出错信息
- (void)buttonReforme:(NSString *)error {
    [_button setTitle:error forState:UIControlStateNormal];
}

//  转场动画
- (void)didPresentControllerButtonTouch
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //  返回该storyboard的程序入口
    TabBarController *main = [storyboard instantiateInitialViewController];
    main.transitioningDelegate = self;
    [self presentViewController:main animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
}

#pragma mark - 服务器
//  登陆成功(代理)
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"登陆成功");
    //  发送登陆状态(在线 离线)
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [sender sendElement:presence];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  登陆失败(代理)
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"登陆失败:%@", error);
    
}

@end
