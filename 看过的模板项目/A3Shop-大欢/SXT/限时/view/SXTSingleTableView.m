//
//  SXTSingleTableView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/22.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTSingleTableView.h"
#import "SXTSingleTableViewCell.h"//新品列表cell
#import "SXTGroupTableCell.h"//团购列表cell
@interface SXTSingleTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SXTSingleTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate =self;
        self.dataSource =self;
        self.bounces = NO;
    }
    return self;
}

- (void)setSingleModelArray:(NSArray *)singleModelArray{
    _singleModelArray = singleModelArray;
    [self reloadData];
}

- (void)setGroupModelArray:(NSArray *)groupModelArray{
    _groupModelArray = groupModelArray;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSingle) {
        return self.singleModelArray.count;
    }else
        return self.groupModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSingle) {
        return 170;
    }else
        return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isSingle) {
        SXTSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleCell"];
        if (!cell) {
            cell = [[SXTSingleTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"singleCell"];
        }
        cell.singleModel = self.singleModelArray[indexPath.row];
        return cell;
    }else{
        SXTGroupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[SXTGroupTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        }
        cell.ImageUrl = [self.groupModelArray[indexPath.row] ImgView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isSingle) {
        if (_goodsIDBlock) {
            _goodsIDBlock([self.singleModelArray[indexPath.row] GoodsId]);
        }
    }else{
        
    }
    
}

@end









