//
//  HKUserContentReportController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserContentReportController.h"
#import "HKUserReportDetailController.h"
@interface HKUserContentReportController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIButton *reportInfoBtn;
@end

@implementation HKUserContentReportController

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource =[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(void)initData {
    NSArray *titleArr =@[@"发布不当内容对我造成了骚扰",@"存在欺诈骗钱行为",@"此账号可能被盗用了",@"存在侵权行为",@"发布伪冒信息"];
    for (NSString * titles in titleArr) {
        [self.dataSource addObject:titles];
    }
    [self.tableView reloadData];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MainColor;
       //headview
        UIView * head =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        head.backgroundColor = RGB(245,245,245);
        _tableView.tableHeaderView = head;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
-(UIButton *)reportInfoBtn {
    if (!_reportInfoBtn) {
        _reportInfoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _reportInfoBtn.frame = CGRectMake(kScreenWidth/2-28,kScreenHeight-NavBarHeight-StatusBarHeight-84,56,14);
        [AppUtils getButton:_reportInfoBtn font:PingFangSCRegular14 titleColor:RGB(104,145,209) title:@"举报须知"];
        [_reportInfoBtn addTarget:self action:@selector(swichToReport) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportInfoBtn;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"report"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"report"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    NSString * text =[self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor =[UIColor colorFromHexString:@"333333"];
    cell.textLabel.font =PingFangSCRegular15;
    cell.textLabel.text = text;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKUserReportDetailController *reportDetail =[[HKUserReportDetailController alloc] init];
    [self.navigationController pushViewController:reportDetail animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
     [super viewDidLoad];
     self.title =@"举报";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.reportInfoBtn];
    [self initData];
}
#pragma mark 跳转到举报须知道界面
-(void)swichToReport {
    [EasyShowTextView showText:@"跳转到举报须知"];
}
@end
