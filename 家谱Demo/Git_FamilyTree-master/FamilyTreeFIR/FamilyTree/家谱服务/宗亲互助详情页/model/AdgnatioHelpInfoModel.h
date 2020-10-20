//
//  AdgnatioHelpInfoModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdgnatioHelpInfoDataModel;
@interface AdgnatioHelpInfoModel : NSObject

@property (nonatomic, strong) AdgnatioHelpInfoDataModel *data;

@property (nonatomic, assign) BOOL islx;

@property (nonatomic, strong) NSArray *piclist;

@property (nonatomic, assign) BOOL isgz;

@end
@interface AdgnatioHelpInfoDataModel : NSObject

@property (nonatomic, assign) NSInteger ZqId;

@property (nonatomic, copy) NSString *ZqState;

@property (nonatomic, copy) NSString *ZqType;

@property (nonatomic, copy) NSString *ZqBrief;

@property (nonatomic, copy) NSString *ZqCreatetime;

@property (nonatomic, assign) NSInteger ZqMemberid;

@property (nonatomic, assign) NSInteger ZqIntencnt;

@property (nonatomic, copy) NSString *ZqKeepdate;

@property (nonatomic, copy) NSString *ZqCover;

@property (nonatomic, copy) NSString *ZqIstop;

@property (nonatomic, assign) NSInteger ZqFollowcnt;

@property (nonatomic, assign) NSInteger ZqKeepnum02;

@property (nonatomic, copy) NSString *ZqTitle;

@property (nonatomic, assign) NSInteger ZqMoney;

@property (nonatomic, assign) NSInteger ZqKeepnum01;

@property (nonatomic, copy) NSString *ZqContacts;

@property (nonatomic, copy) NSString *ZqTel;

@property (nonatomic, copy) NSString *ZqSx;

@property (nonatomic, copy) NSString *ZqKeepstr02;

@property (nonatomic, copy) NSString *ZqKeepstr01;

@end

