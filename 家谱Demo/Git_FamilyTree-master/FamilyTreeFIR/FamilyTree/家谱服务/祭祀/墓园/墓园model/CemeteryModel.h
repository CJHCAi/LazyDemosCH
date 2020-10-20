//
//  CemeteryModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/5.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CemeteryModel : NSObject

@property (nonatomic, copy) NSString *CeCover;

@property (nonatomic, copy) NSString *CeState;

@property (nonatomic, assign) NSInteger CeMeid;

@property (nonatomic, copy) NSString *CeName;

@property (nonatomic, copy) NSString *CeEpitaph;

@property (nonatomic, copy) NSString *CeMaster;

@property (nonatomic, copy) NSString *CeDeathday;

@property (nonatomic, copy) NSString *CeBrief;

@property (nonatomic, assign) NSInteger CeReadcount;

@property (nonatomic, copy) NSString *CeKeepstr01;

@property (nonatomic, copy) NSString *CeKeepstr02;

@property (nonatomic, copy) NSString *CeType;

@property (nonatomic, copy) NSString *CePhoto;

@property (nonatomic, assign) NSInteger CeKeepnum01;

@property (nonatomic, assign) NSInteger CeKeepnum02;

@property (nonatomic, copy) NSString *CeKeepdate;

@property (nonatomic, copy) NSString *CeCreatetime;

@property (nonatomic, assign) NSInteger CeId;

/** 生辰*/
@property (nonatomic, strong) NSString *CeBrithday;

/** 生辰忌日小写*/
@property (nonatomic, strong) NSString *CeScjr;

/** 称谓(慈父)*/
@property (nonatomic, strong) NSString *CeTitle ;
@end
