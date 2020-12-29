//
//  ViewModelLocator.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_UserInfoModel.h"

#import "HK_UserInfoModel.h"


@interface ViewModelLocator : NSObject
@property(nonatomic, copy)NSString *enterpriseId;
@property(nonatomic , copy)NSMutableArray* enterpriseDetailsArray;//循环播放视频数组
@property(nonatomic , assign)BOOL isChose; //yes是自动播放，no不自动播放
@property (nonatomic, assign) CGFloat latitude;///纬度
@property (nonatomic, assign) CGFloat longitude;///经度
@property(nonatomic, copy)NSString *priseStr;//视频点赞数
@property(nonatomic, copy)NSString *colltionStr;//视频收藏数
@property(nonatomic, copy)NSString *productId;//商品id
@property(nonatomic, copy)NSString *categoryId;
@property(nonatomic, copy)NSString *categoryIdArray;
@property(nonatomic, copy)NSString *circleImage;
//圈子建立跳转所属频道
@property(nonatomic, copy)NSString *circleName;
@property(nonatomic, copy)NSString *circleID;
//圈子设置跳转所属频道
@property(nonatomic, copy)NSString *circleSetName;
@property(nonatomic, copy)NSString *circleSetID;



+ (instancetype)sharedModelLocator;

@end
