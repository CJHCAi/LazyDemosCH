//
//  HK_footViewPayView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hk_MyOrderDataModel.h"
@protocol lastPayTimeBtnDelegete <NSObject>

-(void)payOrderClick:(HK_shopOrderList *)model;

@end

@interface HK_footViewPayView : UITableViewHeaderFooterView

@property (nonatomic, strong)UILabel * totipsLabel;

@property (nonatomic, strong)UILabel *totalCountLabel;

@property (nonatomic, strong)UIButton *payTimeBtn;

@property (nonatomic, strong)UILabel *payTimeLabel;

@property (nonatomic, strong)HK_shopOrderList * listOrder;

@property (nonatomic, weak)id <lastPayTimeBtnDelegete>delegete;
//倒计时总时间
@property (nonatomic ,assign)NSTimeInterval timer;

@property (nonatomic, assign) NSInteger section;

-(void)setListOrder:(HK_shopOrderList *)listOrder;

@end
