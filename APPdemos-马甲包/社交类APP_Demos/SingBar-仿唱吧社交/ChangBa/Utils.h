//
//  Utils.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTextView.h"

typedef void (^MyCallback)(id obj);
@interface Utils : NSObject
//唱歌界面的数据请求
+(void)requestRecommendBannersWithCallback:(MyCallback)callback;
+(void)requestSongsWithCallback:(MyCallback)callback;
+(void)requestTitlesWithCallback:(MyCallback)callback;
+(void)requestboardsWithCallback:(MyCallback)callback;
+(void)requestContentsWithCallback:(MyCallback)callback;
//我的唱吧的数据请求
+(void)requestHomesWithUrlPath:(NSString *)urlPath andCallback:(MyCallback)callback;
//精彩表演轮播图的数据请求
+(void)requestPerformsWithCallback:(MyCallback)callback;
//精彩表演排行榜的数据请求
+(void)requestPerformancesWithCallback:(MyCallback)callback;
//获取音乐播放路径
+(NSDictionary *)getMusicInfoByPath:(NSString *)path;
//获取音乐歌词
+(NSDictionary *)parseLrcWithPath:(NSString *)path;
+(NSString *)parseTimeWithTimeStap:(float)timestap;
+(void)faceMappingWithText:(YYTextView *)tv;
@end
