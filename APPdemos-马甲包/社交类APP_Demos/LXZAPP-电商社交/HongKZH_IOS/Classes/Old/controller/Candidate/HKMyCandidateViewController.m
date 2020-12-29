//
//  HKMyCandidateViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyCandidateViewController.h"
#import "HKMenuPickerView.h"
#import "HKMyRecruitRecommendCell.h"
#import "HKMyResumePreviewViewController.h"
#import "HK_RecruitTool.h"
@interface HKMyCandidateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) UIButton *jobButton;
@property (nonatomic, weak) UIButton *stateButton;

@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic, strong) NSMutableArray *jobTitles;
@property (nonatomic, strong) NSMutableArray *states;
@property (nonatomic, strong) NSMutableArray *stateTitles;

//@property (nonatomic, strong) HKMyCandidateData *myCandidateData;


@property (nonatomic, assign) NSInteger jobIndex;
@property (nonatomic, assign) NSInteger stateIndex;

@property (nonatomic, strong) NSString *recruitId;
@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) NSMutableArray *recruits;

@end

@implementation HKMyCandidateViewController

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

- (NSMutableArray *)jobs {
    if (!_jobs) {
        _jobs = [NSMutableArray array];
    }
    return _jobs;
}

- (NSMutableArray *)jobTitles {
    if (!_jobTitles) {
        _jobTitles = [NSMutableArray arrayWithObject:@"全部职位"];
    }
    return _jobTitles;
}

- (NSMutableArray *)states {
    if (!_states) {
        _states = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
    }
    return _states;
}

- (NSMutableArray *)stateTitles {
    if (!_stateTitles) {
         _stateTitles = [NSMutableArray arrayWithArray:@[@"全部状态",@"待筛选",@"待沟通",@"不匹配"]];
    }
    return _stateTitles;
}

- (NSMutableArray *)recruits {
    if (!_recruits) {
        _recruits = [NSMutableArray array];
    }
    return _recruits;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
//        @weakify(self);
        // 上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage++;
            [self requestMyCandidate];
        }];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyRecruitRecommendCell" bundle:nil] forCellReuseIdentifier:@"HKMyRecruitRecommendCell"];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(40);
        }];
    }
    return _tableView;
}


- (void)requestOnlinePosition {
    
    [HK_RecruitTool getOnlineListDataSuccessBlock:^(HKRecruitOnlineList *list) {
     
        NSArray<HKRecruitOnlineData *> *data = list.data;
        [self.jobs addObjectsFromArray:data];
        for (HKRecruitOnlineData *data in self.jobs) {
            [self.jobTitles addObject:data.title];
        }
        
    } fial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}

- (void)requestMyCandidate {
    [HK_RecruitTool getCandidateListwithRecruitId:self.recruitId states:self.state page:self.curPage successBlock:^(HKMyCandidate *cadite) {
        if (self.curPage == 1) {
            [self.recruits removeAllObjects];
        }
        HKMyCandidateData *data = cadite.data;
        if (self.curPage == data.totalPage || data.totalPage == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.recruits addObjectsFromArray:data.list];
        [self.tableView reloadData];
        
    } fail:^(NSString *error) {
        
        [EasyShowTextView showText:error];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"候选人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavItem];
    [self setUpUI];
    self.jobIndex = 0;
    self.stateIndex = 0;
    self.curPage = 1;
    [self requestOnlinePosition];
    [self requestMyCandidate];
}

- (void)setUpUI {
    [self createMenuView];
}

- (void)createMenuView {
    UIView *menuView = [[UIView alloc] init];
    menuView.backgroundColor = UICOLOR_HEX(0xf5f5f5);
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *jobButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                       frame:CGRectZero
                                                       taget:self
                                                      action:@selector(buttonClick:)
                                                  supperView:menuView];
    jobButton.tag = 100;
    UIButton *stateButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                       frame:CGRectZero
                                                       taget:self
                                                      action:@selector(buttonClick:)
                                                  supperView:menuView];
    stateButton.tag = 101;
    [jobButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(menuView);
        make.width.equalTo(stateButton);
        make.right.equalTo(stateButton.mas_left);
    }];
    [stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(menuView);
        make.left.equalTo(jobButton.mas_right);
    }];
    self.jobButton = jobButton;
    self.stateButton = stateButton;
    [self.jobButton setTitle:self.jobTitles[0] forState:UIControlStateNormal];
    [self.stateButton setTitle:self.stateTitles[0] forState:UIControlStateNormal];
    [self.jobButton setTitleColor:UICOLOR_HEX(0x558ef0) forState:UIControlStateNormal];
    [self.stateButton setTitleColor:UICOLOR_HEX(0x558ef0) forState:UIControlStateNormal];
    self.jobButton.titleLabel.font = PingFangSCRegular12;
    self.stateButton.titleLabel.font = PingFangSCRegular12;
}

//- (void)buttonClick:(UIButton *)button {
//    if (button.tag == 100) {
//       __weak typeof(self)weakSelf  = self;
//        [HKMenuPickerView showInView:self.navigationController.view
//                            menuTitle:@"选择职位"
//                            curIndex:self.jobIndex
//                              titles:self.jobTitles
//                               block:^(NSInteger index) {
//                                   weakSelf.jobIndex = index;
//                                   if (index == 0) {
//                                       weakSelf.recruitId = nil;
//                                   } else {
//                                       HKRecruitOnlineData *data = self.jobs[index-1];
//                                       weakSelf.recruitId = data.recruitId;
//                                   }
//                                   [weakSelf.jobButton setTitle:self.jobTitles[index] forState:UIControlStateNormal];
//                                   weakSelf.curPage = 1;
//                                   [weakSelf requestMyCandidate];
//                               }];
//    } else if (button.tag == 101) {
//       __weak typeof(self)weakSelf  = self;
//        [HKMenuPickerView showInView:self.navigationController.view
//                            menuTitle:@"选择状态"
//                            curIndex:self.stateIndex
//                              titles:self.stateTitles
//                               block:^(NSInteger index) {
//                                   weakSelf.stateIndex = index;
//                                   if (index == 0) {
//                                       weakSelf.state = nil;
//                                   } else {
//                                       weakSelf.state = weakSelf.states[index-1];
//                                   }
//                                   [weakSelf.stateButton setTitle:weakSelf.stateTitles[index] forState:UIControlStateNormal];
//                                   weakSelf.curPage = 1;
//                                   [weakSelf requestMyCandidate];
//                               }];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recruits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyRecruitRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyRecruitRecommendCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.candidateList = [self.recruits objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyCandidateList *list = [self.recruits objectAtIndex:indexPath.row];
    HKMyResumePreviewViewController *vc = [[HKMyResumePreviewViewController alloc] init];
    vc.recruitId = list.recruitId;
    vc.resumeId = list.resumeId;
    vc.source = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 0.01;
    
}


@end
