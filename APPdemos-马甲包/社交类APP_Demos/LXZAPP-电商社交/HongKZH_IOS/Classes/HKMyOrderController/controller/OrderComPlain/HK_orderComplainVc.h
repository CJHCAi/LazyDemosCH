//
//  HK_orderComplainVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//


#import "HK_BaseView.h"


@interface HK_orderComplainVc : HK_BaseView

@property (nonatomic, copy) NSString *orderNumber;
//区别投诉和举证
@property (nonatomic, assign)int type;

@end
