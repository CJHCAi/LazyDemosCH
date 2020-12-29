//
//  HKPushViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKMyPostsRespone;
@interface HKPushViewModel : HKBaseViewModel
+(void)myPraisePost:(NSDictionary*)parameter type:(int)type success:(void (^)( HKMyPostsRespone* responde))success;
@end
