//
//  HKLeSeeViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKUserCategoryListRespone,HKSowingRespone,HkHotRespone,HKRecommendRespone,CorporateCategoryResponse,EnterpriseHotAdvTypeListRedpone,HKPriseHotAdvListRespone,HKRecruitRespone,CityHomeRespone,CityMainRespone,SelfMediaRespone,CategoryTop10ListRespone,CategoryCirclesListRespone,HKAdvertisementCityInfo,InfoMediaAdvCommentListRespone,HKAdvCommentsByCommentIdRespone,MediaAdvCommentReplyListRespone,HKCityTravelsRespone,HKCityAdvParameter,HKMainAllCategoryListRespone;
@interface HKLeSeeViewModel : HKBaseViewModel
+(void)getUserCategoryList:(NSDictionary*)parameter success:(void (^)( HKUserCategoryListRespone* responde))success;
+(void)getCarouselListWithSuccess:(void (^)(HKSowingRespone* responde))success;
+(void)getHotAdvList:(NSDictionary*)parameter success:(void (^)( HkHotRespone* responde))success;
+(void)getRecommendList:(NSDictionary*)parameter success:(void (^)( HKRecommendRespone* responde))success;
+(void)getEnterpriseCarouselListSuccess:(void (^)( HKSowingRespone* responde))success;
+(void)getEnterpriseCategoryList:(void (^)( CorporateCategoryResponse* responde))success;
+(void)EnterpriseHotAdvTypeList:(void (^)( EnterpriseHotAdvTypeListRedpone* responde))success;
+(void)getEnterpriseListByCategory:(NSDictionary*)parameter success:(void (^)( HKPriseHotAdvListRespone* responde))success;
+(void)getEnterpriseHotAdvList:(NSDictionary*)parameter success:(void (^)( HKPriseHotAdvListRespone* responde))success;
+(void)getCategoryCarouselList:(NSDictionary*)parameter success:(void (^)( HKSowingRespone* responde))success;
+(void)getEnterpriseRecruitList:(NSDictionary*)parameter success:(void (^)( HKRecruitRespone* responde))success;
+(void)getCityAdvList:(HKCityAdvParameter*)parameter success:(void (^)( CityHomeRespone* responde))success;
+(void)getCityMain:(NSDictionary*)parameter success:(void (^)( CityMainRespone* responde))success;
+(void)getCategoryHotAdvList:(NSDictionary*)parameter success:(void (^)( SelfMediaRespone* responde))success;
+(void)mediaAdvGetCategoryCarouselList:(NSDictionary*)parameter success:(void (^)( HKSowingRespone* responde))success;

//..自媒体top10
+(void)getCategoryTop10List:(NSDictionary*)parameter success:(void (^)( CategoryTop10ListRespone* responde))success;
//获取城市附近列表
+(void)getNearByCityList:(NSInteger)page success:(void (^)( CityHomeRespone* responde))success;

+(void)mediaAdvgetCategoryCirclesList:(NSDictionary*)parameter success:(void (^)( CategoryCirclesListRespone* responde))success;
+(void)getCategoryCityAdvList:(NSDictionary*)parameter success:(void (^)( CityHomeRespone* responde))success;
+(void)getCityInfoById:(NSDictionary*)parameter success:(void (^)( HKAdvertisementCityInfo* responde))success;
+(void)getInfoMediaAdvCommentList:(NSDictionary*)parameter success:(void (^)( InfoMediaAdvCommentListRespone* responde))success;
+(void)getAdvCommentsByCommentId:(NSDictionary*)parameter success:(void (^)( HKAdvCommentsByCommentIdRespone* responde))success;
+(void)getMediaAdvCommentReplyListRespone:(NSDictionary*)parameter success:(void (^)( MediaAdvCommentReplyListRespone* responde))success;
+(void)praise:(NSDictionary*)parameter type:(int)type success:(void (^)( HKBaseResponeModel* responde))success;
+(void)collection:(NSDictionary*)parameter type:(int)type success:(void (^)( HKBaseResponeModel* responde))success;
+(void)advReward:(NSDictionary*)parameter type:(int)type success:(void (^)( HKBaseResponeModel* responde))success;

+(void)getNearByListWithPage:(NSInteger)page  success:(void (^)( SelfMediaRespone* responde))success;

+(void)getCityAdvInfo:(NSDictionary*)parameter success:(void (^)( HKCityTravelsRespone* responde))success;
+(void)advComment:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;

/****** 城市相关的********/
//收藏
+(void)getCityCollectionWithState:(NSString *)state andCityId:(NSString  *)cityId success:(void (^)(HKBaseResponeModel* responde))success;
//点赞
+(void)getCityPraiseWithState:(NSString *)state andCityId:(NSString  *)cityId success:(void (^)(HKBaseResponeModel* responde))success;
//打赏
+(void)getCityRewardWithState:(NSString *)money andCityId:(NSString  *)cityId success:(void (^)(HKBaseResponeModel* responde))success;

+(void)getCategorySearchAdvList:(NSDictionary*)dict success:(void (^)(SelfMediaRespone* responde))success;

+(void)getMainAllCategoryList:(NSDictionary*)dict success:(void (^)(HKMainAllCategoryListRespone* responde))success;
@end
