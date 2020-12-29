//
//  HKConfirmationOfOrderViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKPaymentViewController.h"
@interface HKConfirmationOfOrderViewController : HKBaseViewController<HKPaymentViewControllerDelegate>
@property (nonatomic, strong)NSArray *cartArray;
@property (nonatomic, strong)NSMutableArray *cartIdArray;
@property (nonatomic,assign) BOOL isFromGame;
@property (nonatomic,assign) int type;
@end
