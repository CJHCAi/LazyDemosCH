//
//  XMGSettingViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingViewController.h"



#import "XMGSettingCell.h"
#import "XMGBlurView.h"
#import "MBProgressHUD+XMG.h"
#import "XMGHelpViewController.h"
#import "XMGPushViewController.h"

@interface XMGSettingViewController ()

@end

@implementation XMGSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"常见问题" style:UIBarButtonItemStyleBordered target:self action:@selector(help)];
    
    [self setUpGroup0];
    [self setUpGroup1];
    [self setUpGroup2];
}

- (void)help{
    XMGHelpViewController *helpVc = [[XMGHelpViewController alloc] init];
    helpVc.title = @"帮助";
    [self.navigationController pushViewController:helpVc animated:YES];
}

- (void)setUpGroup0{
    XMGArrowSettingItem *redeemCode = [XMGArrowSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:@"时间把控"];
    redeemCode.destVc = [UIViewController class];
    // 当前组有多少行
    XMGSettingGroup *group = [XMGSettingGroup groupWithItems:@[redeemCode]];
    group.headTitle = @"asdasd";
    [self.groups addObject:group];
}

- (void)setUpGroup1{
    XMGArrowSettingItem *redeemCode = [XMGArrowSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"推送和提醒" subTitle:nil];
    redeemCode.destVc = [XMGPushViewController class];
    XMGSwtichSettingItem *item = [XMGSwtichSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:nil];
    XMGSwtichSettingItem *item1 = [XMGSwtichSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:nil];
    XMGSwtichSettingItem *item2 = [XMGSwtichSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:nil];
    // 当前组有多少行
    XMGSettingGroup *group = [XMGSettingGroup groupWithItems:@[redeemCode,item,item1,item2]];
    [self.groups addObject:group];
}

- (void)setUpGroup2{
    XMGArrowSettingItem *version = [XMGArrowSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"检查有没有最新的版本" subTitle:@"有梦分享"];
    version.itemOpertion = ^(NSIndexPath *indexPath){
        XMGBlurView *blurView = [[XMGBlurView alloc] initWithFrame:XMGScreenBounds];
        [XMGKeyWindow addSubview:blurView];
        [MBProgressHUD showSuccess:@"当前木有最新的版本"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blurView removeFromSuperview];
        });
    };
    // 当前组有多少行
    XMGArrowSettingItem *item = [XMGArrowSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:nil];
    XMGArrowSettingItem *item1 = [XMGArrowSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:nil];
    XMGArrowSettingItem *item2 = [XMGArrowSettingItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码" subTitle:nil];
    // 当前组有多少行
    XMGSettingGroup *group = [XMGSettingGroup groupWithItems:@[version,item,item1,item2]];
    [self.groups addObject:group];
}
@end
