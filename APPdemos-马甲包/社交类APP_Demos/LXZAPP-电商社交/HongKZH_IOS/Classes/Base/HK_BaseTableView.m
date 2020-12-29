

//
//  HK_BaseTableView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseTableView.h"

@interface HK_BaseTableView ()

@end

@implementation HK_BaseTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showCustomerLeftItem = YES;
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView = [HKComponentFactory tableViewWithFrame:CGRectZero
                                                      style:UITableViewStyleGrouped
                                                   delegate:self
                                                 dataSource:self
                                                 supperView:self.view];
    self.tableView.backgroundColor = UICOLOR_HEX(0xf1f1f1);
//    self.tableView.estimatedRowHeight = 123;
    self.tableView.rowHeight = UITableViewAutomaticDimension;   //动态行高
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 5;
    
    self.navigationController.navigationBar.translucent = NO;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //设置不透明导航栏
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
