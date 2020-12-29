//
//  HK_tradeViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef enum {
    tradeSucess, //交易完成
    tradeOn //交易进行中
} TradeShopType;
@interface HK_tradeViewController : HK_BaseView
@property (nonatomic, assign)TradeShopType tradeStatus;

@end
