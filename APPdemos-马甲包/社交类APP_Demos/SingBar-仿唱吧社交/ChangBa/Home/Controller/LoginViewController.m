//
//  LoginViewController.m
//  WeChat
//
//  Created by V.Valentino on 16/8/23.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
//#import "EasemobManager.h"
#import "RegisterViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginViewController
#pragma mark - 方法 Methods

- (IBAction)login:(id)sender {
    if (self.userNameTF.text.length>0&&self.passwordTF.text.length>0){
        [BmobUser loginInbackgroundWithAccount:self.userNameTF.text andPassword:self.passwordTF.text block:^(BmobUser *user, NSError *error) {
            if (user) {
//                if ([user objectForKey:@"emailVerified"]) {
//                    //用户没验证过邮箱
//                    if (![[user objectForKey:@"emailVerified"] boolValue]) {
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请到邮箱验证" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                            //确定时做的事
//                        }];
//                        [alert addAction:cancel];
//                        [alert addAction:confirm];
//                        [self presentViewController:alert animated:YES completion:nil];
//
//                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                }
                //登录环信
                [[EasemobManager shareManager]logingWithName:self.userNameTF.text andPW:self.passwordTF.text];
                //添加显示首页的代码
                //            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                //            [app showHomeVC];
            }
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    //确定时做的事
                }];
                [alert addAction:cancel];
                [alert addAction:confirm];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else{
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    
}
#pragma mark - 生命周期 Life Cilcle
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.userNameTF.text.length>0&&self.passwordTF.text.length>0){
        [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    }else{
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BmobUser *bUser = [BmobUser currentUser];
//    if (bUser) {
//        if ([bUser objectForKey:@"emailVerified"]) {
//            //用户没验证过邮箱
//            if (![[bUser objectForKey:@"emailVerified"] boolValue]) {
//                [BmobUser logout];
//            }
//        }
//    }
    self.navigationController.navigationBar.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (self.userNameTF.text.length>0&&self.passwordTF.text.length>0){
        [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    }else{
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
}
@end
