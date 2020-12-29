//
//  HKReleaseVideoSaveDraftDao.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKReleaseVideoSaveDraft.h"

@interface HKReleaseVideoSaveDraftDao : NSObject

//增
- (BOOL)addDraft:(HKReleaseVideoSaveDraft *)draft;
//删
- (BOOL)delDraft:(HKReleaseVideoSaveDraft *)draft;
//改
- (BOOL)updateDraft:(HKReleaseVideoSaveDraft *)draft;
//查
- (HKReleaseVideoSaveDraft *)searchDraft:(HKReleaseVideoSaveDraft *)draft;
- (NSMutableArray *)searchAll;

//工厂方法
+ (instancetype)saveDraftDao;

@end
