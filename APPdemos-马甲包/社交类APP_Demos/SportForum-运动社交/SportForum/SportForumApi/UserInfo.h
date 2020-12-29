//
//  UserInfo.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "BaseArray.h"

@interface UserRanks : BaseObject

@property(assign, nonatomic) NSUInteger score_rank;
@property(assign, nonatomic) NSUInteger physique_rank;
@property(assign, nonatomic) NSUInteger literature_rank;
@property(assign, nonatomic) NSUInteger magic_rank;

@end

@interface SysConfig : BaseObject

@property(strong, nonatomic) BaseArray *level_score;
@property(strong, nonatomic) BaseArray *pk_effects;

-(id)init;

@end

@interface EventNotices : BaseObject

//id type MsgWsInfo
@property(strong, nonatomic) BaseArray *notices;

-(id)init;

@end

@interface MsgWsBodyItem : BaseObject

@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *content;

@end

@interface MsgWsContent : BaseObject

@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *pid;
@property(strong, nonatomic) NSString *from;
@property(strong, nonatomic) NSString *to;

//id type MsgWsBodyItem
@property(strong, nonatomic) BaseArray *body;

-(id)init;

@end

@interface MsgWsInfo : BaseObject

@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) MsgWsContent *push;

@property(assign, nonatomic) long long time;

-(id)init;

@end

@interface EquipmentInfo : BaseObject

//item equipmentName,equipmentModel
@property(strong, nonatomic) BaseArray *run_shoe;

//item equipmentName,equipmentModel
@property(strong, nonatomic) BaseArray *ele_product;

//item equipmentName,equipmentModel
@property(strong, nonatomic) BaseArray *step_tool;

-(id)init;

@end

@interface PropertiesInfo : BaseObject

@property(assign, nonatomic) NSUInteger physique_value;
@property(assign, nonatomic) NSUInteger literature_value;
@property(assign, nonatomic) NSUInteger magic_value;
@property(assign, nonatomic) NSUInteger rankscore;
@property(assign, nonatomic) NSUInteger rankLevel;
@property(assign, nonatomic) long long coin_value;

@end

@interface  AuthInfo: BaseObject

@property(strong, nonatomic) NSString *auth_desc;
@property(strong, nonatomic) NSString *auth_status;
@property(strong, nonatomic) BaseArray *auth_images;

-(id)init;

@end

@interface AuthInfoList : BaseObject

//item AuthInfo
@property(strong, nonatomic) AuthInfo *idcard;
@property(strong, nonatomic) AuthInfo *cert;
@property(strong, nonatomic) AuthInfo *record;

-(id)init;

@end

@interface UserInfo : BaseObject

@property(strong, nonatomic) NSString *userid;
@property(strong, nonatomic) NSString *nikename;
@property(strong, nonatomic) NSString *phone_number;
@property(strong, nonatomic) NSString *account_type;
@property(strong, nonatomic) NSString *about;
@property(strong, nonatomic) NSString *profile_image;
@property(strong, nonatomic) NSString *hobby;

//用户身份: coach(教练)/admin(管理员), 默认为普通用户
@property(strong, nonatomic) NSString *rankName;
@property(strong, nonatomic) NSString *sex_type;
@property(strong, nonatomic) NSString *relation;//FRIENDS/ATTENTION/FANS/DEFRIEND
@property(strong, nonatomic) NSString *wallet;
@property(strong, nonatomic) NSString *sign;
@property(strong, nonatomic) NSString *emotion;//SECRECY/SINGLE/LOVE/MARRIED/HOMOSEXUAL
@property(strong, nonatomic) NSString *profession;
@property(strong, nonatomic) NSString *fond;
@property(strong, nonatomic) NSString *hometown;
@property(strong, nonatomic) NSString *oftenAppear;
@property(strong, nonatomic) NSString *cover_image;
@property(strong, nonatomic) NSString *pet;//宠物图片
@property(strong, nonatomic) NSString *actor;
@property(strong, nonatomic) BaseArray *user_images;
@property(strong, nonatomic) EquipmentInfo *user_equipInfo;
@property(strong, nonatomic) PropertiesInfo *proper_info;
@property(strong, nonatomic) AuthInfoList *auth_info;

@property(assign, nonatomic) long long register_time;
@property(assign, nonatomic) long long birthday;
@property(assign, nonatomic) long long last_login_time;
@property(assign, nonatomic) long long ban_time;
@property(assign, nonatomic) float longitude;
@property(assign, nonatomic) float latitude;

@property(assign, nonatomic) BOOL beFriend;
@property(assign, nonatomic) BOOL beOnline;
@property(assign, nonatomic) BOOL setinfo;

@property(assign, nonatomic) NSUInteger height;
@property(assign, nonatomic) NSUInteger weight;
@property(assign, nonatomic) NSUInteger friend_count;
@property(assign, nonatomic) NSUInteger attention_count;
@property(assign, nonatomic) NSUInteger fans_count;
@property(assign, nonatomic) NSUInteger post_count;
@property(assign, nonatomic) NSUInteger score_rank;

-(id)init;

@end

@interface UserUpdateInfo : BaseObject

@property(strong, nonatomic) NSString *nikename;
@property(strong, nonatomic) NSString *phone_number;
@property(strong, nonatomic) NSString *about;
@property(strong, nonatomic) NSString *hobby;
@property(strong, nonatomic) NSString *sex_type;
@property(strong, nonatomic) NSString *sign;
@property(strong, nonatomic) NSString *emotion;//SECRECY/SINGLE/LOVE/MARRIED/HOMOSEXUAL
@property(strong, nonatomic) NSString *profession;
@property(strong, nonatomic) NSString *fond;
@property(strong, nonatomic) NSString *hometown;
@property(strong, nonatomic) NSString *oftenAppear;
@property(strong, nonatomic) NSString *cover_image;

@property(assign, nonatomic) NSUInteger height;
@property(assign, nonatomic) NSUInteger weight;
@property(assign, nonatomic) long long birthday;

@end

@interface ExpEffect : BaseObject

@property(assign, nonatomic) NSUInteger exp_physique;
@property(assign, nonatomic) NSUInteger exp_literature;
@property(assign, nonatomic) NSUInteger exp_magic;
@property(assign, nonatomic) long long exp_coin;
@property(assign, nonatomic) NSUInteger exp_rankscore;
@property(assign, nonatomic) NSUInteger exp_rankLevel;

@end

@interface TasksInfo : BaseObject

@property(strong, nonatomic) NSString *source;
@property(assign, nonatomic) long long begin_time;
@property(assign, nonatomic) long long end_time;
@property(assign, nonatomic) long long duration;

//UNIT 米
@property(assign, nonatomic) NSUInteger distance;

@property(strong, nonatomic) NSString *task_tip;
@property(strong, nonatomic) NSString *task_type;
@property(strong, nonatomic) NSString *task_status;
@property(strong, nonatomic) NSString *task_desc;
@property(strong, nonatomic) NSString *task_result;
@property(strong, nonatomic) NSString *task_video;
@property(assign, nonatomic) NSUInteger task_id;
@property(strong, nonatomic) BaseArray *task_pics;

-(id)init;

@end

@interface TasksInfoList : BaseObject

//id type TasksInfo
@property(strong, nonatomic) BaseArray *task_list;

@property(assign, nonatomic) NSUInteger week_id;

//本周目标跑步距离(米)
@property(assign, nonatomic) NSUInteger task_target_distance;

//本周实际跑步距离(米)
@property(assign, nonatomic) NSUInteger task_actual_distance;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface TaskStatistics : BaseObject

//完成跑步任务总距离（米）
@property(assign, nonatomic) NSUInteger distance;

//总完成的跑步任务数
@property(assign, nonatomic) NSUInteger run;

//总完成的发表文章任务数
@property(assign, nonatomic) NSUInteger article;

//总完成的游戏任务数
@property(assign, nonatomic) NSUInteger game;

@end

@interface TasksCurInfo : BaseObject

@property(strong, nonatomic) TasksInfo *task;

@property(strong, nonatomic) TaskStatistics *stat;

//本周目标跑步距离(米)
@property(assign, nonatomic) NSUInteger task_target_distance;

//本周实际跑步距离(米)
@property(assign, nonatomic) NSUInteger task_actual_distance;

-(id)init;

@end

@interface TasksReferList : BaseObject

//id type TasksReferInfo
@property(strong, nonatomic) BaseArray *referrals;

-(id)init;

@end

@interface TasksReferInfo : BaseObject

@property(strong, nonatomic) NSString *userid;
@property(strong, nonatomic) NSString *nikename;
@property(strong, nonatomic) NSString *profile_image;
@property(strong, nonatomic) NSString *sex_type;
@property(strong, nonatomic) NSString *last_id;

@property(strong, nonatomic) BaseArray *user_images;

@property(assign, nonatomic) float longitude;
@property(assign, nonatomic) float latitude;
@property(assign, nonatomic) float run_ratio;
@property(assign, nonatomic) float post_ratio;
@property(assign, nonatomic) float pk_ratio;

@property(assign, nonatomic) long long birthday;
@property(assign, nonatomic) long long last_login_time;
@property(assign, nonatomic) long long last_time;
@property(assign, nonatomic) NSUInteger last_distance;

@end

@interface ImportContactList : BaseObject

//id type UserInfo
@property(strong, nonatomic) BaseArray *users;

-(id)init;

@end

@interface GameResultInfo : BaseObject

//id type LeaderBoardItem
@property(strong, nonatomic) BaseArray *total_list;

//id type LeaderBoardItem
@property(strong, nonatomic) BaseArray *friends_list;

@property(assign, nonatomic) NSUInteger total_score;

@property(assign, nonatomic) NSUInteger percent;

@property(assign, nonatomic) NSUInteger percentFri;

-(id)init;

@end

@interface PayHistory : BaseObject

@property(strong, nonatomic) NSString *page_frist_id;
@property(strong, nonatomic) NSString *page_last_id;

//id type PayCoinInfo
@property(strong, nonatomic) BaseArray *payCoinList;

-(id)init;

@end

@interface PayCoinInfo : BaseObject

@property(assign, nonatomic) NSUInteger value;
@property(assign, nonatomic) long long coin_value;
@property(assign, nonatomic) long long time;

@end

