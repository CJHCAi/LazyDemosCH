//
//  HKMyPostViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKMyPostsRespone,HKMyPostBaseTableViewCell,HKMyPostModel,HKMyRepliesPostsRespone,HKMyDelPostsRespne;
@interface HKMyPostViewModel : HKBaseViewModel
+(void)myPosts:(NSDictionary*)parameter success:(void (^)( HKMyPostsRespone* responde))success;
+(void)myRepliesPosts:(NSDictionary*)parameter success:(void (^)( HKMyRepliesPostsRespone* responde))success;
+(HKMyPostBaseTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(HKMyPostModel*)postModel;
+(void)myDelPosts:(NSDictionary*)parameter success:(void (^)( HKMyDelPostsRespne* responde))success;

+(void)deletePostWithPostId:(NSString *)postId andType:(NSString *)type success:(void (^)( HKBaseResponeModel* responde))success;

@end
