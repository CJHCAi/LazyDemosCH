//
//  ZJFunctionListController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/28.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJFunctionListController.h"

#import "ZJGroupingCollectionViewController.h"
#import "ZJAddSectionOrCellViewController.h"
#import "ZJAddHeaderViewViewController.h"
#import "ZJCycleViewController.h"
#import "ZJMultiSelectCellViewController.h"
#import "ZJWaterLayoutListTableViewController.h"
#import "ZJReorderViewController.h"

@interface ZJFunctionListController ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *classNameA;

@end

@implementation ZJFunctionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CollectionView 使用总结";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.array = @[@"分组及添加索引",@"添加/删除cell或section",@"添加headerView",@"循环轮播",@"cell多选",@"流水布局常见形式",@"长按拖动排序"];
    
    self.classNameA = @[@"ZJGroupingCollectionViewController",@"ZJAddSectionOrCellViewController",@"ZJAddHeaderViewViewController",@"ZJCycleViewController",@"ZJMultiSelectCellViewController",@"ZJWaterLayoutListTableViewController",@"ZJReorderViewController"];
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
