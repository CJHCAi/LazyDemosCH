//
//  HKPublishCommonModuleViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPublishCommonModuleViewController.h"
#import "HKChooseChannelTableViewCell.h"
#import "HKTitleAndContentCell.h"
#import "HKDisplayProductCell.h"
#import "HKUserProductViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HKReleaseLocationCell.h"
#import "HK_NetWork.h"
#import "UrlConst.h"
#import "HKAliyunOSSUploadVideoTool.h"

@interface HKPublishCommonModuleViewController ()

@end

@implementation HKPublishCommonModuleViewController

//导航右侧按钮点击
- (void)nextStep {
    [super nextStep];
}

- (void)buttonClick {
    //保存title和remark
    [super buttonClick];
    if (self.model) {
        [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%zd",self.model.totalMoney] key:@"money"];
        [HKReleaseVideoParam setObject:self.model.number key:@"number"];
         [HKReleaseVideoParam setObject:self.model.type key:@"type"];
    }
    if (self.titleContentCell.title) {
        [HKReleaseVideoParam setObject:self.titleContentCell.title key:@"title"];
    }
    if (self.titleContentCell.remarks) {
        [HKReleaseVideoParam setObject:self.titleContentCell.remarks key:@"remarks"];
    }
    //保存商品
    [self saveProducts];
    //保存屏幕宽度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenWidth] key:@"width"];
    //保存屏幕高度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenHeight] key:@"high"];
    
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    //数据验证
    [param validateDatapublishType:ENUM_PublishTypePublic success:^{
        [self uploadData];
    } failure:^(NSString *tip) {
        [SVProgressHUD showInfoWithStatus:tip];
    }];
}
-(void)uploadData{
    [super uploadData];
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
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestLocation];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return [self createChooseChannelCell];
        }
            break;
        case 1:
        {
            return [self createTitleAndContentCell];
        }
            break;
        case 2:
        {
            return [self createDisplayProductCell:indexPath];
        }
            break;
        case 3:
        {
            return  [self createMoneyCell:indexPath];
        }
            break;
        case  4:
        {
            return [self createLocationCell:indexPath];
        
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50.f;
            break;
        case 1:
            return 226.f;
            break;
        case 2:
            return 141.f;
            break;
        case 3:
            return 45.f;
            break;
        case 4:
            return 45.f;
            break;
        default:
            return 0;
            break;
    }
}

//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB(241, 241, 241);
    return view;
}

//footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

////cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==3) {
        HKSetMoneyViewController * moneyVC =[[HKSetMoneyViewController alloc] init];
        moneyVC.block = ^(HKMoneyModel *model) {
            self.model = model;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        self.setMoney = YES;
        moneyVC.model =self.model;
        [self.navigationController pushViewController:moneyVC   animated:YES];
    }
}



@end
