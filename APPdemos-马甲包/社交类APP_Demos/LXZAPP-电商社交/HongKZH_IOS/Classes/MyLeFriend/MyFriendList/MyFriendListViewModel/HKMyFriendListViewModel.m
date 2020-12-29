//
//  HKMyFriendListViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFriendListViewModel.h"
#import "HKFriendRespond.h"
#import "HKUserContentReportController.h"
#import "LEFriendDbManage.h"
@implementation HKMyFriendListViewModel
+(void)myFriend:(NSDictionary*)parameter success:(void (^)( HKFriendRespond* responde))succes{
    [HK_BaseRequest buildPostRequest:get_friendList body:parameter success:^(id  _Nullable responseObject) {
        HKFriendRespond*respone = [HKFriendRespond mj_objectWithKeyValues:responseObject];
        if (respone.responeSuc) {
            NSMutableArray*array = [NSMutableArray array];
            HKFriendModel*myUser = [[HKFriendModel alloc]init];
            myUser.uid = HKUSERID;
            myUser.headImg = [[[LoginUserDataModel getUserInfoItems] headImg]length]> 0 ?  [[LoginUserDataModel getUserInfoItems] headImg]:@"";
            myUser.name = HKUSERName;
            [array addObject:myUser];
            for (HKFriendListModel*listM in respone.data) {
                for (HKFriendModel*friend in listM.list) {
                    [array addObject:friend];
                }
            }
                        [[LEFriendDbManage sharedZSDBManageBaseModel]insertWithFriendArray:array andSuc:^(BOOL isSuc) {
                
            }];
        }
        succes(respone);
    } failure:^(NSError * _Nullable error) {
        HKFriendRespond*respone = [[HKFriendRespond alloc]init];
        succes(respone);
    }];
}

+(void)addFriendToBlackListWithUserId:(NSString *)uid success:(void (^)(id response))succes fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_friendAddBlack body:@{kloginUid:HKUSERLOGINID,@"friendId":uid} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            succes(responseObject);
        }else {
            NSString *msg =responseObject[@"msg"];
            if (msg.length) {
                error(msg);
            }
        }
    } failure:^(NSError * _Nullable error) {
       
    }];
  
}
+(void)addUserContentReportVc:(UIViewController *)controller {
    HKUserContentReportController *reportVc =[[HKUserContentReportController alloc] init];
    [controller.navigationController pushViewController:reportVc animated:YES];
}
+(void)getUserMediaInfoByUid:(NSString *)uid successBlock:(void(^)(HKMediaInfoResponse *response))response fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userInfo body:@{kloginUid:HKUSERLOGINID,@"id":uid} success:^(id  _Nullable responseObject) {
        HKMediaInfoResponse*res = [HKMediaInfoResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            HKFriendModel*friend = [[HKFriendModel alloc]init];
            friend.uid = res.data.uid;
            friend.name = res.data.name;
            friend.sex = res.data.sex;
            friend.level = res.data.level;
            friend.headImg = res.data.headImg;
            [[LEFriendDbManage sharedZSDBManageBaseModel]insertWithFriendArray:@[friend] andSuc:^(BOOL isSuc) {
            }];
            response(res);
            
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
       
    }];
  
}
+(void)getUserShopDataByUid:(NSString *)uid withPage:(NSInteger)page successBlock:(void(^)(HKFrindShopResponse *response))response fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_FuserProductsList body:@{@"pageNumber":@(page),@"uid":uid} success:^(id  _Nullable responseObject) {
        HKFrindShopResponse*res = [HKFrindShopResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getUserVideoDataByUid:(NSString *)uid withPage:(NSInteger)page successBlock:(void(^)(HKUserVideoResponse *response))response fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_FuserMediasList body:@{@"pageNumber":@(page),@"uid":uid} success:^(id  _Nullable responseObject) {
        HKUserVideoResponse*res = [HKUserVideoResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
