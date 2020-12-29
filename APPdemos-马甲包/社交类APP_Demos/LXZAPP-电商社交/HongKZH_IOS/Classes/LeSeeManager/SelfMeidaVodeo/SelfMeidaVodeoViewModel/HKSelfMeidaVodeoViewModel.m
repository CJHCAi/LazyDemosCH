//
//  HKSelfMeidaVodeoViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMeidaVodeoViewModel.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "EnterpriseAdvRespone.h"
#import "AllAlbumByUserRespone.h"
#import "AllProductByUserRespone.h"
@implementation HKSelfMeidaVodeoViewModel
+(void)getMediaAdvAdvById:(NSDictionary*)parameter success:(void (^)( GetMediaAdvAdvByIdRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_mediaAdvAdvById body:parameter success:^(id  _Nullable responseObject) {
        GetMediaAdvAdvByIdRespone*respone = [GetMediaAdvAdvByIdRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        GetMediaAdvAdvByIdRespone*respone = [[GetMediaAdvAdvByIdRespone alloc]init];
        success(respone);
    }];
}
+(void)getCityAdvMediaInfo:(NSDictionary*)parameter success:(void (^)( GetMediaAdvAdvByIdRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getCityAdvMediaInfo body:parameter success:^(id  _Nullable responseObject) {
        GetMediaAdvAdvByIdRespone*respone = [GetMediaAdvAdvByIdRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        GetMediaAdvAdvByIdRespone*respone = [[GetMediaAdvAdvByIdRespone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseAdv:(NSDictionary*)parameter success:(void (^)(EnterpriseAdvRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_enterpriseAdvById body:parameter success:^(id  _Nullable responseObject) {
        EnterpriseAdvRespone*respone = [EnterpriseAdvRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        EnterpriseAdvRespone*respone = [[EnterpriseAdvRespone alloc]init];
        success(respone);
    }];
}
+(void)getAllAlbumByUserId:(NSDictionary*)parameter success:(void (^)(AllAlbumByUserRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_allAlbumByUserId body:parameter success:^(id  _Nullable responseObject) {
        AllAlbumByUserRespone*respone = [AllAlbumByUserRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        AllAlbumByUserRespone*respone = [[AllAlbumByUserRespone alloc]init];
        success(respone);
    }];
}
+(void)getAllProductByUserId:(NSDictionary*)parameter success:(void (^)(AllProductByUserRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_allProductByUserId body:parameter success:^(id  _Nullable responseObject) {
        AllProductByUserRespone*respone = [AllProductByUserRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        AllProductByUserRespone*respone = [[AllProductByUserRespone alloc]init];
        success(respone);
    }];
    
}
+(void)getRedPacketsMediaAdvById:(NSDictionary*)parameter success:(void (^)(HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_getRedPacketsMediaAdvById body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)getEndPlayMediaAdvById:(NSDictionary*)parameter type:(int)type success:(void (^)(HKBaseResponeModel* responde))success{
    NSString*url ;
    if (type == 0) {
        url = get_endPlayMediaAdvById;
    }else{
        url = get_endPlayEnterpriseAdvById;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)praiseMediaAdvComment:(NSDictionary*)parameter type:(int)type success:(void (^)(HKBaseResponeModel* responde))success{
    NSString*url ;
    if (type == 0) {
        url = get_praiseMediaAdvComment;
    }else{
        url = get_endPlayEnterpriseAdvById;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)getCompanyInfoWithEnterpriseId:(NSString *)enterpriseId success:(void (^)(HKCompanyResPonse* responde))success {
    [HK_BaseRequest buildPostRequest:get_enterpriseAdvGetEnterpriseId body:@{@"enterpriseId":enterpriseId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKCompanyResPonse*respone = [HKCompanyResPonse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKCompanyResPonse*respone = [[HKCompanyResPonse alloc]init];
        success(respone);
    }];
 
}
+(void)getPublishHistoryWithEnterpriseId:(NSString *)enterpriseId andPage:(NSInteger)page success:(void (^)(HKCompanyPublishResponse* responde))success {
    [HK_BaseRequest buildPostRequest:get_enterpriseAdvGetEnterpriseReleaseAdvList body:@{@"enterpriseId":enterpriseId,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKCompanyPublishResponse*respone = [HKCompanyPublishResponse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKCompanyPublishResponse*respone = [[HKCompanyPublishResponse alloc]init];
        success(respone);
    }];
}
+(void)flowAddEnterpriseWithEnterpriseId:(NSString *)enterpriseId success:(void (^)(HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_CompanyuserFollowAdd body:@{@"enterpriseId":enterpriseId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
@end
