//
//  CommodityDetailsViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "CommodityDetailsViewModel.h"
#import "CommodityDetailsRespone.h"
#import "HKShopCateoryParameter.h"
#import "CategoryProductListRespone.h"
@implementation CommodityDetailsViewModel
+(void)getCommodityDetails:(NSDictionary*)dict success:(void (^)( CommodityDetailsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_productById body:dict success:^(id  _Nullable responseObject) {
        CommodityDetailsRespone *respone = [CommodityDetailsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CommodityDetailsRespone *respone = [[CommodityDetailsRespone alloc]init];
        success(respone);
    }];
}
+(void)getProductSkuBySku:(NSDictionary*)dict success:(void (^)( CommodityDetailsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getProductSkuBySku body:dict success:^(id  _Nullable responseObject) {
        CommodityDetailsRespone *respone = [CommodityDetailsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CommodityDetailsRespone *respone = [[CommodityDetailsRespone alloc]init];
        success(respone);
    }];
}
+(void)getAddCart:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_mediaShopAddCart body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)getCategoryProductList:(HKShopCateoryParameter*)parameter success:(void (^)( CategoryProductListRespone* responde))success{
    NSDictionary*dict = [parameter mj_keyValues];
    [HK_BaseRequest buildPostRequest:get_categoryProductList body:dict success:^(id  _Nullable responseObject) {
        CategoryProductListRespone *respone = [CategoryProductListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CategoryProductListRespone *respone = [[CategoryProductListRespone alloc]init];
        success(respone);
    }];
}
+(void)searchProductList:(NSDictionary*)parameter success:(void (^)( CategoryProductListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_searchProductList body:parameter success:^(id  _Nullable responseObject) {
        CategoryProductListRespone *respone = [CategoryProductListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CategoryProductListRespone *respone = [[CategoryProductListRespone alloc]init];
        success(respone);
    }];
}
+(void)getUserCommodityDetails:(NSDictionary*)dict success:(void (^)( CommodityDetailsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getMediaProductById body:dict success:^(id  _Nullable responseObject) {
        CommodityDetailsRespone *respone = [CommodityDetailsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CommodityDetailsRespone *respone = [[CommodityDetailsRespone alloc]init];
        success(respone);
    }];
}
@end
