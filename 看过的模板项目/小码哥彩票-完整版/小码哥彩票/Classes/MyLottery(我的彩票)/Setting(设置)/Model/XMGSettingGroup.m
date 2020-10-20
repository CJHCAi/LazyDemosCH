//
//  XMGSettingGroup.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingGroup.h"

@implementation XMGSettingGroup


+ (instancetype)groupWithItems:(NSArray *)items{
    XMGSettingGroup *group = [[self alloc] init];
    group.items = items;
    return group;
}
@end
