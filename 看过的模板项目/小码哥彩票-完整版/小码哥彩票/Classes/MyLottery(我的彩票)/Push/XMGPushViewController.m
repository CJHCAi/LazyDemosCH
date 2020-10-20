//
//  XMGPushViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGPushViewController.h"
#import "XMGArrowSettingItem.h"
#import "XMGSettingGroup.h"

#import "XMGSettingCell.h"

#import "XMGAwardViewController.h"

#import "XMGScoreViewController.h"

@interface XMGPushViewController ()

@end

@implementation XMGPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpGroup1];
}

- (void)setUpGroup1
{
    
    XMGArrowSettingItem *redeemCode = [XMGArrowSettingItem itemWithImage:nil title:@"开奖推送" subTitle:nil];
    redeemCode.destVc = [XMGAwardViewController class];
    XMGArrowSettingItem *item = [XMGArrowSettingItem itemWithImage:nil title:@"比分直播" subTitle:nil];
    item.destVc = [XMGScoreViewController class];
    XMGArrowSettingItem *item1 = [XMGArrowSettingItem itemWithImage:nil title:@"使用兑换码" subTitle:nil];
    XMGArrowSettingItem *item2 = [XMGArrowSettingItem itemWithImage:nil title:@"使用兑换码" subTitle:nil];
    
    // 当前组有多少行
    XMGSettingGroup *group = [XMGSettingGroup groupWithItems:@[redeemCode,item,item1,item2]];
    [self.groups addObject:group];
    
}


@end
