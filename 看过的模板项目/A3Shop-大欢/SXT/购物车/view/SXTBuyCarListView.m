//
//  SXTBuyCarListView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTBuyCarListView.h"
#import "SXTBuyCarListCell.h"//tableview对应的cell
#import "SXTBuyCarListModel.h"//tableview中cell的model

@interface SXTBuyCarListView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SXTBuyCarListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource= self;
        self.bounces = NO;
    }
    return self;
}

- (void)setBuyCarList:(NSMutableArray *)buyCarList{
    _buyCarList = buyCarList;
    for (SXTBuyCarListModel *model in _buyCarList) {
        [model setIsSelectButton:YES];
    }
    [self reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buyCarList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXTBuyCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SXTBuyCarListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cellData = _buyCarList[indexPath.row];
    cell.tag = 1000+indexPath.row;
    [cell.addButton addTarget:self action:@selector(addButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.cutButton addTarget:self action:@selector(cutButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.isSelectBtn addTarget:self action:@selector(selectBtnMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *dele = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        SXTBuyCarListModel *cellModel = _buyCarList[indexPath.row];
        [cellModel setGoodsCount:0];
        [self changeDataMethod];
        [_buyCarList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    return @[dele];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)addButtonMethod:(UIButton *)sender{
    UIView *cell = [sender superview];
    NSInteger cellTag = cell.tag - 1000;
    SXTBuyCarListModel *cellModel = _buyCarList[cellTag];
    [cellModel setGoodsCount:cellModel.GoodsCount + 1];
    [self changeDataMethod];
}

- (void)cutButtonMethod:(UIButton *)sender{
    UIView *cell = [sender superview];
    NSInteger cellTag = cell.tag - 1000;
    SXTBuyCarListModel *cellModel = _buyCarList[cellTag];
    if (cellModel.GoodsCount > 1) {
        [cellModel setGoodsCount:cellModel.GoodsCount - 1];
    }
    [self changeDataMethod];
}

- (void)selectBtnMethod:(UIButton *)sender{
    UIView *cell = [sender superview];
    SXTBuyCarListModel *cellModel = _buyCarList[cell.tag - 1000];
    if (sender.selected) {
        sender.selected = NO;
        [cellModel setIsSelectButton:NO];
    }else{
        sender.selected = YES;
        [cellModel setIsSelectButton:YES];
    }
    [self changeDataMethod];
}

- (void)changeDataMethod{
    [self reloadData];
    if (_changeDataBlock) {
        _changeDataBlock();
    }
}
@end








