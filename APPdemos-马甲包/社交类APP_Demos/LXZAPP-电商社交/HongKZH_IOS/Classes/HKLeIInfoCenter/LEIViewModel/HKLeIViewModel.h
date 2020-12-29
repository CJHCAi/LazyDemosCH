//
//  HKLeIViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKMyDataRespone;
@interface HKLeIViewModel : HKBaseViewModel
+(void)myData:(NSDictionary*)dict success:(void (^)(HKMyDataRespone* responde))success;
@end
