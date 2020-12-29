//
//  HK_orderInfoCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_orderInfo.h"
@interface HK_orderInfoCell : UITableViewCell
//上部信息图
@property (weak, nonatomic) IBOutlet UIView *TopInfoView;
//订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//下单时间
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
//放订单相关信息的视图
@property (weak, nonatomic) IBOutlet UIView *orderInfoView;
//第一天细线
@property (weak, nonatomic) IBOutlet UIView *TopLineView;
//放支付相关的信息视图
@property (weak, nonatomic) IBOutlet UIView *payInfoView;
//支付方式
@property (weak, nonatomic) IBOutlet UILabel *payTool;
//支付时间
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
//商品总计
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
//运费
@property (weak, nonatomic) IBOutlet UILabel *transFeeLabel;
//第二条细线
@property (weak, nonatomic) IBOutlet UIView *SecondLineView;
//支付合计呈放图
@property (weak, nonatomic) IBOutlet UIView *payTotalInfoView;
//支付合计量
@property (weak, nonatomic) IBOutlet UILabel *payTotalLabel;
//成交时间
@property (weak, nonatomic) IBOutlet UILabel *tranferTimeLabell;

-(void)setOrderInfoCellWithModel:(HK_orderInfo *)model;

@end
