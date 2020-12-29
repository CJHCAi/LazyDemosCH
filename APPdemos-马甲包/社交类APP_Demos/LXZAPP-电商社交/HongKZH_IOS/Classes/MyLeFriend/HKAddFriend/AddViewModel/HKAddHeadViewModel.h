//
//  HKAddHeadViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKRecommendFansModel,HKMobileRequestModel;
@interface HKAddHeadViewModel : NSObject
+(void)loadRecommendedUsers
:(NSDictionary*)dict success:(void (^)(HKRecommendFansModel *model))success;
+(void)loadMobile
:(NSDictionary*)dict success:(void (^)(HKMobileRequestModel *model))success;
+(void)followAdd:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success;
+(void)followDelete:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success;
@end
