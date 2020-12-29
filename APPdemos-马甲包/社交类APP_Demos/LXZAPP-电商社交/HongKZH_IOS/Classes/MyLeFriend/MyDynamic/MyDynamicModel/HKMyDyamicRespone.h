//
//  HKMyDyamicRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKMyDyamicModel;
@interface HKMyDyamicRespone : NSObject
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, copy)NSString *code;
@property (nonatomic,assign) BOOL responeSuc;
@property (nonatomic, strong)HKMyDyamicModel *data;
@end
