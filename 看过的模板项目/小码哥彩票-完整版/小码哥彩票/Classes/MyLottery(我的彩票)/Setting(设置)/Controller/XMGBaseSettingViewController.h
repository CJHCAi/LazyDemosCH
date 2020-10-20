//
//  XMGBaseSettingViewController.h
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMGArrowSettingItem.h"
#import "XMGSwtichSettingItem.h"
#import "XMGSettingGroup.h"


@interface XMGBaseSettingViewController : UITableViewController
// 记录当前tableView的所有数组
@property (nonatomic, strong) NSMutableArray *groups;
@end
