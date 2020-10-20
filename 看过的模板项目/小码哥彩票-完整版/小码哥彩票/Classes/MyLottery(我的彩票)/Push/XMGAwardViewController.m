//
//  XMGAwardViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGAwardViewController.h"

#import "XMGSettingCell.h"

@interface XMGAwardViewController ()

@end

@implementation XMGAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addGroup0];
    
    
}

- (void)addGroup0
{
    
    XMGSwtichSettingItem *item = [XMGSwtichSettingItem itemWithImage:nil title:@"双色球" subTitle:nil];
    item.subTitle = @"每周二、四、日开奖";
    XMGSwtichSettingItem *item1 = [XMGSwtichSettingItem itemWithImage:nil title:@"大乐透" subTitle:nil];
    item1.subTitle = @"每周一、三、六开奖";
    XMGSwtichSettingItem *item2 = [XMGSwtichSettingItem itemWithImage:nil title:@"3D" subTitle:nil];
    item2.subTitle = @"每天开奖、包括试机号提醒";
    XMGSwtichSettingItem *item3 = [XMGSwtichSettingItem itemWithImage:nil title:@"七乐彩" subTitle:nil];
    item3.subTitle = @"每周一、三、五开奖";
    XMGSwtichSettingItem *item4 = [XMGSwtichSettingItem itemWithImage:nil title:@"七星彩" subTitle:nil];
    item4.subTitle = @"每周二、五、日开奖";
    XMGSwtichSettingItem *item5 = [XMGSwtichSettingItem itemWithImage:nil title:@"排列3" subTitle:nil];
    item5.subTitle = @"每天开奖";
    XMGSwtichSettingItem *item6 = [XMGSwtichSettingItem itemWithImage:nil title:@"排列5" subTitle:nil];
    item6.subTitle = @"每天开奖";
    
    XMGSettingGroup *group = [[XMGSettingGroup alloc] init];
    group.items = @[item,item1,item2,item3,item4,item5,item6];
    
    [self.groups addObject:group];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    XMGSettingCell *cell = [XMGSettingCell cellWithTableView:tableView style:UITableViewCellStyleSubtitle];
    
    // 取出哪一组
    XMGSettingGroup *group = self.groups[indexPath.section];
    // 取出哪一行
    XMGSettingItem *item = group.items[indexPath.row];
    // 给cell传递模型
    cell.item = item;
    return cell;

}

@end
