//
//  APIConfig.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIConfig : NSObject

//信息类服务器地址
#define SERVER_HOST @"http://service.ingkee.com"

//图片服务器地址
#define IMAGE_HOST @"http://img.meelive.cn/"


//热门直播
#define API_HotLive @"api/live/gettop"

//附近的人
#define API_NearLive @"api/live/near_recommend" //?uid=85149891&latitude=40.090562&longitude=116.413353

//广告地址
#define API_Advertise @"advertise/get"


//欢哥直播地址
#define Live_Dahuan @"rtmp://live.hkstv.hk.lxdns.com:1935/live/dahuan"



@end
