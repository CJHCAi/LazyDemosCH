//
//  HKMyRecruitPositionManagerViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyRecruitPositionManagerViewController.h"
#import "CBSegmentView.h"
#import "HKPositionManagerCell.h"
#import "HKPositionOfflineCell.h"
#import "HKMyCandidateViewController.h"
#import "HK_RecruitTool.h"
@interface HKMyRecruitPositionManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CBSegmentView *segment;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HKRecruitOnlineList *onlineList;
@property (nonatomic, strong) HKRecruitOffLineList *offlineList;
@property (nonatomic, assign) NSInteger flag;

@end

@implementation HKMyRecruitPositionManagerViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HKPositionManagerCell" bundle:nil] forCellReuseIdentifier:@"HKPositionManagerCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HKPositionOfflineCell" bundle:nil] forCellReuseIdentifier:@"HKPositionOfflineCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(41);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (CBSegmentView *)segment {
    if (!_segment) {
        _segment = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [_segment setTitleArray:@[@"招聘中",@"下线"] titleFont:15 titleColor:UICOLOR_HEX(0x7c7c7c) titleSelectedColor:UICOLOR_HEX(0x0092ff) withStyle:CBSegmentStyleSlider];
//        __weak typeof(self)weakSelf  = self;
        _segment.titleChooseReturn = ^(NSInteger x) {
            
//            weakSelf.flag = x;
//            [weakSelf.tableView reloadData];
        };
    }
    return _segment;
}

//在线职位
- (void)requestOnlinePosition {
    [HK_RecruitTool getOnlineListDataSuccessBlock:^(HKRecruitOnlineList *list) {
        self.onlineList = list;
        [self.tableView reloadData];
    } fial:^(NSString *msg) {
        [SVProgressHUD showSuccessWithStatus:msg];
    }];
}
//下线职位
- (void)requestOfflinePosition {
    [HK_RecruitTool getOfflineListDataSuccessBlock:^(HKRecruitOffLineList *list) {
        self.offlineList = list;
        [self.tableView reloadData];
    } fial:^(NSString *msg) {
        [SVProgressHUD showSuccessWithStatus:msg];
    }];
}

//职位刷新
- (void)requestPositionRefreshWithRecruitId:(NSString *)recruitId {
    [HK_RecruitTool refreshOnlineDataById:recruitId SuccessBlock:^(id response) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
        
    } fial:^(NSString *msg) {
        [SVProgressHUD showSuccessWithStatus:msg];
    }];
}
//职位上线
- (void)requestPositionOnlineWithRecruitId:(NSString *)recruitId {
    [HK_RecruitTool letPositionOnDataById:recruitId SuccessBlock:^(id response) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"上线成功"];
        [self requestOnlinePosition];
        [self requestOfflinePosition];
        
    } fial:^(NSString *msg) {
        [SVProgressHUD showSuccessWithStatus:msg];
    }];
}

//职位删除
- (void)requestPositionDeleteWithRecruitId:(NSString *)recruitId {
    [HK_RecruitTool DeletePositionOnDataById:recruitId SuccessBlock:^(id response) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [self requestOfflinePosition];
    } fial:^(NSString *msg) {
         [SVProgressHUD showSuccessWithStatus:msg];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.title = @"职位管理";
    self.flag = 0;
    [self.view addSubview:self.segment];
    [self requestOnlinePosition];
    [self requestOfflinePosition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.flag == 0) {
        return [self.onlineList.data count];
    }
    return [self.offlineList.data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.flag == 0) {
        HKPositionManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKPositionManagerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HKRecruitOnlineData *data = [self.onlineList.data objectAtIndex:indexPath.row];
        cell.data = data;
        cell.block = ^(NSInteger index) {
            switch (index) {
                case 100:
                {
                    HKMyCandidateViewController *vc = [[HKMyCandidateViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 101:
                    [self requestPositionRefreshWithRecruitId:data.recruitId];
                    break;
                case 102:
                    DLog(@"分享");
                    break;
                    
                default:
                    break;
            }
        };
        return cell;
    } else {
        HKPositionOfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKPositionOfflineCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HKRecruitOffLineData *data = [self.offlineList.data objectAtIndex:indexPath.row];
        cell.data = data;
        cell.block = ^(NSInteger index) {
            switch (index) {
                case 100:
        
                    [self requestPositionOnlineWithRecruitId:data.recruitId];
                    break;
                    
                case 101:
                    [self requestPositionDeleteWithRecruitId:data.recruitId];
                    break;
                    
                default:
                    break;
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 152;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

@end
