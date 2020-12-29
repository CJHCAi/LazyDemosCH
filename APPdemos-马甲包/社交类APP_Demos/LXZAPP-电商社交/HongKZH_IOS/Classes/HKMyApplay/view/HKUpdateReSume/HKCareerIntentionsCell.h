//
//  HKCareerIntentionsCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUpdateResumeBaseCell.h"
#import "HK_BaseInfoResponse.h"
/*
    职业意向
 */
@interface HKCareerIntentionsCell : HKUpdateResumeBaseCell

@property (nonatomic, strong)HK_UserRecruitData *infoData;

+ (instancetype) careerIntentionsCellWithBlock:(UpdateResumeBlock)block infoData:(HK_UserRecruitData *) infoData;

@end
