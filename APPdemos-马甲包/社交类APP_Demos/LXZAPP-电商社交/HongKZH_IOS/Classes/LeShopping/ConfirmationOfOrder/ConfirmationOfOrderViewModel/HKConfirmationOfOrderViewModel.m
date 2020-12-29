//
//  HKConfirmationOfOrderViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKConfirmationOfOrderViewModel.h"
#import "HK_NetWork.h"
#import "HKConfirmationOfOrderRespone.h"
#import "HKSaveOrderRespone.h"
#import "HKBaseResponeModel.h"
@implementation HKConfirmationOfOrderViewModel
+(void)getPreorderWithCartIdArray:(NSArray*)cartId dict:(NSDictionary*)dict success:(void (^)( HKConfirmationOfOrderRespone* responde))success{
    
    
    [HK_NetWork updataFileWithURL:get_preorder formDataArray:cartId parameters:dict progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (error) {
            HKConfirmationOfOrderRespone *respone = [[HKConfirmationOfOrderRespone alloc]init];
            success(respone);
        }else{
        HKConfirmationOfOrderRespone *respone = [HKConfirmationOfOrderRespone mj_objectWithKeyValues:responseObject];
        success(respone);
        }
    }];
}
+(void)getSaveOrderWithCartIdArray:(NSArray*)cartId dict:(NSDictionary*)dict success:(void (^)( HKSaveOrderRespone* responde))success{
    [HK_NetWork updataFileWithURL:get_saveOrder_mediaShop formDataArray:cartId parameters:dict progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (error) {
            HKSaveOrderRespone *respone = [[HKSaveOrderRespone alloc]init];
            success(respone);
        }else{
            HKSaveOrderRespone *respone = [HKSaveOrderRespone mj_objectWithKeyValues:responseObject];
            success(respone);
        }
    }];
}
+(void)getpayOrder:(NSDictionary*)dict success:(void (^)(HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_payOrder_mediaShop body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
        
    }];
}
+(void)getMyCouponsByProductId:(NSDictionary*)dict success:(void (^)(NSArray* dataArray,BOOL isSuc))success{
    [HK_BaseRequest buildPostRequest:get_getMyCouponsByProductId body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        if (responde.responeSuc) {
            NSArray*dataArray = [HKCounList mj_objectArrayWithKeyValuesArray:responde.data];
            success(dataArray,YES);
        }else{
         success(nil,NO);
        }
        
    } failure:^(NSError * _Nullable error) {
        success(nil,NO);
    }];
}


@end
