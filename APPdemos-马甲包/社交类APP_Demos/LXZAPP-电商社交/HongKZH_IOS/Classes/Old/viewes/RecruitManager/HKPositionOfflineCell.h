//
//  HKPositionOfflineCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKRecruitOffLineList.h"
typedef void(^HKPositionOfflineCellBlock)(NSInteger index);
@interface HKPositionOfflineCell : UITableViewCell
@property (nonatomic, strong) HKRecruitOffLineData *data;
@property (nonatomic, copy) HKPositionOfflineCellBlock block;
@end
