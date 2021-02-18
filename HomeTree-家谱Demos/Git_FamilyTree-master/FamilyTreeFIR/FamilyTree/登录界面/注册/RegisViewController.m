//
//  RegisViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "RegisViewController.h"
#import "LoginView.h"
#import "RootTabBarViewController.h"
@interface RegisViewController ()<LoginViewDelegate>
@property (nonatomic,strong) LoginView *registView; /*注册页面*/

@property (nonatomic,strong) UIButton *verificationBtn; /*验证码按钮*/

@property (nonatomic,strong) UIButton *registButton; /*注册按钮*/



@end

@implementation RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.registView];
    [self.view addSubview:self.registButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** registViewDelegate ***
//选中上端菜单
-(void)loginView:(LoginView *)loginView didSelectedTopViewBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:self];

            break;
        case 1:
            [self.navigationController popViewControllerAnimated:self];
            self.navigationController.navigationBarHidden = YES;

            break;
        case 2:{
            FindPassViewController *finPassVc = [FindPassViewController new];
            [self.navigationController pushViewController:finPassVc animated:YES];
            }
            break;
        default:
            break;
    }
}
//选中三方登录按钮
-(void)loginView:(LoginView *)loginView didSelectedOtherLoginBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            NSLog(@"qq");
            break;
        case 1:
            NSLog(@"weixin");
            break;
        case 2:
            NSLog(@"weibo");
            break;
        default:
            break;
    }
}


//游客按钮
-(void)loginView:(LoginView *)loginView didSelectedTourBtn:(UIButton *)sender{
    NSLog(@"游客请进！");
    RootTabBarViewController *tabBar = [[RootTabBarViewController alloc] init];
    [self.navigationController pushViewController:tabBar animated:YES];
}

#pragma mark *** respondsToVerficationBtn ***
//获取验证码按钮
-(void)respondsToVerficationBtn:(UIButton *)sender{
    MYLog(@"获取验证码");
}

-(void)respondsToRegistBtn:(UIButton *)sender{
    MYLog(@"注册");
}
#pragma mark *** getters ***
//重配登录界面
-(LoginView *)registView{
    if (!_registView) {
        _registView = [[LoginView alloc] initWithFrame:self.view.bounds];
        _registView.accountView.headView.image = [UIImage imageNamed:@"newUser_tel"];
        _registView.passwordView.headView.image = [UIImage imageNamed:@"newUser_yanzheng"];
        _registView.accountView.inputTextView.placeholder  = @"手   机   号";
        _registView.passwordView.inputTextView.placeholder = @"验   证   码";
        [_registView.passwordView.goArrows removeFromSuperview];
        
        [_registView.topView.regisBtn setTitle:@"登录" forState:0];
        
        [_registView.passwordView addSubview:self.verificationBtn];
        
        _registView.delegate = self;
        
    }
    return _registView;
}

-(UIButton *)verificationBtn{
    if (!_verificationBtn) {
        _verificationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.registView.passwordView.frame)-self.registView.passwordView.bounds.size.width/2.5, -5, self.registView.passwordView.bounds.size.width/4, 30)];
        _verificationBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [_verificationBtn setTitle:@"获取验证码" forState:0];
        [_verificationBtn setTitleColor:LH_RGBCOLOR(95, 95, 95) forState:0];
        _verificationBtn.titleLabel.font = MFont(12);
        
        [_verificationBtn addTarget:self action:@selector(respondsToVerficationBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _verificationBtn;
}

-(UIButton *)registButton{
    if (!_registButton) {
        _registButton = [[UIButton alloc] init];
        _registButton.bounds = CGRectMake(0, 0, self.registView.passwordView.bounds.size.width, 40);
        _registButton.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.registView.passwordView.frame)+_registButton.bounds.size.height);
        _registButton.backgroundColor = self.verificationBtn.backgroundColor;
        [_registButton setTitle:@"立即注册" forState:0];
        [_registButton setTitleColor:LH_RGBCOLOR(95, 95, 95) forState:0];
        _registButton.titleLabel.font = MFont(18);
        
        [_registButton addTarget:self action:@selector(respondsToRegistBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

@end
