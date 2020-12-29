//
//  LJTableRootViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUDManager.h"
#import "LJTableCell.h"

@interface LJTableRootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, assign) LJObjectsViewControllerType viewControllerType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MBProgressHUDManager *hudManager;

- (void)loadData;

- (void) refreshView;

@end
