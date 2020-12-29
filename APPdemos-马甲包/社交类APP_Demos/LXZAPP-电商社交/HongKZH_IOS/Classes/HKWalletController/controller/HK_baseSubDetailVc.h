//
//  HK_baseSubDetailVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef enum{
    OrderFlow_All = 0,//1 全部
    OrderFlow_Income = 1,//2 收入
    OrderFlow_Payed = 2,//3 支付
    OrderFlow_Iced= 3 //冻结
   
}OrderFlowStatue;

@interface HK_baseSubDetailVc : HK_BaseView

@property (nonatomic, assign)OrderFlowStatue status;

@end
