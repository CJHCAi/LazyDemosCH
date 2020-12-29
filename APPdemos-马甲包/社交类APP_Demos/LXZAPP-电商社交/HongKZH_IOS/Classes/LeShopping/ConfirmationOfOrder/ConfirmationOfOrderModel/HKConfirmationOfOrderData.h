//
//  HKConfirmationOfOrderData.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getCartList.h"
#import "HKAddressListRespone.h"
@interface HKConfirmationOfOrderData : NSObject
@property (nonatomic,assign) NSInteger freightIntegral;
@property (nonatomic,assign) NSInteger productIntegral;
//userIntegral
@property (nonatomic,assign)NSInteger userIntegral;
@property (nonatomic,assign) NSInteger countegral;
//总抵扣金额
@property (nonatomic, assign)NSInteger countOffsetCoin;

@property (nonatomic, strong)NSMutableArray<getCartListData*>*list;
@property (nonatomic, strong)HKAddressModel *address;
@end

