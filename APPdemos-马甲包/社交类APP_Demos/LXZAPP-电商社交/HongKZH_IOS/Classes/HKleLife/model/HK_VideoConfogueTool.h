//
//  HK_VideoConfogueTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
#import "HK_VideoHReSponse.h"
#import "HKHisToryVideoCell.h"
#import "HK_TagSeachResponse.h"
#import "HK_AllTags.h"
@interface HK_VideoConfogueTool : NSObject
/***
 *  增加用户观看历史
 */
+(void)addVideoWatchHistoryWithVideoID:(NSString *)videoID successBlock:(void(^)(id response))response fial:(void(^)(NSString * fials))mes;
/***
 *  删除用户历史记录
 */
+(void)deleteUSerWatchHistoryByVideoID:(NSString *)videoID successBlock:(void(^)(id response))response fial:(void(^)(NSString * fials))mes;
/***
 *  获取所有历史记录
 */
+(void)getUserVideoHistoryListByPage:(NSInteger)page successBlock:(void(^)(HK_VideoHReSponse * response))response fial:(void(^)(NSString * fials))mes;
/***
 *  搜索视频标签
 */
+(void)seachVideoTagsWithTagName:(NSString *)tags successBlock:(void(^)(HK_TagSeachResponse * response))response fial:(void(^)(NSString * fials))mes;

/***
 *  获取所有视频标签
 */
+(void)getAllTagssuccessBlock:(void(^)(HK_AllTags * response))response fial:(void(^)(NSString * fials))mes;

@end
