//
//  HKMyPostViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostViewModel.h"
#import "HKMyPostsRespone.h"
#import "HKMyPostBaseTableViewCell.h"
#import "HKMyPostShareTableViewCell.h"
#import "HKMyEditPostTableViewCell.h"
#import "HKMyRepliesPostsRespone.h"
#import "HKMyDelPostsRespne.h"
@implementation HKMyPostViewModel
+(void)myPosts:(NSDictionary*)parameter success:(void (^)( HKMyPostsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_myPosts body:parameter success:^(id  _Nullable responseObject) {
        HKMyPostsRespone *respone = [HKMyPostsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyPostsRespone *respone = [[HKMyPostsRespone alloc]init];
        success(respone);
    }];
}
+(void)myRepliesPosts:(NSDictionary*)parameter success:(void (^)( HKMyRepliesPostsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_myRepliesPosts body:parameter success:^(id  _Nullable responseObject) {
        HKMyRepliesPostsRespone *respone = [HKMyRepliesPostsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyRepliesPostsRespone *respone = [[HKMyRepliesPostsRespone alloc]init];
        success(respone);
    }];
}
+(void)myDelPosts:(NSDictionary*)parameter success:(void (^)( HKMyDelPostsRespne* responde))success{
    [HK_BaseRequest buildPostRequest:get_myDelPosts body:parameter success:^(id  _Nullable responseObject) {
        HKMyDelPostsRespne *respone = [HKMyDelPostsRespne mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyDelPostsRespne *respone = [[HKMyDelPostsRespne alloc]init];
        success(respone);
    }];
}
+(HKMyPostBaseTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(HKMyPostModel*)postModel{
    if (postModel.type.intValue == 2||postModel.type.intValue == 3 ) {
        HKMyPostShareTableViewCell *cell = [HKMyPostShareTableViewCell myPostBaseTableViewCellWithTableView:tableView];
        return cell;
    }
    if (postModel.model == MyPostType_MyEdit) {
        HKMyEditPostTableViewCell*cell = [HKMyEditPostTableViewCell myPostBaseTableViewCellWithTableView:tableView];
        return cell;
    }else{
        HKMyPostShareTableViewCell *cell = [HKMyPostShareTableViewCell myPostBaseTableViewCellWithTableView:tableView];
        return cell;
    }
    
    HKMyPostBaseTableViewCell *cell = [HKMyPostBaseTableViewCell myPostBaseTableViewCellWithTableView:tableView];
    return cell;
}
//删除帖子
+(void)deletePostWithPostId:(NSString *)postId andType:(NSString *)type success:(void (^)(HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_friendDeletePost body:@{kloginUid:HKUSERLOGINID,@"postId":postId,@"delType":type} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc] init];
        success(respone);
    }];
}

@end
