//
//  HKEnterpriseRecruitViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseRecruitViewController.h"
#import "HKChooseChannelTableViewCell.h"
#import "HKRecruitIntroductionTableViewCell.h"
#import "HKCompanyProfileTableViewCell.h"
#import "HKPositionTableViewCell.h"
#import "HKEnterpriseInfoViewController.h"
#import "HKPositionManageViewController.h"

@interface HKEnterpriseRecruitViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) HK_RecruitEnterpriseInfoData *enterpriseInfoData;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, assign) NSInteger requestFlag;
@property (nonatomic, weak) HKRecruitIntroductionTableViewCell *introductionCell;
@end

@implementation HKEnterpriseRecruitViewController

#pragma mark 设置 nav
//导航右侧按钮点击
- (void)nextStep {
    
}

#pragma mark 请求
//请求企业信息
-(void)requstRecruitEnterpriseInfo
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
//    [self Business_Request:BusinessRequestType_get_recruitEnterpriseInfo dic:dic cache:NO];
}

//请求职位信息
-(void)requstRecruitPosition
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
//    [self Business_Request:BusinessRequestType_get_recruitPosition dic:dic cache:NO];
}

//请求结果
//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode
//{
//    if(BusinessRequestType_get_recruitEnterpriseInfo == type)
//    {
//        if (RequsetStatusCodeSuccess == statusCode)
//        {
//            self.enterpriseInfoData = [ViewModelLocator sharedModelLocator].recruitEnterpriseInfo.data;
//            [self reloadData];
//        }
//    }
//    else if (BusinessRequestType_get_recruitPosition == type) {
//        if (RequsetStatusCodeSuccess == statusCode)
//        {
//            self.listData = [NSMutableArray arrayWithArray:[ViewModelLocator sharedModelLocator].recruitPosition.data.childNodes];
//            [self reloadData];
//        }
//    }
//}

//更新 UI
- (void)reloadData {
    if (self.requestFlag == 1) {
        [self.tableView reloadData];
        //更新招聘职位个数
        if ([self.listData count] > 0) {
            NSString *text = [NSString stringWithFormat:@"(%ld)",[self.listData count]];
            self.countLabel.text = text;
        }
    }
    if (self.requestFlag == 2) {
        //更新公司信息
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.requestFlag == 3) {
        //更新招聘职位个数
        if ([self.listData count] > 0) {
            NSString *text = [NSString stringWithFormat:@"(%ld)",[self.listData count]];
            self.countLabel.text = text;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:3];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


#pragma mark UI
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.requestFlag == 2) {
        [self requstRecruitEnterpriseInfo];
    } else if (self.requestFlag == 3) {
        [self requstRecruitPosition];
    }
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

    self.requestFlag = 1;
    [self requstRecruitEnterpriseInfo];
    [self requstRecruitPosition];
}

- (void)buttonClick {
    DLog(@"发布");
    //保存title和remark
    if (self.introductionCell.title) {
        [HKReleaseVideoParam setObject:self.introductionCell.title key:@"title"];
    }
    
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    //保存屏幕宽度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenWidth] key:@"width"];
    //保存屏幕高度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenHeight] key:@"high"];
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
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
//    [self Business_Request:BusinessRequestType_get_ReleaseRecruit dic:[param dataDict] cache:NO];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1;
            break;
        case 3:
            return [self.listData count];
            break;
        default:
            return 0;
            break;
    }
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
            static NSString *cellIdentifier = @"HKCompanyProfileTableViewCell";
            HKCompanyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKCompanyProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            cell.data = self.enterpriseInfoData;
            [cell layoutIfNeeded];
            return cell;
        }
            break;
        case 3:
        {
            static NSString *cellIdentifier = @"HKPositionTableViewCell";
            HKPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKPositionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            HK_RecruitPositionData *data = [self.listData objectAtIndex:indexPath.row];
            cell.positionData = data;
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
            return UITableViewAutomaticDimension;
            break;
        case 3:
            return 32.f;
            break;
            
        default:
            return 0;
            break;
    }
}


//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 55;
    } else {
        return 0.01;
    }
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        UIControl *control = [[UIControl alloc] init];
        [view addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(51,51,51) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:14.f] text:@"在招职位" supperView:view];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(16);
            make.top.equalTo(view).offset(15);
        }];
        
        UILabel *countLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(153,153,153) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:14.f] text:@"" supperView:view];
        self.countLabel = countLabel;
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right);
            make.top.equalTo(titleLabel);
        }];
        
        UIImageView *arrowView = [HKComponentFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"nestchose"] supperView:view];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-16);
            make.centerY.equalTo(titleLabel);
        }];
        
        UIView *line = [HKComponentFactory viewWithFrame:CGRectZero supperView:view];
        line.backgroundColor = RGB(226,226,226);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.top.equalTo(titleLabel.mas_bottom).offset(16);
            make.height.mas_equalTo(1);
        }];
        return view;
    } else {
        return nil;
    }
}

- (void)controlClick {
    DLog(@"123");
    self.requestFlag = 3;
    HKPositionManageViewController *vc = [[HKPositionManageViewController alloc] init];
    vc.listData = self.listData;
    vc.enterpriseId = self.enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
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
        case 2: //跳转到修改企业信息页面
        {
            self.requestFlag = 2;
            HKEnterpriseInfoViewController *vc = [[HKEnterpriseInfoViewController alloc] init];
            vc.enterpriseInfoData = self.enterpriseInfoData;
            vc.enterpriseId = self.enterpriseId;
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
