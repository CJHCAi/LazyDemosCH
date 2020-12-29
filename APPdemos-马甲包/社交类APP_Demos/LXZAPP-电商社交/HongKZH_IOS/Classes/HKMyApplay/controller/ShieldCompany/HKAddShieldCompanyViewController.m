//
//  HKAddShieldCompanyViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddShieldCompanyViewController.h"
#import "HK_MyApplyTool.h"
@interface HKAddShieldCompanyViewController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation HKAddShieldCompanyViewController

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextStep {
    [self.view endEditing:YES];
    if (self.textField.text.length > 0) {
        [self requestAddShieldCompany];
    } else {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showInfoWithStatus:@"请输入公司名称"];
    }
}
//屏蔽公司增加
- (void)requestAddShieldCompany {
    [HK_MyApplyTool addUserShildCompany:self.textField.text SuccessBlock:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"屏蔽公司";
    [self setNavItem];
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setUpUI];
}

- (void)setUpUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = PingFangSCRegular15;
    self.textField.placeholder = @"输入公司名称";
    self.textField.textColor = UICOLOR_HEX(0x333333);
    [bgView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(16);
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.top.bottom.equalTo(bgView);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UICOLOR_HEX(0xf5f5f5);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(bgView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}


@end
