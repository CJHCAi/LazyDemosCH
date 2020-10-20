//
//  SXTOrderTableView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/31.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTOrderTableView.h"
#import "SXTOrderTableCell.h"

@interface SXTOrderTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SXTOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
    }
    return self;
}

- (void)setOrderList:(NSArray *)orderList{
    _orderList = orderList;
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXTOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SXTOrderTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderModel = _orderList[indexPath.row];
    return cell;
}

@end
