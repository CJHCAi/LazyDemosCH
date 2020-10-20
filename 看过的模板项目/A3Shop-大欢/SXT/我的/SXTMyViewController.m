//
//  SXTMyViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTMyViewController.h"
#import "SXTMyTableViewCell.h"
#import "SXTMyHeadView.h"//我的页面顶部注册登陆view
#import "SXTMyTableView.h"//我的功能列表
#import "SXTLandingViewController.h"//注册页面
#import "SXTLoginViewController.h"//登录页面
#import <Masonry.h>
@interface SXTMyViewController ()
@property (strong, nonatomic)   SXTMyHeadView *headView;              /** 顶部现实注册登录按钮的view */

@property (strong, nonatomic)   SXTMyTableView *myTableView;              /** 我的功能模块 */
@end

@implementation SXTMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainColor;
    self.edgesForExtendedLayout = 0;
    [self.view addSubview:self.myTableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myTableView reloadData];
    [_headView reloadHeadView];
}

- (SXTMyHeadView *)headView{
    if (!_headView) {
        _headView = [[SXTMyHeadView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 160)];
        __weak typeof (self) weakSelf = self;
        _headView.landingBlock = ^(){
            SXTLandingViewController *landingView = [[SXTLandingViewController alloc]init];
            [weakSelf.navigationController pushViewController:landingView animated:YES];
        };
        _headView.loginBlock = ^(){
            SXTLoginViewController *loginView = [[SXTLoginViewController alloc]init];
            [weakSelf.navigationController pushViewController:loginView animated:YES];
        };
    }
    return _headView;
}

- (SXTMyTableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[SXTMyTableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:(UITableViewStylePlain)];
        __weak typeof (self) weakSelf = self;
        _myTableView.exitBlock = ^(){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ISLOGIN"];
            [weakSelf.myTableView reloadData];
            [weakSelf.headView reloadHeadView];
        };
        _myTableView.tableHeaderView = self.headView;
    }
    return _myTableView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
