//
//  HKCicleMemberVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
@class HKMyCircleData;
@class HKMediaInfoResponse;
@interface HKCicleMemberVc : HKBaseViewController
@property (nonatomic, strong)HKMyCircleData *model;
//群主
@property (nonatomic, assign)BOOL isMain;
@property (nonatomic, copy) NSString *cicleId;
//个人中心 关注的人跳转...
@property (nonatomic, strong)HKMediaInfoResponse * infoData;

@end
