//
//  HKReleaseVideoSaveDraftDao.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseVideoSaveDraftDao.h"

@implementation HKReleaseVideoSaveDraftDao

//工厂方法
+ (instancetype)saveDraftDao {
    return [[self alloc] init];
}

//增
- (BOOL)addDraft:(HKReleaseVideoSaveDraft *)draft {
    HKReleaseVideoSaveDraft *result = [self searchDraft:draft];
    if (!result) {  //不存在添加
        return [draft saveToDB];
    } else {    //存在更新
        return [self updateDraft:draft];
    }
}
//删
- (BOOL)delDraft:(HKReleaseVideoSaveDraft *)draft {
    return [HKReleaseVideoSaveDraft deleteToDB:draft];
}

//改
- (BOOL)updateDraft:(HKReleaseVideoSaveDraft *)draft {
    NSDictionary *where = @{@"rowid":@(draft.rowid)};
    return  [HKReleaseVideoSaveDraft updateToDB:draft where:where];
}

//查
- (HKReleaseVideoSaveDraft *)searchDraft:(HKReleaseVideoSaveDraft *)draft {
    NSDictionary *where = @{@"rowid":@(draft.rowid)};
    return [[HKReleaseVideoSaveDraft searchWithWhere:where] firstObject];
}

- (NSMutableArray *)searchAll {
    return [HKReleaseVideoSaveDraft searchWithWhere:nil];
}

- (void)dealloc {
    DLog(@"%s",__func__);
}


@end
