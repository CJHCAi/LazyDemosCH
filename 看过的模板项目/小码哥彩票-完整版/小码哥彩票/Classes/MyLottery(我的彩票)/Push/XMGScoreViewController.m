//
//  XMGScoreViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGScoreViewController.h"



@interface XMGScoreViewController ()

@end

@implementation XMGScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addGroup0];
    
    [self addGroup1];
    
    [self addGroup1];
    [self addGroup1];
    [self addGroup1];
    [self addGroup1];
}

- (void)addGroup0
{
    XMGSettingItem *item = [XMGSwtichSettingItem itemWithImage:nil title:@"推送我关注的比赛" subTitle:nil];
    XMGSettingGroup *group = [XMGSettingGroup groupWithItems:@[item]];
    group.footTitle = @"开启后，当我投注或关注的比赛开始、进球和结束时，会自动发送推送消息提醒我";
    [self.groups addObject:group];
    
}


- (void)addGroup1
{
    XMGSettingItem *item = [XMGSettingItem itemWithImage:nil title:@"起始时间" subTitle:nil];
    item.subTitle = @"00:00";
    
    // typeof获取括号里面的类型
    __weak typeof(self) weakSelf = self;
    
    // 在iOS7之后只要在cell上添加textField都自动做了键盘处理
    item.itemOpertion = ^(NSIndexPath *indexPath)
    {
        
        // 获取当前选中的cell
       UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        // 弹出键盘
        UITextField *textField = [[UITextField alloc] init];
        [cell addSubview:textField];
        textField.background=[UIColor orangeColor];
        [textField becomeFirstResponder];

    };
    
    XMGSettingGroup *group = [XMGSettingGroup groupWithItems:@[item]];
    group.headTitle = @"只在以下时间段接收比分直播推送";
    [self.groups addObject:group];
    
}

@end
