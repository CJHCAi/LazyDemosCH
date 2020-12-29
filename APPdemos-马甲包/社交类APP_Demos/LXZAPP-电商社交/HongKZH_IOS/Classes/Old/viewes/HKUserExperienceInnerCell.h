//
//  HKUserExperienceInnerCell.h
//  HongKZH_IOS
//
//  Created by zhj on 2018/7/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_UserExperienceData.h"

typedef void(^UpdateResumeBlock)(void);

@interface HKUserExperienceInnerCell : UITableViewCell

@property (nonatomic, strong) HK_UserExperienceData *data;

@property (nonatomic, copy) UpdateResumeBlock updateResumeBlock;

+ (instancetype)userEducationalInnerCellWithBlock:(UpdateResumeBlock)block data:(HK_UserExperienceData *)data;

@end
