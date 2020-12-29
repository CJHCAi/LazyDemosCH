//
//  HKMyApplyViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyApplyViewController.h"
#import "HKMyApplyResumeInfoCell.h"
#import "HKMyApplyResumeOperationCell.h"
#import "HKMyApplyRecomandJobCell.h"
#import "HKEditResumeViewController.h"
#import "HKMyResumePreviewViewController.h"
#import "HKMyDeliveryViewController.h"
#import "HK_MyApplyTool.h"
@interface HKMyApplyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) HKMyApplyData *myApplyData;

@property (nonatomic, strong) NSMutableArray *jobs;

@end

@implementation HKMyApplyViewController

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
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
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}
//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(241, 241, 241);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
//        @weakify(self);
        //上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage++;
            [self requestRecommandJobs];
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyApplyResumeInfoCell" bundle:nil] forCellReuseIdentifier:@"HKMyApplyResumeInfoCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyApplyRecomandJobCell" bundle:nil] forCellReuseIdentifier:@"HKMyApplyRecomandJobCell"];
        [_tableView registerClass:[HKMyApplyResumeOperationCell class] forCellReuseIdentifier:@"HKMyApplyResumeOperationCell"];
    }
    return _tableView;
}

- (NSMutableArray *)jobs {
    if (!_jobs) {
        _jobs = [NSMutableArray array];
    }
    return _jobs;
}

//网络请求
- (void)requestMyApply {
    [HK_MyApplyTool getUserApplyInfoSuccessBlock:^(HKMyApplyData *applyData) {
       
        self.myApplyData = applyData;
       [self requestRecommandJobs];

    } failed:^(NSString *error) {
        
        [EasyShowTextView showText:error];
    
    }];
}
- (void)requestRecommandJobs {
    [HK_MyApplyTool getRecommendJobsWithPage:self.curPage SuccessBlock:^(HK_jobRecResponse *applyData) {
       
        if (self.curPage == applyData.data.totalPage || applyData.data.totalPage == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self.jobs addObjectsFromArray:applyData.data.list];
        [self.tableView reloadData];
        
    } failed:^(NSString *error) {
         [EasyShowTextView showText:error];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的应聘";
    self.curPage = 1;
    [self.view addSubview:self.tableView];
    [self setNavItem];
    [self requestMyApply];
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return [self.jobs count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HKMyApplyResumeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyApplyResumeInfoCell"];
            cell.data = self.myApplyData;
            return cell;
        } else {
            HKMyApplyResumeOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyApplyResumeOperationCell"];
            cell.block = ^(NSInteger index) {
                switch (index) {
                    case 0:
                    {
                        HKEditResumeViewController *vc = [[HKEditResumeViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        HKMyResumePreviewViewController *vc = [[HKMyResumePreviewViewController alloc] init];
                        vc.resumeId = self.myApplyData.resumeId;
                        vc.source = 1;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                    
                    }
                        break;
                    case 3:
                    {
                        HKMyDeliveryViewController *vc = [[HKMyDeliveryViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
            };
            return cell;
        }
    } else {
        HKMyApplyRecomandJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyApplyRecomandJobCell"];
        cell.infoData = [self.jobs objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        HK_jobData * jobs =[self.jobs objectAtIndex:indexPath.row];
        [HK_MyApplyTool pushDetailRecruitInfo:jobs.recruitId withCurrentVc:self];
    }
}
#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            return 116;
        } else {
            return 92;
        }
    } else {
        return 110;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        v.backgroundColor = UICOLOR_HEX(0xf5f5f5);
        return v;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        v.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x000000)
                                              textAlignment:NSTextAlignmentCenter
                                                       font:PingFangSCRegular15
                                                       text:@"推荐职位"
                                                 supperView:v];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(v);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UICOLOR_HEX(0xffffff);
        [v addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(v);
            make.top.equalTo(v.mas_bottom).offset(-1);
            make.height.mas_equalTo(1);
        }];
        
        return v;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 45;
    } else {
        return 0.01;
    }
}

@end
