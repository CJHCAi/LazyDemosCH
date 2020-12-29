//
//  HKSettlementReceptionViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKChargeViewModel.h"
@interface HKSettlementReceptionViewController : HKBaseViewController
@property(nonatomic, copy)NSString *orderID;
-(void)loadData:(NSString *)orderID monery:(NSString*)monery payType:(HKPayType)paytype;
@property (nonatomic,assign) HKPayType payType;
-(void)loadDataCartArray:(NSArray*)cartArray addressId:(NSString*)addressId;
@property (nonatomic, strong)NSArray *cartArray;
@property (nonatomic, copy)NSString *addressId;
@property (nonatomic,assign) BOOL isFromGame;
@end
