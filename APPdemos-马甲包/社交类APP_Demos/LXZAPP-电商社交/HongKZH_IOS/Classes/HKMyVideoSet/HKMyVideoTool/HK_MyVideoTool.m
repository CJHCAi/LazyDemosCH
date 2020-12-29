//
//  HK_MyVideoTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_MyVideoTool.h"

@implementation HK_MyVideoTool

+(void)getMyVideoCaterGoryInfoMationWithType:(VideoCatergoryType)type  SucceeBlcok:(void(^)(id responseJson))response Failed:(void(^)(NSString *error))error {
    NSString *apiStr;
    switch (type) {
        case Cater_priseCaterGory:
            apiStr = get_myPraiseCategory;
            break;
            
       case Cater_collectionCaterGory:
            apiStr = get_myCollectionCategory;
            break;
       case Cater_videoCatergory:
            apiStr = get_myVideoCategory;
            break;
        default:
            break;
    }
    [HK_BaseRequest buildPostRequest:apiStr body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(NSString *)getAPiStrWithVideoType:(VideoCatergoryType)type {
    NSString *apiStr;
    switch (type) {
        case Cater_priseCaterGory:
            apiStr = get_myPraise;
            break;
            
        case Cater_collectionCaterGory:
            apiStr = get_myCollection;
            break;
        case Cater_videoCatergory:
            apiStr = get_MyVideo;
            break;
        default:
            break;
    }
    return apiStr;
}
//我的游记
+(void)getTravelsListWithCurrentPage:(NSInteger)page SucceeBlcok:(void(^)(id responseJson))response Failed:(void(^)(NSString *error))error {
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:kloginUid];
    [params setValue:@(page) forKey:@"pageNumber"];
    [HK_BaseRequest buildPostRequest:get_myTravels body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        } 
    } failure:^(NSError * _Nullable error) {
        
    }];

}


@end
