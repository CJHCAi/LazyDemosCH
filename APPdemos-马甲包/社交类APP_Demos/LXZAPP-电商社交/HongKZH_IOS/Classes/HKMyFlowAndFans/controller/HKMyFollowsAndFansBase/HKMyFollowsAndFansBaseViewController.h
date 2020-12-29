//
//  HKMyFollowsAndFansBaseViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HKMyFansCell.h"

@interface HKMyFollowsAndFansBaseViewController : HK_BaseView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NSMutableArray *myFollowAndFansArray;

@property (nonatomic, weak) id selectedCellValue;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, assign)FollowFansType type;


@end
