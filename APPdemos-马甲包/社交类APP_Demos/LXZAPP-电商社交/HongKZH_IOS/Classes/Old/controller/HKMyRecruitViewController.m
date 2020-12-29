//
//  HKMyRecruitViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyRecruitViewController.h"
#import "HK_RecruitTool.h"
//搜索页
#import "HKMyCandidateViewController.h"
@interface HKMyRecruitViewController ()<UITableViewDelegate, UITableViewDataSource,HKChoosePositionViewDeleagte>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HKMyRecruit *myRecruit;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic, strong) NSString *curTitle;
@end

@implementation HKMyRecruitViewController

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

//企业招聘
- (void)requestMyRecruit {
    [HK_RecruitTool getMyrecuitSuccessBlock:^(HKMyRecruit *recruit) {
        self.myRecruit = recruit;
        [self.tableView reloadData];
        
    } fial:^(NSString *msg) {
        
        [EasyShowTextView showText:msg];
    }];
}
//企业招聘-推荐
- (void)requestRecommandJobs {
    [HK_RecruitTool getRecommendListWithTilte:self.curTitle andPage:self.curPage SuccessBlock:^(HKMyRecruitRecommend *recommend) {
        if (self.curPage == 1) {
        [self.jobs removeAllObjects];
        }
        HKMyRecruitRecommendData *data =recommend.data;
    if (self.curPage == data.totalPage || data.totalPage == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self.jobs addObjectsFromArray:data.list];
        [self.tableView reloadData];

    } fial:^(NSString *msg) {
        
         [EasyShowTextView showText:msg];
    }];
   
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
       // 上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.curPage++;
            [self requestRecommandJobs];
        }];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyRecruitRecommendCell" bundle:nil] forCellReuseIdentifier:@"HKMyRecruitRecommendCell"];
        [_tableView registerClass:[HKMyRecruitOperationCell class] forCellReuseIdentifier:@"HKMyRecruitOperationCell"];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)jobs {
    if (!_jobs) {
        _jobs = [NSMutableArray array];
    }
    return _jobs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业招聘";
    [self setNavItem];
    self.curPage = 1;
    self.curTitle = @"人才推荐";
    [self requestMyRecruit];
    [self requestRecommandJobs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.jobs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKMyRecruitOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyRecruitOperationCell"];
        cell.data = self.myRecruit.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.block = ^(NSInteger index) {
            switch (index) {
                case 0:
                {
                    [HK_RecruitTool pushReleaseWithCuRrentVc:self];
                }
                    break;
                case 1: {   //在线职位
                    [HK_RecruitTool pushOnlinePositionWithCuRrentVc:self];
                }
                    break;
               case  3:
                {
                    //人才收藏
                    [HK_RecruitTool pushUserCollectionWithCurrentVc:self];
                }
                    break;
               case 2:
                {
                    HKMyCandidateViewController *vc = [[HKMyCandidateViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
               case  5:
                {
                    //人才搜索...
//                    HK_RecruitSearchView * searchV =[[HK_RecruitSearchView alloc] init];
//                    searchV.serchType = 5;
//                    [self.navigationController pushViewController:searchV animated:YES];
                
                }
                    break;
                default:
                    break;
            }
        };
        return cell;
        
    } else {
        HKMyRecruitRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyRecruitRecommendCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.list = [self.jobs objectAtIndex:indexPath.row];
        return cell;
    }
}
-(void)choosePositionViewBlock:(NSInteger)index title:(NSString *)title{
    self.curTitle = title;
    self.curPage = 1;
    [self requestRecommandJobs];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        HKMyRecruitRecommendList *list =[self.jobs objectAtIndex:indexPath.row];
        HKMyResumePreviewViewController *vc = [[HKMyResumePreviewViewController alloc] init];
        vc.resumeId = list.resumeId;
        vc.source = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 161;
    } else {
        return 121;
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
                                                       text:self.curTitle
                                                 supperView:v];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(v);
        }];
        
        UIControl *coverView = [[UIControl alloc] init];
        coverView.backgroundColor = [UIColor clearColor];
        [coverView addTarget:self action:@selector(showChoosePostionView) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:coverView];
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(v);
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

- (void)showChoosePostionView{
    [HKChoosePositionView showInView:self.navigationController.view
                            curTitle:self.curTitle
                                data:self.myRecruit.data];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 45;
    } else {
        return 0.01;
    }
}

@end
