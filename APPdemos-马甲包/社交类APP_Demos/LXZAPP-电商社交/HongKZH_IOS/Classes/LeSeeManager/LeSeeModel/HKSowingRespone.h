//
//  HKSowingRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKSowingModel;
@interface HKSowingRespone : NSObject
@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic,assign) BOOL responeSuc;
@end
