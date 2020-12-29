//
//  HKLeSeeViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeViewModel.h"
#import "HKUserCategoryListRespone.h"
#import "HKSowingRespone.h"
#import "HkHotRespone.h"
#import "HKRecommendRespone.h"
#import "CorporateCategoryResponse.h"
#import "EnterpriseHotAdvTypeListRedpone.h"
#import "HKPriseHotAdvListRespone.h"
#import "HKRecruitRespone.h"
#import "CityHomeRespone.h"
#import "CityMainRespone.h"
#import "SelfMediaRespone.h"
#import "CategoryTop10ListRespone.h"
#import "CategoryCirclesListRespone.h"
#import "HKAdvertisementCityInfo.h"
#import "InfoMediaAdvCommentListRespone.h"
#import "HKAdvCommentsByCommentIdRespone.h"
#import "MediaAdvCommentReplyListRespone.h"
#import "HKCityTravelsRespone.h"
#import "HKCityAdvParameter.h"
#import "HKMainAllCategoryListRespone.h"
@implementation HKLeSeeViewModel
+(void)getUserCategoryList:(NSDictionary*)parameter success:(void (^)( HKUserCategoryListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_userCategoryList body:parameter success:^(id  _Nullable responseObject) {
        HKUserCategoryListRespone*respone = [HKUserCategoryListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKUserCategoryListRespone*respone = [[HKUserCategoryListRespone alloc]init];
        success(respone);
    }];
}
+(void)getCarouselListWithSuccess:(void (^)( HKSowingRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_carouselList body:@{} success:^(id  _Nullable responseObject) {
        HKSowingRespone*respone = [HKSowingRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKSowingRespone*respone = [[HKSowingRespone alloc]init];
        success(respone);
    }];
}
+(void)getHotAdvList:(NSDictionary*)parameter success:(void (^)( HkHotRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_hotAdvList body:parameter success:^(id  _Nullable responseObject) {
        HkHotRespone*respone = [HkHotRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HkHotRespone*respone = [[HkHotRespone alloc]init];
        success(respone);
    }];
}
+(void)getRecommendList:(NSDictionary*)parameter success:(void (^)( HKRecommendRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_recommendList body:parameter success:^(id  _Nullable responseObject) {
        HKRecommendRespone*respone = [HKRecommendRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKRecommendRespone*respone = [[HKRecommendRespone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseCarouselListSuccess:(void (^)( HKSowingRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_enterpriseCarouselList body:@{} success:^(id  _Nullable responseObject) {
        HKSowingRespone*respone = [HKSowingRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKSowingRespone*respone = [[HKSowingRespone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseCategoryList:(void (^)( CorporateCategoryResponse* responde))success{
    [HK_BaseRequest buildPostRequest:get_enterpriseCategoryList body:@{} success:^(id  _Nullable responseObject) {
        CorporateCategoryResponse*respone = [CorporateCategoryResponse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CorporateCategoryResponse*respone = [[CorporateCategoryResponse alloc]init];
        success(respone);
    }];
}
+(void)EnterpriseHotAdvTypeList:(void (^)( EnterpriseHotAdvTypeListRedpone* responde))success{
    [HK_BaseRequest buildPostRequest:get_enterpriseHotAdvTypeList body:@{} success:^(id  _Nullable responseObject) {
        EnterpriseHotAdvTypeListRedpone*respone = [EnterpriseHotAdvTypeListRedpone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        EnterpriseHotAdvTypeListRedpone*respone = [[EnterpriseHotAdvTypeListRedpone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseListByCategory:(NSDictionary*)parameter success:(void (^)( HKPriseHotAdvListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getEnterpriseListByCategory body:parameter success:^(id  _Nullable responseObject) {
        HKPriseHotAdvListRespone*respone = [HKPriseHotAdvListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKPriseHotAdvListRespone*respone = [[HKPriseHotAdvListRespone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseHotAdvList:(NSDictionary*)parameter success:(void (^)( HKPriseHotAdvListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_enterpriseHotAdvList body:parameter success:^(id  _Nullable responseObject) {
        HKPriseHotAdvListRespone*respone = [HKPriseHotAdvListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKPriseHotAdvListRespone*respone = [[HKPriseHotAdvListRespone alloc]init];
        success(respone);
    }];
}

+(void)getCategoryCarouselList:(NSDictionary*)parameter success:(void (^)( HKSowingRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_recruitCategoryCarouselList body:parameter success:^(id  _Nullable responseObject) {
        HKSowingRespone*respone = [HKSowingRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKSowingRespone*respone = [[HKSowingRespone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseRecruitList:(NSDictionary*)parameter success:(void (^)( HKRecruitRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_EnterpriseRecruitList body:parameter success:^(id  _Nullable responseObject) {
        HKRecruitRespone*respone = [HKRecruitRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKRecruitRespone*respone = [[HKRecruitRespone alloc]init];
        success(respone);
    }];
}
+(void)getCityAdvList:(HKCityAdvParameter*)parameter success:(void (^)( CityHomeRespone* responde))success{
    [HK_BaseRequest buildPostRequest:parameter.urlString body:[parameter parameter]success:^(id  _Nullable responseObject) {
        CityHomeRespone*respone = [CityHomeRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CityHomeRespone*respone = [[CityHomeRespone alloc]init];
        success(respone);
    }];
}
//获取城市附近列表
+(void)getNearByCityList:(NSInteger)page success:(void (^)( CityHomeRespone* responde))success {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%f",[ViewModelLocator sharedModelLocator].latitude] forKey:@"latitude"];
    [dic setObject:[NSString stringWithFormat:@"%f",[ViewModelLocator sharedModelLocator].longitude] forKey:@"longitude"];
    [dic setObject:@(page) forKey:@"pageNumber"];
    
    [HK_BaseRequest buildPostRequest:get_cityNearbyAdvList body:dic success:^(id  _Nullable responseObject) {
        CityHomeRespone*respone = [CityHomeRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CityHomeRespone*respone = [[CityHomeRespone alloc]init];
        success(respone);
    }];
}
+(void)getCityMain:(NSDictionary*)parameter success:(void (^)( CityMainRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_Main body:parameter success:^(id  _Nullable responseObject) {
        CityMainRespone*respone = [CityMainRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CityMainRespone*respone = [[CityMainRespone alloc]init];
        success(respone);
    }];
}
+(void)getCategoryHotAdvList:(NSDictionary*)parameter success:(void (^)( SelfMediaRespone* responde))success{
    [HK_BaseRequest buildPostRequest:mediaAdvGetMediaHotAdvList body:parameter success:^(id  _Nullable responseObject) {
        SelfMediaRespone*respone = [SelfMediaRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        SelfMediaRespone*respone = [[SelfMediaRespone alloc]init];
        success(respone);
    }];
}

+(void)getNearByListWithPage:(NSInteger)page  success:(void (^)( SelfMediaRespone* responde))success {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%f",[ViewModelLocator sharedModelLocator].latitude] forKey:@"latitude"];
    [dic setObject:[NSString stringWithFormat:@"%f",[ViewModelLocator sharedModelLocator].longitude] forKey:@"longitude"];
    [dic setObject:@(page) forKey:@"pageNumber"];
    
    [HK_BaseRequest buildPostRequest:mediaAdvGgetMediaNearbyAdvList body:dic success:^(id  _Nullable responseObject) {
        
        SelfMediaRespone*respone = [SelfMediaRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        SelfMediaRespone*respone = [[SelfMediaRespone alloc]init];
        success(respone);
    }];
}
+(void)mediaAdvGetCategoryCarouselList:(NSDictionary*)parameter success:(void (^)( HKSowingRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_categoryCarouselList body:parameter success:^(id  _Nullable responseObject) {
        HKSowingRespone*respone = [HKSowingRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKSowingRespone*respone = [[HKSowingRespone alloc]init];
        success(respone);
    }];
}
+(void)getCategoryTop10List:(NSDictionary*)parameter success:(void (^)( CategoryTop10ListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:mediaAdvGetMediaTop10List body:nil success:^(id  _Nullable responseObject) {
        CategoryTop10ListRespone*respone = [CategoryTop10ListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CategoryTop10ListRespone*respone = [[CategoryTop10ListRespone alloc]init];
        success(respone);
    }];
}
+(void)mediaAdvgetCategoryCirclesList:(NSDictionary*)parameter success:(void (^)( CategoryCirclesListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:mediaAdvGetMediaCirclesList body:parameter success:^(id  _Nullable responseObject) {
        
        CategoryCirclesListRespone*respone = [CategoryCirclesListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CategoryCirclesListRespone*respone = [[CategoryCirclesListRespone alloc]init];
        success(respone);
    }];
}
+(void)getCategoryCityAdvList:(NSDictionary*)parameter success:(void (^)( CityHomeRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_categoryCityAdvList body:parameter success:^(id  _Nullable responseObject) {
        CityHomeRespone*respone = [CityHomeRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CityHomeRespone*respone = [[CityHomeRespone alloc]init];
        success(respone);
    }];
}
+(void)getCityInfoById:(NSDictionary*)parameter success:(void (^)( HKAdvertisementCityInfo* responde))success{
    [HK_BaseRequest buildPostRequest:get_cityInfoById body:parameter success:^(id  _Nullable responseObject) {
        HKAdvertisementCityInfo*respone = [HKAdvertisementCityInfo mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKAdvertisementCityInfo*respone = [[HKAdvertisementCityInfo alloc]init];
        success(respone);
    }];
}
+(void)getInfoMediaAdvCommentList:(NSDictionary*)parameter success:(void (^)( InfoMediaAdvCommentListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_infoMediaAdvCommentList body:parameter success:^(id  _Nullable responseObject) {
        InfoMediaAdvCommentListRespone*respone = [InfoMediaAdvCommentListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        InfoMediaAdvCommentListRespone*respone = [[InfoMediaAdvCommentListRespone alloc]init];
        success(respone);
    }];
}
+(void)getAdvCommentsByCommentId:(NSDictionary*)parameter success:(void (^)( HKAdvCommentsByCommentIdRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getAdvCommentsByCommentId body:parameter success:^(id  _Nullable responseObject) {
        HKAdvCommentsByCommentIdRespone*respone = [HKAdvCommentsByCommentIdRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKAdvCommentsByCommentIdRespone*respone = [[HKAdvCommentsByCommentIdRespone alloc]init];
        success(respone);
    }];
}
+(void)getMediaAdvCommentReplyListRespone:(NSDictionary*)parameter success:(void (^)( MediaAdvCommentReplyListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_infoMediaAdvCommentReplyList body:parameter success:^(id  _Nullable responseObject) {
        MediaAdvCommentReplyListRespone*respone = [MediaAdvCommentReplyListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        MediaAdvCommentReplyListRespone*respone = [[MediaAdvCommentReplyListRespone alloc]init];
        success(respone);
    }];
}
+(void)praise:(NSDictionary*)parameter type:(int)type success:(void (^)( HKBaseResponeModel* responde))success{
    NSString*url ;
    if (type == 0) {
        url = get_mediaAdvpraise;
    }else if (type == 1){
        url =get_praise;
    }else if (type == 2){
        url = get_praisePost;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
}
+(void)collection:(NSDictionary*)parameter type:(int)type success:(void (^)( HKBaseResponeModel* responde))success{
    NSString*url;
    if (type == 0) {
        url = get_mediaAdvcollection;//自媒体
    }else if (type == 1){
        url = get_collection;//企业广告
    }else{
        url = get_cityAdvcollection;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
}
+(void)getCityAdvInfo:(NSDictionary*)parameter success:(void (^)( HKCityTravelsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_cityAdvInfo body:parameter success:^(id  _Nullable responseObject) {
        HKCityTravelsRespone* responde = [HKCityTravelsRespone mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKCityTravelsRespone* responde = [[HKCityTravelsRespone alloc]init];
        success(responde);
    }];
}
+(void)advReward:(NSDictionary*)parameter type:(int)type success:(void (^)( HKBaseResponeModel* responde))success{
    NSString*url;
    if (type == 0) {
        url = get_weMediaReward;
    }else{
        url = get_cityReward;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
}
+(void)advComment:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success{
 
    [HK_BaseRequest buildPostRequest:get_comment body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
}
/*********城市数据********/
+(void)getCityCollectionWithState:(NSString *)state andCityId:(NSString  *)cityId success:(void (^)(HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_cityAdvCollection body:@{kloginUid:HKUSERLOGINID,@"state":state,@"cityAdvId":cityId} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
}
+(void)getCityPraiseWithState:(NSString *)state andCityId:(NSString  *)cityId success:(void (^)(HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_cityAdvPraise body:@{kloginUid:HKUSERLOGINID,@"state":state,@"cityAdvId":cityId} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
 
}
+(void)getCityRewardWithState:(NSString *)money andCityId:(NSString  *)cityId success:(void (^)(HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_cityAdvReward body:@{kloginUid:HKUSERLOGINID,@"money":money,@"cityAdvId":cityId} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel* responde = [[HKBaseResponeModel alloc]init];
        success(responde);
    }];
}
+(void)getCategorySearchAdvList:(NSDictionary*)dict success:(void (^)(SelfMediaRespone* responde))success {
    [HK_BaseRequest buildPostRequest:get_getCategorySearchAdvList body:dict success:^(id  _Nullable responseObject) {
        SelfMediaRespone* responde = [SelfMediaRespone mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        SelfMediaRespone* responde = [[SelfMediaRespone alloc]init];
        success(responde);
    }];
}

+(void)getMainAllCategoryList:(NSDictionary*)dict success:(void (^)(HKMainAllCategoryListRespone* responde))success {
    [HK_BaseRequest buildPostRequest:get_getMainAllCategoryList body:dict success:^(id  _Nullable responseObject) {
        HKMainAllCategoryListRespone* responde = [HKMainAllCategoryListRespone mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HKMainAllCategoryListRespone* responde = [[HKMainAllCategoryListRespone alloc]init];
        success(responde);
    }];
}


@end
