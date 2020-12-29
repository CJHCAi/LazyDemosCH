//
//  HKFriendViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendViewModel.h"
#import "HK_BaseRequest.h"
#import "HKFriendRespond.h"
#import "HKCliceListRespondeModel.h"
#import "LEFriendDbManage.h"
#import "HKLeCircleDbManage.h"
@implementation HKFriendViewModel
+(void)loadFriendList:(NSDictionary*)dict success:(void (^)( HKFriendRespond* responde))success{
    [HK_BaseRequest buildPostRequest:get_friendList body:dict success:^(id  _Nullable responseObject) {
        DLog(@"");
        HKFriendRespond *respond = [HKFriendRespond mj_objectWithKeyValues:responseObject];
        if (respond.responeSuc) {
            NSMutableArray*array = [NSMutableArray array];
            for (HKFriendListModel*listM in respond.data) {
                for (HKFriendModel*friend in listM.list) {
                    [array addObject:friend];
                }
            }
            [[LEFriendDbManage sharedZSDBManageBaseModel]insertWithFriendArray:array andSuc:^(BOOL isSuc) {
                DLog()
            }];
        }
        success(respond);
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
+(void)loadClicleList:(NSDictionary*)dict success:(void (^)( HKCliceListRespondeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_circleList body:dict success:^(id  _Nullable responseObject) {
        DLog(@"");
          HKCliceListRespondeModel *respone = [HKCliceListRespondeModel mj_objectWithKeyValues:responseObject];
        NSMutableArray*array = [NSMutableArray array];
        if (respone.responeSuc) {
            for (HKCliceListData*listM in respone.data) {
                for (HKClicleListModel*model in listM.list) {
                    [array addObject:model];
                }
            }
            [[HKLeCircleDbManage sharedZSDBManageBaseModel]insertWithFriendArray:array andSuc:^(BOOL isSuc) {
                
            }];
        }
       
            success(respone);
       
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)shareForwardPost:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_forwardPost body:dict success:^(id  _Nullable responseObject) {
        DLog(@"");
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
   
        
        success(respone);
        
        
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
         success(respone);
    }];
}
@end
