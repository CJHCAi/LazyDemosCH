//
//  ViewController.m
//  Demo
//
//  Created by ccd on 16/12/1.
//  Copyright © 2016年 ccd. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+HeaderScaleImage.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, 0, 180);
    headerView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];

    self.tableView.tableHeaderView = headerView;
    
    
    // 设置图片
    self.tableView.gn_headerScaleImage = [UIImage imageNamed:@"girl"];
    // 设置高度,建议和tableHeaderView的高度一致
    self.tableView.gn_headerScaleImageHeight = 180;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end

