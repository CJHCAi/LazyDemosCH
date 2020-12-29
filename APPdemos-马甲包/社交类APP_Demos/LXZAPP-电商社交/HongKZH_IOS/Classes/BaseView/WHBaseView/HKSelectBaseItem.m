//
//  HKSelectBaseItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelectBaseItem.h"
#import "HKSelectRowTableViewCell.h"
@interface HKSelectBaseItem()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation HKSelectBaseItem

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Initialization code
}


#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSelectRowTableViewCell*cell = [HKSelectRowTableViewCell baseCellWithTableView:tableView];
    [cell.titleBtn setTitle:self.dataArray[indexPath.row] forState:0];
    [cell.titleBtn setTitle:self.dataArray[indexPath.row] forState:UIControlStateSelected];
    if (self.row == (int)indexPath.row) {
        cell.titleBtn.selected = YES;
    }else{
        cell.titleBtn.selected = NO;
    }
    if (self.isLeft) {
        cell.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        cell.titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }else{
    cell.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    cell.titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:tag:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath tag:self.tag];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}
@end
