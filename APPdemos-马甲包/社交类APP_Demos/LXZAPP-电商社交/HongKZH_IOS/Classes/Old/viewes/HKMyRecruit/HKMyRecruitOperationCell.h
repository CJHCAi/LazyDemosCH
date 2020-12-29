//
//  HKMyRecruitOperationCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyRecruit.h"
typedef void(^RecruitOperationBlock)(NSInteger index);
@interface HKMyRecruitOperationCell : UITableViewCell
@property (nonatomic, strong) HKMyRecruitData *data;
@property (nonatomic, copy) RecruitOperationBlock block;
@end
