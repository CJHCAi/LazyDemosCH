//
//  HKCollectionRecruitController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollectionRecruitController.h"
#import "HK_RecruitTool.h"

@interface HKCollectionRecruitController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign)NSInteger curPage;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *jobs;

@end

@implementation HKCollectionRecruitController

-(NSMutableArray *)jobs {
    if (!_jobs) {
        _jobs =[[NSMutableArray alloc] init];
    }
    return _jobs;
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
//        @weakify(self);
        // 上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.curPage++;
            [self requestRecommandJobs];
        }];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyRecruitRecommendCell" bundle:nil] forCellReuseIdentifier:@"HKMyRecruitRecommendCell"];

        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}
//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人才收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavItem];
    self.curPage  = 1;
    [self requestRecommandJobs];
}
//获取列表
-(void)requestRecommandJobs {
    [HK_RecruitTool getRecommendListandPage:self.curPage SuccessBlock:^(HKMyRecruitRecommend *recommend) {
       
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
        return [self.jobs count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        HKMyRecruitRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyRecruitRecommendCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.list = [self.jobs objectAtIndex:indexPath.row];
        return cell;
}
#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
        return 121;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyRecruitRecommendList *list =[self.jobs objectAtIndex:indexPath.row];
    HKMyResumePreviewViewController *vc = [[HKMyResumePreviewViewController alloc] init];
    vc.resumeId = list.resumeId;
    vc.source = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
