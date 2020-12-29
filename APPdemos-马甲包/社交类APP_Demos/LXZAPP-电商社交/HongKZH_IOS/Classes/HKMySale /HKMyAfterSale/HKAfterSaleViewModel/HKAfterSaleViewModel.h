//
//  HKAfterSaleViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKAfterSaleRespone,HKAfterBaseTableViewCell,HKAddressListRespone;
@interface HKAfterSaleViewModel : HKBaseViewModel

/**
 售后详情

 @param parameter 参数
 @param success 结果
 */
+(void)orderAfterSale:(NSDictionary*)parameter success:(void (^)(HKAfterSaleRespone* responde))success;



+(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section statue:(AfterSaleViewStatue)statue;


+(HKAfterBaseTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(HKAfterSaleRespone*)model;

/**
 获取地址

 @param parameter 参数
 @param type 0收货1退货
 @param success 结果
 */
+(void)address:(NSDictionary*)parameter type:(int)type success:(void (^)( HKAddressListRespone* responde))success;

/**
 增加修改退货地址

 @param parameter 参数
 #param isRefund yes 退货地址，NO收货地址
 @param success 结果
 */
+(void)addUserReturnAddress:(NSDictionary*)parameter type:(BOOL)isRefund success:(void (^)( HKBaseResponeModel* responde))success;

/**
 同意退货

 @param parameter 参数
 @param success 结果
 */
+(void)agreeReturnGoods:(NSDictionary*)parameter type:(AfterSaleViewStatue)type success:(void (^)( HKBaseResponeModel* responde))success;

/**
 拒绝退款

 @param parameter 参数
 @param imageArrray image数组
 @param success 结果
 */
+(void)sellerRefuseOrder:(NSDictionary*)parameter imageArray:(NSMutableArray*)imageArrray success:(void (^)( HKBaseResponeModel* responde))success;

/**
 拒绝退货

 @param parameter 参数
 @param imageArrray image
 @param success 结果
 */
+(void)refuseReturnGoods:(NSDictionary*)parameter imageArray:(NSMutableArray*)imageArrray success:(void (^)( HKBaseResponeModel* responde))success;

/**
 商家举证

 @param parameter 参数
 @param imageArrray imageArray
 @param success 结果
 */
+(void)sellerProof:(NSDictionary*)parameter imageArray:(NSMutableArray*)imageArrray success:(void (^)( HKBaseResponeModel* responde))success;
@end
