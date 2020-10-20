//
//  ZJWaterLayoutListTableViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/11.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJWaterLayoutListTableViewController.h"
#import "ZJCirleLayoutViewController.h"
#import "ZJGridLayoutViewController.h"
#import "ZJWaterLayoutViewController.h"
#import "ZJLineLayoutViewController.h"

@interface ZJWaterLayoutListTableViewController ()
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *classNameA;

@end

@implementation ZJWaterLayoutListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流水布局常见形式";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.array = @[@"水平/竖直流水布局",@"水平/竖直线性布局",@"环形布局",@"网格布局"];
    
    self.classNameA = @[@"ZJWaterLayoutViewController",@"ZJLineLayoutViewController",@"ZJCirleLayoutViewController",@"ZJGridLayoutViewController"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = self.classNameA[indexPath.row];
    id objectVC = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:objectVC animated:YES];
}

@end
