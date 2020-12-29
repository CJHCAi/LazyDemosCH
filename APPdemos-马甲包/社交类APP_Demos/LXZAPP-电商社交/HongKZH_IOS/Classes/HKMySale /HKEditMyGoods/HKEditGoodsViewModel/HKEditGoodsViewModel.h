//
//  HKEditGoodsViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
#import "MyGoodsRespone.h"
#import "HKFreightListRespone.h"
@interface HKEditGoodsViewModel : HKBaseViewModel
+(void)loadMyGoodsinfo:(NSDictionary*)dict success:(void (^)(MyGoodsRespone* respone))success;
+(void)freightListSuccess:(void (^)(HKFreightListRespone* respone))success;
+(void)saveMyGoodsinfo:(MyGoodsInfo*)goodsInfo success:(void (^)(BOOL isSuc))success;
+(void)saveAddMyGoodsinfo:(MyGoodsInfo*)goodsInfo success:(void (^)(BOOL isSuc))success;
+(void)deleteGoodsImage:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success;
+(void)deleteProduct:(MyGoodsInfo*)goodsInfo success:(void (^)(BOOL isSuc))success;
+(void)deleteareafreighte:(NSDictionary*)dict success:(void (^)(HKBaseResponeModel* respone))success;
+(void)savefreight:(HKFreightListData*)freightListData success:(void (^)(BOOL isSuc))success;
@end
