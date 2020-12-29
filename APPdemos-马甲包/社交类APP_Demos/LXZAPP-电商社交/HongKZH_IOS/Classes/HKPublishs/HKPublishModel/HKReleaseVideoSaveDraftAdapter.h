//
//  HKReleaseVideoSaveDraftAdapter.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKReleaseVideoSaveDraft.h"
/**
    1.HKReleaseVideoParam->HKReleaseVideoSaveDraft
    2.HKReleaseVideoSaveDraft->HKReleaseVideoParam
    转换HKReleaseVideoParam以保存数据库
 */
@interface HKReleaseVideoSaveDraftAdapter : NSObject


/**
 把HKReleaseVideoParam转换为HKReleaseVideoSaveDraft

 @return HKReleaseVideoSaveDraft
 */
+ (HKReleaseVideoSaveDraft *)convertParam2SaveDraft;


/**
  把HKReleaseVideoSaveDraft转换为HKReleaseVideoParam

 @param draft HKReleaseVideoSaveDraft
 */
+ (void)convertDraft2Param:(HKReleaseVideoSaveDraft *)draft;

@end
