//
//  SelfMediaSearchsViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class SearchGoodsRespone,HKReconmendBaseResponse,HKSelfMedioheadRespone;
@interface SelfMediaSearchsViewModel : HKBaseViewModel
+(void)selfMediaSearchs:(NSDictionary*)dict type:(int)type success:(void (^)(SearchGoodsRespone*respone))success;
+(void)searcPVideo:(NSDictionary*)dict type:(int)type success:(void (^)(NSMutableArray*dataArray))success;
+(void)getRecomendListWithDict:(NSDictionary*)dict type:(int)type SuccessBlock:(void(^)(HKReconmendBaseResponse *response))response fail:(void(^)(NSString *error))error;
+(void)getRecommendMain:(NSDictionary*)dict type:(int)type SuccessBlock:(void(^)(HKSelfMedioheadRespone *response))response fail:(void(^)(NSString *error))error;
@end
