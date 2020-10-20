//
//  BaseView.h
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/7.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL canScroll;
@property (nonatomic, strong)NSDictionary *info;

- (void)renderUIWithInfo:(NSDictionary *)info;

@end
