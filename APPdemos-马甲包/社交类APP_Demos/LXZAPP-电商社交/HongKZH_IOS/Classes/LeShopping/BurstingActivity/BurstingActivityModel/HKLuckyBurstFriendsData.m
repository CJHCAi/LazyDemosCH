//
//  HKLuckyBurstFriendsData.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLuckyBurstFriendsData.h"
#import "LuckyBurstFriendsModel.h"
@implementation HKLuckyBurstFriendsData
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [LuckyBurstFriendsModel class]};
}
@end
