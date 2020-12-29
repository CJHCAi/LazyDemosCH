//
//  HKShareBaseModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKMyGoodsRespone.h"
#import <ShareSDK/ShareSDK.h>
#import "HKRLShareSendModel.h"
#import "HKluckyBurstDetailRespone.h"
#import "WXApi.h"
#import "HKMyPostsRespone.h"
#import "HKFriendRespond.h"
#import "HKCliceListRespondeModel.h"
@class HKBurstingActivityShareModel,EnterpriseAdvRespone,HKMyCopunDetailResponse,HKCollageResPonse,HKCollageOrderResponse,GetMediaAdvAdvByIdRespone;

@interface HKShareBaseModel : NSObject
@property (nonatomic, strong)HKRLShareSendModel *message;
@property(nonatomic, assign) SSDKPlatformType platform;
@property (nonatomic, copy)NSString *text;
@property(nonatomic, assign) BOOL bText;
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *videoDescription;
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *webpageUrl;
@property(nonatomic, assign) SHARE_Type shareType;

@property (nonatomic, strong)SendMessageToWXReq *req;

@property (nonatomic,weak) UIViewController *subVc;


//以下是构造用的数据源
//分享商品
@property (nonatomic, strong)HKMyGoodsModel *goodsModel;
//好友助力
@property (nonatomic, strong)LuckyBurstDetailData *burstListData;
@property (nonatomic, strong)HKMyPostModel *postModel;

@property (nonatomic, strong)EnterpriseAdvRespone *advM;
//拼团
@property (nonatomic, strong)HKCollageOrderResponse *copun;

//好友明星片
@property (nonatomic, strong)HKFriendModel *friendM;
//圈子
@property (nonatomic, strong)HKClicleListModel *circleM;
//自媒体视频
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *mediaModel;
@end
