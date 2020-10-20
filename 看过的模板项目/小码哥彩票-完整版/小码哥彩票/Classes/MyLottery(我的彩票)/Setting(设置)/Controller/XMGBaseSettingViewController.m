//
//  XMGBaseSettingViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGBaseSettingViewController.h"

#import "XMGSettingCell.h"


@interface XMGBaseSettingViewController ()

@end

@implementation XMGBaseSettingViewController
- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - tableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XMGSettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 创建cell
    XMGSettingCell *cell = [XMGSettingCell cellWithTableView:tableView style:UITableViewCellStyleValue1];
    XMGSettingGroup *group = self.groups[indexPath.section];
    XMGSettingItem *item = group.items[indexPath.row];
    cell.item = item;
    return cell;
}

// 返回头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    XMGSettingGroup *group = self.groups[section];
    return group.headTitle;
}

// 返回尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    XMGSettingGroup *group = self.groups[section];
    return group.footTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 取出哪一组
    XMGSettingGroup *group = self.groups[indexPath.section];
    // 取出哪一行
    XMGSettingItem *item = group.items[indexPath.row];
    if (item.itemOpertion) {
        item.itemOpertion(indexPath);
        return;
    }
    if ([item isKindOfClass:[XMGArrowSettingItem class]]) {
        XMGArrowSettingItem *arrowItem = (XMGArrowSettingItem *)item;
        if (arrowItem.destVc) {
            // 才需要跳转
            // 创建跳转的控制器
            UIViewController *vc = [[arrowItem.destVc alloc] init];
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
