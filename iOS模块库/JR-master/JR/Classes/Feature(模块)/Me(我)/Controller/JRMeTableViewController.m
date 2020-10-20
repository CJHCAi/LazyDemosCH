//
//  JRMeTableViewController.m
//  JR
//
//  Created by 张骏 on 17/8/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRMeTableViewController.h"

static NSString *const CellReusedId = @"CellReusedId";

@interface JRMeTableViewController ()

@end

@implementation JRMeTableViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - private
- (void)setupTableView{
    [self.tableView setTableHeaderView:[UIImageView imageViewWithFrame:CGRectMake(0, 0, JRScreenWidth, JRHeight(326.5)) image:[UIImage imageNamed:@"meHeader"]]];
    [self.tableView setRowHeight:50];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReusedId];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = JRHexColor(0xf4f4f4);
    self.tableView.backgroundColor = JRHexColor(0xf0faf9);

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReusedId forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *text;
    UIImage *image;
    switch (indexPath.row) {
        case 0:
            text = @"我的勋章";
            image = [UIImage imageNamed:@"bedge"];
            break;
            
        case 1:
            text = @"我的团课";
            image = [UIImage imageNamed:@"order"];
            break;
            
        case 2:
            text = @"芝麻信用认证";
            image = [UIImage imageNamed:@"zmxy"];
            break;
            
        case 3:
            text = @"我的钱包";
            image = [UIImage imageNamed:@"wallet"];
            break;
            
        case 4:
            text = @"分享";
            image = [UIImage imageNamed:@"share"];
            [JRTool shadow:cell.layer];
            break;
            
        default:
            break;
    }
    cell.textLabel.text = text;
    cell.imageView.image = image;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
