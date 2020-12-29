//
//  HK_orderShopHeaderView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_orderInfo.h"
#import "Hk_MyOrderDataModel.h"
#import "HK_BuySellResponse.h"

typedef void(^EnterShopBlock)(NSString *shopId);

@interface HK_orderShopHeaderView : UIView
@property (nonatomic, strong)UIView *headerBackV;
@property (nonatomic, strong)UIImageView * typeImageView;
@property (nonatomic, strong)UILabel * shopNameLabel;
@property (nonatomic, strong)UILabel *stateLabel;
@property (nonatomic, strong)UIView *lineV;
@property (nonatomic, copy) EnterShopBlock block;
//详情页头部视图配置信息
-(void)setConfigueViewWithModel:(HK_orderInfo *)model;

//列表页头部视图 配置信息
-(void)configueListOrderHeaderWithModel:(HK_shopOrderList *)listOrder;
//我的售后
-(void)saleHeaderWithSaleModel:(HK_SaleLIstData *)saleModel;

@end
