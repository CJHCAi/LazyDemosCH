//
//  HKReleaseResumeViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseResumeViewController.h"
#import "HKResumeCompletionCell.h"
#import "HKImageAnnexCell.h"
#import "HKResumeOpenwCell.h"
#import "HKUpdateResumeViewController.h"

@interface HKReleaseResumeViewController ()
@property (nonatomic, weak) HKRecruitIntroductionTableViewCell *introductionCell;
@property (nonatomic, assign, getter=isOpen) BOOL open;
@property (nonatomic, strong) NSString *complete;
@end

@implementation HKReleaseResumeViewController

//导航右侧按钮点击
- (void)nextStep {
    
}

- (void)buttonClick {
    DLog(@"发布");
    //保存title和remark
    if (self.introductionCell.title) {
        [HKReleaseVideoParam setObject:self.introductionCell.title key:@"title"];
    }
    
    if (self.isOpen) {
        [HKReleaseVideoParam setObject:@"1" key:@"isOpen"];
    } else {
        [HKReleaseVideoParam setObject:@"0" key:@"isOpen"];
    }
    
    //保存屏幕宽度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenWidth] key:@"width"];
    //保存屏幕高度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenHeight] key:@"high"];
    
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    //数据验证
    [param validateDatapublishType:ENUM_PublishTypeRecruit success:^{
        [self uploadData];
    } failure:^(NSString *tip) {
        [SVProgressHUD showInfoWithStatus:tip];
    }];
}

#pragma mark 发布
- (void)uploadData {
    
    [super uploadData];
}

//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode responseJsonObject:(id)jsonObj{
//    if (type == BusinessRequestType_get_ReleaseRecruit) {
//        if (jsonObj) {
//            NSString *code = [jsonObj objectForKey:@"code"];
//            if (code && [code integerValue] == 1) {
//                //失败
//                [SVProgressHUD showInfoWithStatus:[jsonObj objectForKey:@"msg"]];
//            } else if(code && [code integerValue] == 0){
//                //成功
//                [HKReleaseVideoParam clearParam];
//                [self uploadSuccess];
//            }
//        } else {
//            [SVProgressHUD showInfoWithStatus:@"网络错误"];
//        }
//    }
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
    self.complete = @"0 %";
//    [self requestLocation];
    
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
            NSString *cellIdentifier = @"HKRecruitIntroductionTableViewCell";
            HKRecruitIntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKRecruitIntroductionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            cell.coverImage = [HKReleaseVideoParam shareInstance].coverImgSrc;
            self.introductionCell = cell;
            return cell;
        }
            break;
        case 2:
        {
            NSString *cellIdentifier = @"HKResumeCompletionCell";
            HKResumeCompletionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKResumeCompletionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            return cell;
        }
            break;
        case 3:
        {
            return [self createImageAnnexCellWithTip:@"添加图片附件"];
        }
            break;
        case 4:
        {
            NSString *cellIdentifier = @"UITableViewCell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.textLabel.text = @"屏蔽公司";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = PingFangSCRegular14;
                cell.textLabel.textColor = RGB(102,102,102);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
            break;
        case 5:
        {
            NSString *cellIdentifier = @"HKResumeOpenwCell";
            HKResumeOpenwCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKResumeOpenwCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            cell.open = self.isOpen;
            cell.block = ^(BOOL changed) {
                self.open = changed;
            };
            return cell;
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
            return 105.f;
            break;
        case 2:
            return 45.f;
            break;
        case 3:
            return 141.f;
            break;
        case 4:
            return 45.f;
            break;
        case 5:
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

//cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 1:
            break;
        case 2: 
        {
            HKUpdateResumeViewController *vc = [[HKUpdateResumeViewController alloc] init];
//            @weakify(self);
            vc.block = ^(NSString *complete) {
//                @strongify(self);
                self.complete = complete;
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
                [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
