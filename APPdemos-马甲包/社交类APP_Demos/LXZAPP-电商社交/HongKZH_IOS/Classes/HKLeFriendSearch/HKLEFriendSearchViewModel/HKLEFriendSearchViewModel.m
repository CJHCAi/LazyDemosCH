//
//  HKLEFriendSearchViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLEFriendSearchViewModel.h"
#import "HK_BaseRequest.h"
#import "LEFriendSearchModel.h"
#import "HKLESearchBaseModel.h"
@implementation HKLEFriendSearchViewModel
+(void)leFriendSearch:(NSDictionary*)dict success:(void (^)( NSMutableArray* array))success{
    
    [HK_BaseRequest buildPostRequest:get_LeFriendsearch body:dict success:^(id  _Nullable responseObject) {
     LEFriendSearchModel* model =   [LEFriendSearchModel mj_objectWithKeyValues:responseObject];
        
        NSArray *messsageResult = [[RCIMClient sharedRCIMClient]searchConversations:@[ @(ConversationType_GROUP), @(ConversationType_PRIVATE) ]messageType:@[[RCTextMessage getObjectName], [RCRichContentMessage getObjectName], [RCFileMessage getObjectName]   ]keyword:dict[@"name"]];
        NSMutableArray *array = [NSMutableArray array];
        if (model.data.friends.count>0) {
          HKLESearchBaseModel*friendM =  [[HKLESearchBaseModel alloc]init];
            friendM.type = 0;
            friendM.modelArray = model.data.friends;
            [array addObject:friendM];
        }
        if (messsageResult.count>0) {
            HKLESearchBaseModel*friendM =  [[HKLESearchBaseModel alloc]init];
            friendM.type = 1;
            friendM.modelArray = messsageResult;
            [array addObject:friendM];
        }
        if (model.data.circles.count) {
            HKLESearchBaseModel*friendM =  [[HKLESearchBaseModel alloc]init];
            friendM.type = 2;
            friendM.modelArray = model.data.circles;
            [array addObject:friendM];
        }
        success(array);
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
