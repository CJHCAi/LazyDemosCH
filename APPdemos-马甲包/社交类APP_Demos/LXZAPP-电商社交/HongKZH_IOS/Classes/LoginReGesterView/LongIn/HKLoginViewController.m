//
//  HKLoginViewController.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLoginViewController.h"
#import "HKLoginInputPhoneView.h"
#import "HKLoginViewModel.h"
#import "HKShortMessageLoginViewController.h"
#import "HK_ForGetCodeController.h"
#import "HK_LoginRegesterTool.h"
@interface HKLoginViewController ()<HKLoginInputPhoneViewDelegate>
@property(nonatomic,strong)HKLoginInputPhoneView *loginInputPhoneView;
@end

@implementation HKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.fromRegister) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else {
        [AppUtils setPopHidenNavBarForFirstPageVc:self];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)shortMessage:(NSString *)phone{
    HKShortMessageLoginViewController *vc = [[HKShortMessageLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 账号密码登录
-(void)phoneAndPassword:(NSDictionary *)dict {
    NSString *mobile =dict[@"mobile"];
    
    //验证手机号是否有效.......
    if (![AppUtils verifyPhoneNumbers:mobile]) {
        [EasyShowTextView showText:@"输入的手机号不合法"];
        
        return;
    }
    [HK_LoginRegesterTool loadAppWithParamsDic:dict andCurrentController:self];
    
}
-(instancetype)init {
    if (self =[super init]) {
        self.sx_disableInteractivePop = YES;
    }
    return  self;
}
-(void)gotoForgetCode {
    
    HK_ForGetCodeController * forVC =[[HK_ForGetCodeController alloc] init];
    [self.navigationController pushViewController:forVC animated:YES];
    
}
-(void)setUI{
    self.navigationItem.title = @"登录乐小转";
    [self setShowCustomerLeftItem:YES];
    [self.view addSubview:self.loginInputPhoneView];
    [self.loginInputPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
}
-(HKLoginInputPhoneView *)loginInputPhoneView{
    if (!_loginInputPhoneView) {
        _loginInputPhoneView = [[HKLoginInputPhoneView alloc]init];
        _loginInputPhoneView.delegate = self;
    }
    return _loginInputPhoneView;
}

@end
