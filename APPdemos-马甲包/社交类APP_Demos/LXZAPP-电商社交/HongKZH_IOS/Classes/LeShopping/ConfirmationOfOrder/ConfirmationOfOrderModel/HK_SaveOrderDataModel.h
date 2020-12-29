//
//  HK_SaveOrderDataModel.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseModel.h"
#import "HK_SaveOrderDataUserModel.h"

@interface HK_SaveOrderDataModel : HK_BaseModel
@property (nonatomic, copy) NSString *ordersId;

@property (nonatomic, strong) HK_SaveOrderDataUserModel *user;
//需要支付的金币量
@property (nonatomic, assign) NSInteger allIntegral;
@end
