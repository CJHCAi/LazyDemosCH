//
//  SportRecordInfo.h
//  SportForum
//
//  Created by liyuan on 14-7-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "BaseArray.h"

@interface SportRecordInfo : BaseObject

@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *status;
@property(strong, nonatomic) NSString *result;
@property(strong, nonatomic) NSString *source;
@property(strong, nonatomic) NSString *mood;
@property(strong, nonatomic) BaseArray *sport_pics;

@property(assign, nonatomic) long long begin_time;
@property(assign, nonatomic) long long end_time;
@property(assign, nonatomic) long long coin_value;
@property(assign, nonatomic) NSUInteger weight;
@property(assign, nonatomic) NSUInteger heart_rate;//次/分钟

///UNIT 秒
@property(assign, nonatomic) NSUInteger duration;

//UNIT 米
@property(assign, nonatomic) NSUInteger distance;

@property(strong, nonatomic) NSString *game_type;
@property(strong, nonatomic) NSString *game_name;
@property(assign, nonatomic) NSUInteger game_score;
@property(assign, nonatomic) NSUInteger magic;

-(id)init;

@end

@interface SportRecordInfoList : BaseObject

@property(strong, nonatomic) NSString *page_frist_id;
@property(strong, nonatomic) NSString *page_last_id;

//id type SportRecordInfo
@property(strong, nonatomic) BaseArray *record_list;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface LeaderBoardItem : BaseObject

@property(strong, nonatomic) NSString *userid;
@property(strong, nonatomic) NSString *nikename;
@property(strong, nonatomic) NSString *user_profile_image;
@property(strong, nonatomic) NSString *sex_type;
@property(strong, nonatomic) NSString *locaddr;
@property(strong, nonatomic) NSString *phone_number;
@property(strong, nonatomic) NSString *actor;

//最新发表的内容
@property(strong, nonatomic) NSString *status;

@property(assign, nonatomic) NSUInteger score;
@property(assign, nonatomic) NSUInteger index;
@property(assign, nonatomic) NSUInteger rankLevel;
@property(assign, nonatomic) NSUInteger total_distance;
@property(assign, nonatomic) float longitude;
@property(assign, nonatomic) float latitude;
@property(assign, nonatomic) long long birthday;
@property(assign, nonatomic) long long recent_login_time;
@property(assign, nonatomic) long long coins;

@end

@interface LeaderBoardItemList : BaseObject

@property(strong, nonatomic) NSString *page_frist_id;
@property(strong, nonatomic) NSString *page_last_id;

//id type LeaderBoardItem
@property(strong, nonatomic) BaseArray *members_list;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface RecordStatisticsInfo : BaseObject

//用户身份: coach(教练)/admin(管理员), 默认为普通用户
@property(strong, nonatomic) NSString *actor;
@property(strong, nonatomic) NSString *rankName;
@property(strong, nonatomic) SportRecordInfo *max_distance_record;
@property(strong, nonatomic) SportRecordInfo *max_speed_record;

@property(assign, nonatomic) NSUInteger total_records_count;
@property(assign, nonatomic) NSUInteger total_distance;
@property(assign, nonatomic) NSUInteger total_duration;
@property(assign, nonatomic) NSUInteger rankscore;
@property(assign, nonatomic) NSUInteger rankLevel;
@property(assign, nonatomic) NSUInteger top_index;
@property(assign, nonatomic) NSUInteger leaderboard_max_items;

-(id)init;

@end

@interface VideoInfo : BaseObject

@property(strong, nonatomic) NSString *videoid;
@property(strong, nonatomic) NSString *preview_url;
@property(strong, nonatomic) NSString *download_url;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *desc;
@property(strong, nonatomic) NSString *author;

@property(assign, nonatomic) long long datepublished;
@property(assign, nonatomic) long long duration;
@property(assign, nonatomic) int viewcount;
@property(assign, nonatomic) int likecount;
@property(assign, nonatomic) int dislikecount;

@end

@interface VideoSearchInfo : BaseObject

@property(strong, nonatomic) NSString *videoid;
@property(strong, nonatomic) NSString *preview_url;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *author;

@property(assign, nonatomic) long long datepublished;
@property(assign, nonatomic) long long duration;

@end

@interface VideoSearchInfoList : BaseObject

@property(assign, nonatomic) long long pagetoken;

//id type VideoSearchInfo
@property(strong, nonatomic) BaseArray *videolist;

-(id)initWithSubClass:(NSString *)subClass;

@end

