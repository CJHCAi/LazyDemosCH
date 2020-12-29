//
//  RegisterViewController.m
//  WeChat
//
//  Created by V.Valentino on 16/8/23.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
//#import "EasemobManager.h"


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *EmailTF;
@property (weak, nonatomic) IBOutlet UIButton *regButton;

@property (nonatomic,strong)BmobUser *user;

@end

@implementation RegisterViewController
- (IBAction)reg:(id)sender {
    self.user = [BmobUser new];
    self.user.username = self.userNameTF.text;
    self.user.password = self.passwordTF.text;
    self.user.email = self.EmailTF.text;
    [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            //注册环信
            [[EasemobManager shareManager] registerWithName:self.user.username andPW:self.user.password];
//            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            [app showHomeVC];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请到邮箱验证，已验证返回登陆界面" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该用户名或邮箱已被使用，请重新输入" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置bar的颜色
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"注册";
    //判断是否有输入内容
    if (self.EmailTF.text.length>0&&self.userNameTF.text.length>0&&self.passwordTF.text.length>0) {
        self.regButton.backgroundColor = kRGBA(253, 109, 114, 1);
        self.regButton.enabled = YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.EmailTF.text.length>0&&self.userNameTF.text.length>0&&self.passwordTF.text.length>0) {
        self.regButton.backgroundColor = kRGBA(253, 109, 114, 1);
        self.regButton.enabled = YES;
    }else{
        self.regButton.enabled = NO;
        self.regButton.backgroundColor = [UIColor lightGrayColor];
    }
}


@end
