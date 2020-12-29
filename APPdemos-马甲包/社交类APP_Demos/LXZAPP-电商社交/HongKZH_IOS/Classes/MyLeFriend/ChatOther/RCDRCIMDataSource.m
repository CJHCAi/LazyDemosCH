//
//  RCDRCIMDelegateImplementation.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDRCIMDataSource.h"
#import "HKFriendRespond.h"
#import "LEFriendDbManage.h"
#import "HKLeCircleDbManage.h"
#import "HKCliceListRespondeModel.h"
@interface RCDRCIMDataSource ()

@end

@implementation RCDRCIMDataSource

+ (RCDRCIMDataSource *)shareInstance {
    static RCDRCIMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];

    });
    return instance;
}
#pragma mark - RCIMUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion
{
    RCUserInfo *user = [[RCUserInfo alloc] init];
    //    user = [[RCIM sharedRCIM] getUserInfoCache:userId];融云数据库不好使
    HKFriendModel*queryM = [[HKFriendModel alloc]init];
    queryM.uid = userId;
    HKFriendModel *model  =(HKFriendModel*) [[LEFriendDbManage sharedZSDBManageBaseModel]queryWithModel:queryM];
    user.name = model.name;
    user.userId = model.uid;
    user.portraitUri = model.headImg;
    return completion(user);
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion
{
    RCGroup *user = [[RCGroup alloc] init];
    //   user = [[RCIM sharedRCIM] getGroupInfoCache:groupId];融云数据库不好使
    HKClicleListModel*cricleM = [[HKClicleListModel alloc]init];
    cricleM.circleId = groupId;
    HKClicleListModel *model  = (HKClicleListModel*)[[HKLeCircleDbManage sharedZSDBManageBaseModel]queryWithModel:cricleM];
    user.groupName = model.circleName;
    user.groupId = model.circleId;
    user.portraitUri = model.coverImgSrc;
    return completion(user);
    
}

@end
