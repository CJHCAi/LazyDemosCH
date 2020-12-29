//
//  HKMyDeliveryCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyDelivery.h"
@interface HKMyDeliveryCell : UITableViewCell

@property (nonatomic, strong) HKMyDeliveryLogs *data;
@property (nonatomic, weak) UIView *timeLineFlag;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UILabel *createDateLabel;
@property (nonatomic, weak) UIView *timeline;
@end
