//
//  HKLoginViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"

@interface HKLoginViewModel : NSObject
+(void)loginWithPhoneAndPassword:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success;
+(void)loginWithSendMsg:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success;
+(void)addRCIM;
@end
