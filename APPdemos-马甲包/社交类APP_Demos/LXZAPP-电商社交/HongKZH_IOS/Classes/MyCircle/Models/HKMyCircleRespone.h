//
//  HKMyCircleRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKMyCircleData;
@interface HKMyCircleRespone : NSObject
@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)HKMyCircleData *data;
@property (nonatomic,assign) BOOL responeSuc;
@end
