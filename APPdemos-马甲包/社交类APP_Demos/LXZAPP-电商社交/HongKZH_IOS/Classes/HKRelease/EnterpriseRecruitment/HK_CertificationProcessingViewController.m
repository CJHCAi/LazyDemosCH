//
//  HK_CertificationProcessingViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_CertificationProcessingViewController.h"
#import "HKReleasesViewController.h"

@interface HK_CertificationProcessingViewController ()

@end

@implementation HK_CertificationProcessingViewController

#pragma mark 设置 nav
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

//左侧取消按钮
- (void)cancel {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业认证";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [self setNavItem];
}

- (void)setUpUI {
    UIImageView *icon = [HKComponentFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"rzshz"] supperView:self.view];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(168);
    }];
    
    UILabel *tip1 = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(51, 51, 51) textAlignment:NSTextAlignmentCenter font:[UIFont fontWithName:PingFangSCMedium size:20.f] text:@"认证审核中" supperView:self.view];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(icon.mas_bottom).offset(31);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *tip2 = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(102, 102, 102) textAlignment:NSTextAlignmentCenter font:[UIFont fontWithName:PingFangSCRegular size:15.f] text:@"您的资料已提交成功，请耐心等待" supperView:self.view];
    [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tip1.mas_bottom).offset(15);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *doneButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectZero taget:self action:@selector(done) supperView:self.view];
    doneButton.layer.cornerRadius = 5.f;
    doneButton.layer.masksToBounds = YES;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:RGB(74, 145, 223)];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(49);
    }];
    
}

- (void)done {
        Class aVCClass = NSClassFromString(@"HK_PublishCategoryViewController");
    for (UIViewController *tempVc in self.navigationController.viewControllers) {
        if ([tempVc isKindOfClass:[HKReleasesViewController class]]||[tempVc isKindOfClass:aVCClass]) {
            [self.navigationController popToViewController:tempVc animated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
