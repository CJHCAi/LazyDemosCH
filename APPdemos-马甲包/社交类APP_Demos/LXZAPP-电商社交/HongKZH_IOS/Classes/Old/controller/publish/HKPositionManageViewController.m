//
//  HKPositionManageViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPositionManageViewController.h"
#import "HKPositionManageTableViewCell.h"
#import "HKPublishNewPositionViewController.h"
#import "HK_RecruitTool.h"
@interface HKPositionManageViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger requestFlag;
//@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation HKPositionManageViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGB(241, 241, 241);
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.rowHeight = 65;
        [self.view addSubview:tableView];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark 设置 nav
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布新职位" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (self.requestFlag == 1) {
        [self requstRecruitPosition];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

//导航右侧按钮点击
- (void)nextStep {
    DLog(@"发布新职位");
    HKPublishNewPositionViewController *vc = [[HKPublishNewPositionViewController alloc] init];
    vc.enterpriseId = self.enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
    self.requestFlag = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位管理";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setNavItem];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HKPositionManageTableViewCell";
    HKPositionManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HKPositionManageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    HK_RecruitPositionData *data = self.listData[indexPath.row];
    cell.postionData = data;
    return cell;
}

#pragma mark UITableViewDelegate

//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
//cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_RecruitPositionData *postionData = self.listData[indexPath.row];
    HKPublishNewPositionViewController *vc = [[HKPublishNewPositionViewController alloc] init];
    vc.enterpriseId = self.enterpriseId;
    vc.postionData = postionData;
    self.requestFlag = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//请求职位信息
-(void)requstRecruitPosition
{
    [HK_RecruitTool getCurrentPositionListSuccessBlock:^(HK_RecriutPosition *infoData) {
        if (self.listData.count) {
            [self.listData removeAllObjects];
        }
        [self.listData addObjectsFromArray:infoData.data];
        [self.tableView reloadData];
        
    } fial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}

@end
