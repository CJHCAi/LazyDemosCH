//
//  HKReleaseMarryViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseMarryViewController.h"
#import "HKPrivacySettingCell.h"
#import "HKUpdateUserDataViewController.h"
#import "HK_MyApplyTool.h"
#import "HKPublishViewModel.h"
@interface HKReleaseMarryViewController ()
@property (nonatomic, strong) HK_UserRecruitData *recruitUserInfo;
@end

@implementation HKReleaseMarryViewController

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
        [HKReleaseVideoParam setObject:self.titleContentCell.remarks key:@"note"];
    }
    //保存屏幕宽度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenWidth] key:@"width"];
    //保存屏幕高度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenHeight] key:@"high"];
    
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    //数据验证
    [param validateDatapublishType:ENUM_PublishTypeMarry success:^{
        [self uploadData];
    } failure:^(NSString *tip) {
        [SVProgressHUD showInfoWithStatus:tip];
    }];
}
#pragma mark 请求

//发布视频
//- (void)uploadData {
//    [HKPublishViewModel uploadPublish:get_releaseMarry callback:^(id responseObject, NSError *error) {
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
//        } else {
//            [SVProgressHUD showInfoWithStatus:@"网络错误"];
//        }
//    } ];
//}

//请求个人资料
- (void)requestRecruitUserInfo {
    [HK_MyApplyTool getUserRecruitInfoSuccessBlock:^(HK_UserRecruitData *comRes) {
        self.recruitUserInfo = comRes;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
        
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
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
    [self requestRecruitUserInfo];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
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
            NSString *cellIdentifier = @"userInfoCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.textLabel.font = PingFangSCRegular14;
                cell.textLabel.textColor = UICOLOR_HEX(0x666666);
                cell.detailTextLabel.font = PingFangSCRegular14;
                cell.detailTextLabel.textColor = UICOLOR_HEX(0x999999);
            }
            cell.textLabel.text = @"个人资料";
            cell.detailTextLabel.text = self.recruitUserInfo.completeProgress;
            return cell;
        }
            break;
        case 4:
        {
            NSString *cellIdentifier = @"HKTitleAndContentCell";
            HKPrivacySettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKPrivacySettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            return cell;
        }
            break;
        case 5:
        {
            return [self createMoneyCell:indexPath];
        }
            break;
        case 6:
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
    if (indexPath.section == 3) {
        HKUpdateUserDataViewController *vc = [[HKUpdateUserDataViewController alloc] init];
        vc.uploadSuccessBlock = ^{
            [self requestRecruitUserInfo];
        };
        self.setMoney = YES;
        vc.infoData = self.recruitUserInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section ==5) {
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
