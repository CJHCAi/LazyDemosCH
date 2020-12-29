//
//  LuckyBurstFriendsRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseModelRespone.h"
@class HKLuckyBurstFriendsData;
@interface LuckyBurstFriendsRespone : HKBaseModelRespone
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKLuckyBurstFriendsData*data;
@end
