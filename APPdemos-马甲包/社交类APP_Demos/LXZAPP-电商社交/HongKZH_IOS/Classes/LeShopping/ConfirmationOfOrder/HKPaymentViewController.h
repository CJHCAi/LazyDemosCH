//
//  HKPaymentViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
@protocol HKPaymentViewControllerDelegate <NSObject>

@optional
-(void)gotoOrderDetailVcWithOrderId:(NSString*)orderId;
-(void)gotoRecharge;
@end
@interface HKPaymentViewController : HKBaseViewController
@property (nonatomic, strong)NSArray *cartArray;
+(void)showPaymentViewControllerWithCartArray:(NSArray*)cartArray addressId:(NSString*)addressId subView:(UIViewController*)subVc;
@property (nonatomic, copy)NSString *addressId;
@property (nonatomic,weak) id<HKPaymentViewControllerDelegate> delegate;
@end
