//
//  HKRLShareSendModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
//站内分享 消息类型 1乐购商品 2自媒体广告详情 3 企业广告视频 4 城市广告 5城市游记 6帖子 7拼团详情 8爆款活动详情9 个人名片 10 自媒体商品 11简历
//

typedef enum{
    SHARE_Type_GOODS = 1,
    SHARE_Type_SELFAdvertisement = 2,
    SHARE_Type_EnterpriseAdvertisement = 3,
    SHARE_Type_CItyAdvertisement = 4,
    SHARE_Type_CityTravels = 5,
    SHARE_Type_POST = 6,
    SHARE_Type_Collage = 7,
    SHARE_Type_Burst = 8,
    SHARE_Type_User = 9,
    SHARE_Type_SELFGOOD = 10,
    SHARE_Type_resume = 11
} SHARE_Type;
@interface HKRLShareSendModel : RCMessageContent
@property (nonatomic, copy)NSString *type;
@property(nonatomic, assign) SHARE_Type shareType;
@property (nonatomic, copy)NSString *title;
//封面
@property (nonatomic, copy)NSString *imgSrc;

@property (nonatomic, copy)NSString *webpageUrl;

@property (nonatomic, copy)NSString *msgText;


@property (nonatomic, copy)NSString *source;//来自了小赚

//性别
@property (nonatomic, copy)NSString * sex;
//等级
@property (nonatomic, copy)NSString * level;

@property (nonatomic, copy)NSString *modelId ;
//;
@property (nonatomic, strong)NSDictionary *extra;
//附加信息
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
