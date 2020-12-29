//
//  HK_MyVideoTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
#import "HKMyVideo.h"
#import "HKMyVideoCategory.h"
#import "WaterFLayout.h"
#import "HKMyVideoCell.h"
@interface HK_MyVideoTool : NSObject

/***
 *  获取视频分类信息
 */
+(void)getMyVideoCaterGoryInfoMationWithType:(VideoCatergoryType)type  SucceeBlcok:(void(^)(id responseJson))response Failed:(void(^)(NSString *error))error;



/***
 *  根据当前类型返回apiSgtr
 */
+(NSString *)getAPiStrWithVideoType:(VideoCatergoryType)type;


/***
 *  我的游记列表信息
 */
+(void)getTravelsListWithCurrentPage:(NSInteger)page SucceeBlcok:(void(^)(id responseJson))response Failed:(void(^)(NSString *error))error;


@end
