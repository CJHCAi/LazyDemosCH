//
//  HK_FollowFansResponse.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FollowFansResponse.h"

@implementation HK_FollowFansResponse

+(void)getFansFollowListWith:(FollowFansType)type CurentPage:(NSInteger)page successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:kloginUid];
    [params setValue:@(page) forKey:@"pageNumber"];
    [HK_BaseRequest buildPostRequest:[self apiStrFromType:type] body:params success:^(id  _Nullable responseObject) {
       
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            
            successObject(responseObject);
        }else {
            fail([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(NSString *)apiStrFromType:(FollowFansType)type {
    NSString *apiStr;
    switch (type) {
        case FollowsFan_Fans:
            apiStr = get_myFans;
            break;
        case  FollowsFans_MyFollow:
            
            apiStr =get_myFollows;
            break;
        case  FollowsFans_EnterPriseFollow:
            
            apiStr =get_myFollowsEnterprise;
            break;
        default:
            break;
    }
    return apiStr;
    
}
/***
 *  关注用户 根据ID
 */
+(void)followSomeOneByIdString:(NSString *)idStr andType:(FollowFansType)type successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:kloginUid];
    [params setValue:idStr forKey:@"followUserId"];
    [HK_BaseRequest buildPostRequest:get_followAdd body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            
            successObject(responseObject);
        }else {
            fail([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)CanCelSomeOneByIdString:(NSString *)idStr andType:(FollowFansType)type successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:kloginUid];
    [params setValue:idStr forKey:@"followUserId"];
    [HK_BaseRequest buildPostRequest:get_followDelete body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            
            successObject(responseObject);
        }else {
            fail([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)addFriendWithUid:(NSString *)uid successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail {
    [HK_BaseRequest buildPostRequest:get_friendAddFriend body:@{kloginUid:HKUSERLOGINID,@"friendId":uid} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            successObject(responseObject);
        }else {
            fail([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
