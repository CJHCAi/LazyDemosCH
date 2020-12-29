//
//  HKMyDyamicViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKMyDyamicRespone,HKMyDyamicParameter;
@interface HKMyDyamicViewModel : HKBaseViewModel
+(void)getFriendDynamic:(HKMyDyamicParameter*)parameter success:(void (^)( HKMyDyamicRespone* responde))succes;
@end
