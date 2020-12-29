//
//  HKSaveOrderRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseModelRespone.h"
@class HK_SaveOrderDataModel;
@interface HKSaveOrderRespone : HKBaseModelRespone
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)HK_SaveOrderDataModel *data;
@end
