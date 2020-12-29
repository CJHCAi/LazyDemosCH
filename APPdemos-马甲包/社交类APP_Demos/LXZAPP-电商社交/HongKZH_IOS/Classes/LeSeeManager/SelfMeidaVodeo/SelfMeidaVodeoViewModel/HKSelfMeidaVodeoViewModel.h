//
//  HKSelfMeidaVodeoViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
#import "HKCompanyResPonse.h"
#import "HKCompanyPublishResponse.h"
@class GetMediaAdvAdvByIdRespone,EnterpriseAdvRespone,AllAlbumByUserRespone,AllProductByUserRespone;
@interface HKSelfMeidaVodeoViewModel : HKBaseViewModel
+(void)getMediaAdvAdvById:(NSDictionary*)parameter success:(void (^)( GetMediaAdvAdvByIdRespone* responde))success;
+(void)getCityAdvMediaInfo:(NSDictionary*)parameter success:(void (^)( GetMediaAdvAdvByIdRespone* responde))success;
+(void)getEnterpriseAdv:(NSDictionary*)parameter success:(void (^)( EnterpriseAdvRespone* responde))success;
+(void)getAllAlbumByUserId:(NSDictionary*)parameter success:(void (^)(AllAlbumByUserRespone* responde))success;
+(void)getAllProductByUserId:(NSDictionary*)parameter success:(void (^)(AllProductByUserRespone* responde))success;
+(void)getRedPacketsMediaAdvById:(NSDictionary*)parameter success:(void (^)(HKBaseResponeModel* responde))success;
+(void)getEndPlayMediaAdvById:(NSDictionary*)parameter type:(int)type success:(void (^)(HKBaseResponeModel* responde))success;
+(void)praiseMediaAdvComment:(NSDictionary*)parameter type:(int)type success:(void (^)(HKBaseResponeModel* responde))success;
//企业详情
+(void)getCompanyInfoWithEnterpriseId:(NSString *)enterpriseId success:(void (^)(HKCompanyResPonse* responde))success;
//企业历史发布
+(void)getPublishHistoryWithEnterpriseId:(NSString *)enterpriseId andPage:(NSInteger)page success:(void (^)(HKCompanyPublishResponse* responde))success;
//关注企业
+(void)flowAddEnterpriseWithEnterpriseId:(NSString *)enterpriseId success:(void (^)(HKBaseResponeModel* responde))success;

@end
