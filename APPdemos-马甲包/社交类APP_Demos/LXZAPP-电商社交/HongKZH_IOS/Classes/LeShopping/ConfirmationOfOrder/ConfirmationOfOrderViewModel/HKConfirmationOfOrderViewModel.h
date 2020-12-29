//
//  HKConfirmationOfOrderViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
#import "HKCouponResponse.h"

@class HKConfirmationOfOrderRespone,HKSaveOrderRespone;
@interface HKConfirmationOfOrderViewModel : HKBaseViewModel
+(void)getPreorderWithCartIdArray:(NSArray*)cartId dict:(NSDictionary*)dict success:(void (^)( HKConfirmationOfOrderRespone* responde))success;
+(void)getSaveOrderWithCartIdArray:(NSArray*)cartId dict:(NSDictionary*)dict success:(void (^)( HKSaveOrderRespone* responde))success;
+(void)getpayOrder:(NSDictionary*)dict success:(void (^)(HKBaseResponeModel* responde))success;
+(void)getMyCouponsByProductId:(NSDictionary*)dict success:(void (^)(NSArray* dataArray,BOOL isSuc))success;


//异步回调结果
+(void)WexinInfoNotice;

@end
