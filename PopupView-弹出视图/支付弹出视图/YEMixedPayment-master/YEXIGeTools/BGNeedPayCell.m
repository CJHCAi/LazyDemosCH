//
//  BGNeedPayCell.m
//  WeiTuan
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 西格. All rights reserved.
//
//不足额，默认零钱+微信，  零钱+支付宝， 或者   微信、支付宝可选 二选一，  但是微信和支付宝不能同时选
//足额，零钱、微信、支付宝都可选    三选一

#import "BGNeedPayCell.h"

@interface BGNeedPayCell ()


@end

@implementation BGNeedPayCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static  NSString *cell_ID = @"BGNeedPayCell";
    BGNeedPayCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (!cell) {
        // cell = [[ZFExceptionalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID];
        cell = [[NSBundle mainBundle] loadNibNamed:cell_ID owner:nil options:nil].firstObject;
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
