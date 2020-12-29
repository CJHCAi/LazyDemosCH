//
//  HKSetTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSetTool.h"

@implementation HKSetTool

+(void)bindQQWithOpenID:(NSString *)openId userName:(NSString *)name successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error {
    NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
    [dic setValue:HKUSERLOGINID forKey:kloginUid];
    [dic setValue:openId forKey:@"openid"];
    [dic setValue:name forKey:@"name"];
    [HK_BaseRequest  buildPostRequest:get_userqqbind body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success ();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)bindWechatWithCode:(NSString *)code successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest  buildPostRequest:get_userweixinbind body:@{@"code":code,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success ();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getUserAccountInfoSuccessBlock:(void(^)(HKAccountResponse *response))response fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userGetUserInfoById body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKAccountResponse *res =[HKAccountResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)setNewphone:(NSString *)phone successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userSetUserMobile body:@{kloginUid:HKUSERLOGINID,@"mobile":phone} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success ();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)userIsAsShopsuccessBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userIsShop body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success (responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)AppleShopUserWithDic:(NSMutableDictionary *)dic successBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error {
   
    [HK_BaseRequest buildPostRequest:get_userApplyShop body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success (responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)userIsRealNamesuccessBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userIsRealName body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success (responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}

+(void)AppleRealNameDic:(NSMutableDictionary *)dic successBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error {
   
    [HK_BaseRequest buildPostRequest:get_userApplyRealName body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success (responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
+(void)removeBlackLikstWithFriendId:(NSString *)friendId successBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_friendRemoveBlack body:@{kloginUid: HKUSERLOGINID,@"friendId":friendId} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success (responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getBlackListWithPage:(NSInteger)page SuccessBlock:(void(^)(HKBlcakListResponse *response))response fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_friendBlackList body:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKBlcakListResponse * res =[HKBlcakListResponse mj_objectWithKeyValues:responseObject];
        if (res.code ==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}

@end
