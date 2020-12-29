//
//  HKUserEducationalInnerCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_UserEducationalData.h"

typedef void(^UpdateResumeBlock)(void);

@interface HKUserEducationalInnerCell : UITableViewCell

@property (nonatomic, strong) HK_UserEducationalData *data;

@property (nonatomic, copy) UpdateResumeBlock updateResumeBlock;

+ (instancetype)userEducationalInnerCellWithBlock:(UpdateResumeBlock)block data:(HK_UserEducationalData *)data;

@end
