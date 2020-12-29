//
//  HKOrderFormViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderFormViewModel.h"
#import "HKSellerorderListHeaderPesone.h"
#import "HKSellerorderListRespone.h"
#import "HKOrderFromInfoRespone.h"
#import "HKExpresListRespone.h"
#import "HKRevisePiceParameter.h"
#import "HKLogisticsListResponse.h"
@implementation HKOrderFormViewModel
+(void)sellerorderListHeaderWithsuccess:(void (^)(HKSellerorderListHeaderPesone* responde))success{
    [HK_BaseRequest buildPostRequest:get_sellerorderListHeader body:@{@"loginUid":HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKSellerorderListHeaderPesone *response = [HKSellerorderListHeaderPesone mj_objectWithKeyValues:responseObject];
        success(response);
    } failure:^(NSError * _Nullable error) {
         HKSellerorderListHeaderPesone *response = [[HKSellerorderListHeaderPesone alloc]init];
        success(response);
    }];
}
+(void)sellerorderListByState:(NSDictionary*)dict success:(void (^)( HKSellerorderListRespone* responde))success{
    NSDictionary *parameters;
    NSString*url = get_sellerorderListByState;
    if ([dict[@"state"]intValue] == 11) {
        url = get_mysellAfterSale;
        parameters = @{@"loginUid":dict[@"loginUid"],@"pageNumber":dict[@"pageNumber"]};
    }else{
        parameters = dict;
    }
    [HK_BaseRequest buildPostRequest:url body:parameters success:^(id  _Nullable responseObject) {
        HKSellerorderListRespone *response = [HKSellerorderListRespone mj_objectWithKeyValues:responseObject];
        success(response);
    } failure:^(NSError * _Nullable error) {
        HKSellerorderListRespone *response = [[HKSellerorderListRespone alloc]init];
        success(response);
    }];
}
+(void)searchorderListByState:(NSDictionary*)dict success:(void (^)( HKSellerorderListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_sellerorderList body:dict success:^(id  _Nullable responseObject) {
        HKSellerorderListRespone *response = [HKSellerorderListRespone mj_objectWithKeyValues:responseObject];
        success(response);
    } failure:^(NSError * _Nullable error) {
        HKSellerorderListRespone *response = [[HKSellerorderListRespone alloc]init];
        success(response);
    }];
}
+(void)orderInfo:(NSDictionary*)dict success:(void (^)( HKOrderFromInfoRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_userOrderInfo body:dict success:^(id  _Nullable responseObject) {
        HKOrderFromInfoRespone *response = [HKOrderFromInfoRespone mj_objectWithKeyValues:responseObject];
        success(response);
    } failure:^(NSError * _Nullable error) {
        HKOrderFromInfoRespone *response = [[HKOrderFromInfoRespone alloc]init];
        success(response);
    }];
}
+(NSString*)orderFormWithStaue:(OrderFormStatue)statue{
    NSString*str;
    switch (statue) {
        case OrderFormStatue_waitPay:{
            str = @"待付款";
        }
            break;
        case OrderFormStatue_verify:{
            str = @"已确认";
        }
            break;
        case OrderFormStatue_payed:{
            str = @"待发货";
        }
            break;
        case OrderFormStatue_cnsignment:{
            str = @"已发货";
        }
            break;
        case OrderFormStatue_consignee:{
            str = @"已收货";
        }
            break;
        case OrderFormStatue_store:{
            str = @"暂储存";
        }
            break;
        case OrderFormStatue_finish:{
            str = @"已完成";
        }
            break;
        case OrderFormStatue_cancel:{
            str = @"已取消";
        }
            break;
        case OrderFormStatue_resale:{
            str = @"已转售";
        }
            break;
        case OrderFormStatue_close:{
            str = @"已关闭";
        }
            break;
            
        default:
            break;
    }
    return str;
}
+(void)expresListWithsuccess:(void (^)(HKExpresListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_expresList body:@{@"loginUid":HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKExpresListRespone *response = [HKExpresListRespone mj_objectWithKeyValues:responseObject];
        if (response.code.length > 0 && response.code.intValue == 0) {
            [NSKeyedArchiver archiveRootObject:response toFile:KExpresListData];
           
        }else{
            response = [NSKeyedUnarchiver unarchiveObjectWithFile:KExpresListData] == nil ? response:[NSKeyedUnarchiver unarchiveObjectWithFile:KExpresListData];
        }
        success(response);
    } failure:^(NSError * _Nullable error) {
        HKExpresListRespone *response = [[HKExpresListRespone alloc]init];
        success(response);
    }];
}
+(void)sellerOrderDeliver:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_sellerOrderDeliver body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)sellerupdateorderprice:(HKRevisePiceParameter*)parameter success:(void (^)( HKBaseResponeModel* responde))success{
    NSDictionary*dict = [parameter mj_keyValues];
    [HK_BaseRequest buildPostRequest:get_sellerupdateorderprice body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)sellerupdatecloseorder:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_sellerupdatecloseorder body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)logisticsInformation:(NSDictionary*)parameter success:(void (^)( HKLogisticsListResponse* responde))success{
    [HK_BaseRequest buildPostRequest:get_logisticsInformation body:parameter success:^(id  _Nullable responseObject) {
        HKLogisticsListResponse* respone = [HKLogisticsListResponse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKLogisticsListResponse* respone = [[HKLogisticsListResponse alloc]init];
        success(respone);
    }];
}
@end
