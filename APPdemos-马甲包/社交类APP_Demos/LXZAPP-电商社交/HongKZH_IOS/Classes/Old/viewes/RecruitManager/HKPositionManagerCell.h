//
//  HKPositionManagerCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKRecruitOnlineList.h"
typedef void(^HKPositionManagerCellBlock)(NSInteger index);
@interface HKPositionManagerCell : UITableViewCell
@property (nonatomic, strong) HKRecruitOnlineData *data;
@property (nonatomic, copy) HKPositionManagerCellBlock block;
@end
