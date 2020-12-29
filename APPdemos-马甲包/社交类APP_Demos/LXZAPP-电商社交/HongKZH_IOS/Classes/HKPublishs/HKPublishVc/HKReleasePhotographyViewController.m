//
//  HKReleasePhotographyViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleasePhotographyViewController.h"
#import "HKDisplayProductCell.h"
#import "HK_BaseRequest.h"
#import "HKPublishViewModel.h"
@interface HKReleasePhotographyViewController ()

@end

@implementation HKReleasePhotographyViewController

//导航右侧按钮点击
- (void)nextStep {
    [super nextStep];
}

- (void)buttonClick {
    DLog(@"发布");
    [super buttonClick];
    //保存title和remark
    if (self.model) {
        [HKReleaseVideoParam setObject:self.model.money key:@"money"];
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


#pragma mark 请求
//- (void)uploadData {
//    [HKPublishViewModel uploadPublish:get_releasePhotography callback:^(id responseObject, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (responseObject) {
//            NSString *code = [responseObject objectForKey:@"code"];
//            if (code && [code integerValue] == 1) {
//                //失败
//                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
//            } else if(code && [code integerValue] == 0){
//                //成功
//                [HKReleaseVideoParam clearParam];
//                [self uploadSuccess];
//            }
//        }
//     }];
//
//}

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
    return 6;
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
            return [self createImageAnnexCellWithTip:@"添加照片"];
        }
            break;
        case 3:
        {
            return [self createDisplayProductCell:indexPath];
        }
            break;
        case 4:
        {
            return [self createMoneyCell:indexPath];
        }
            break;
        case 5:
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
        case 3:
            return 141.f;
            break;
            
        default:
            return 45;
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
//cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==4) {
        HKSetMoneyViewController * moneyVC =[[HKSetMoneyViewController alloc] init];
        moneyVC.block = ^(HKMoneyModel *model) {
            self.model = model;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        self.setMoney = YES;
        moneyVC.model = self.model;
        [self.navigationController pushViewController:moneyVC   animated:YES];
    }
}

@end
