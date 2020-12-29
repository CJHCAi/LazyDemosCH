//
//  HK_SaveOrderBaseModel.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseModel.h"
#import "HK_SaveOrderBaseModel.h"
#import "HK_SaveOrderDataUserModel.h"
#import "HK_SaveOrderDataModel.h"
@interface HK_SaveOrderBaseModel : HK_BaseModel
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_SaveOrderDataModel *data;

@property (nonatomic, assign) NSInteger code;
@end
