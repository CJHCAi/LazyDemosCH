//
//  HK_VideoConfogueTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_VideoConfogueTool.h"

@implementation HK_VideoConfogueTool

+(void)addVideoWatchHistoryWithVideoID:(NSString *)videoID successBlock:(void(^)(id response))response fial:(void(^)(NSString * fials))mes {
    [HK_BaseRequest buildPostRequest:get_userHistoryAdd body:@{kloginUid:HKUSERLOGINID,@"advId":videoID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            mes([responseObject objectForKey:@"msg"]);
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)deleteUSerWatchHistoryByVideoID:(NSString *)videoID successBlock:(void(^)(id response))response fial:(void(^)(NSString * fials))mes {
    
    [HK_BaseRequest buildPostRequest:get_userHistoryDelete body:@{@"id":videoID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            mes([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getUserVideoHistoryListByPage:(NSInteger)page successBlock:(void(^)(HK_VideoHReSponse * response))response fial:(void(^)(NSString * fials))mes {
    
    [HK_BaseRequest buildPostRequest:get_userHistoryList body:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HK_VideoHReSponse * res =[HK_VideoHReSponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            response(res);
        }else {
            mes(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)seachVideoTagsWithTagName:(NSString *)tags successBlock:(void(^)(HK_TagSeachResponse * response))response fial:(void(^)(NSString * fials))mes {
    
    [HK_BaseRequest buildPostRequest:get_searchTags body:@{kloginUid:HKUSERLOGINID,@"tag":tags} success:^(id  _Nullable responseObject) {
        HK_TagSeachResponse * res =[HK_TagSeachResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            response(res);
        }else {
            mes(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getAllTagssuccessBlock:(void(^)(HK_AllTags * response))response fial:(void(^)(NSString * fials))mes {
    
    [HK_BaseRequest buildPostRequest:get_getAllTags body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HK_AllTags * res =[HK_AllTags mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            response(res);
        }else {
            mes(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
