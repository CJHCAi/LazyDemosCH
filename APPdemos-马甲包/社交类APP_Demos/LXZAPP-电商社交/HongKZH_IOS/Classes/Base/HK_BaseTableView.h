//
//  HK_BaseTableView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@interface HK_BaseTableView : HK_BaseView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
