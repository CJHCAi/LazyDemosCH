//
//  HK_orderShopFooterView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hk_MyOrderDataModel.h"
#import "HK_orderInfo.h"
#import "HK_BuySellResponse.h"
@protocol footerViewDelegete <NSObject>

-(void)clickFooterBtnClick:(HK_shopOrderList *)model withSenderTag:(NSInteger)tag sections:(NSInteger)section;

@end

@interface HK_orderShopFooterView : UIView

@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *justLeftBtn;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, weak)id <footerViewDelegete>delegete;
//我的订单
@property (nonatomic, strong)HK_shopOrderList * model;
//售后退换
//@property (nonatomic, strong)HK_SaleLIstData * saleModel;
@property (nonatomic, assign)NSInteger section;
//@property (nonatomic, strong)HK_orderInfo * infoModel;

//详情页根据具体状态显示不同的底部工具
-(void)changeBarButtonStateWithStatus:(HK_orderInfo *)model;

//我的售后根据状态显示底部工具
-(void)ShowToolBarStatusWith:(HK_SaleLIstData *)saleModel;

@end
