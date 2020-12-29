//
//  HKNewPerSonTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKNewPersonResponse.h"
#import "HKNewPerSonTypeResponse.h"
#import "HKUserVipResponse.h"
#import "HK_BaseRequest.h"
@interface HKNewPerSonTool : NSObject

/**
 *  获取新人专享主页顶部数据
 */
+(void)getNewPersonBaseDataSuccessBlock:(void(^)(HKNewPerSonTypeResponse *renponse))success fail:(void(^)(NSString *error))error;

/**
 *  获取对应类型列表数据
 */
+(void)getTypeNewUserListWithId:(NSString *)typeId pageNumber:(NSInteger)page SuccessBlock:(void(^)(HKNewPersonResponse *renponse))success fail:(void(^)(NSString *error))error;

/**
 *  获取折扣劵详情
 */
+(void)getUserVipDetailWithVipCouponId:(NSString *)vipCounponId SuccessBlock:(void(^)(HKUserVipResponse *renponse))success fail:(void(^)(NSString *error))error;


@end
