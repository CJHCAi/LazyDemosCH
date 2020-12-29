//
//  HKUpdateResumeBasicInfoCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_BaseInfoResponse.h"

typedef void(^UpdateResumeBlock)(void);

@interface HKUpdateResumeBasicInfoCell : UITableViewCell

@property (nonatomic, strong) HK_UserRecruitData *infoData;

@property (nonatomic, copy) UpdateResumeBlock updateResumeBlock;

@end
