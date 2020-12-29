//
//  HKSelfMedioheadRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseModelRespone.h"
#import "HKSelfMediaHeadModel.h"
@interface HKSelfMedioheadRespone : HKBaseModelRespone
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)HKSelfMediaHeadModel *data;
@end
