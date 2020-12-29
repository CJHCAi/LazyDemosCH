//
//  HKSetingVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@interface HKSetingVc : HK_BaseView
@property (nonatomic, strong)UITableView * tabView;
@property (nonatomic, assign)BOOL hasFootView;

@property (nonatomic, strong)NSMutableArray * data;

-(void)initData;
-(void)setFoot;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
