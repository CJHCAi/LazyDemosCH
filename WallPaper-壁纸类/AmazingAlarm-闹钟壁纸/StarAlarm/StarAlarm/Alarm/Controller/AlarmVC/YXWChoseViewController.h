//
//  YXWChoseViewController.h
//  StarAlarm
//
//  Created by dllo on 16/4/6.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseViewController.h"
#import "YXWAlarmModel.h"
@interface YXWChoseViewController : YXWBaseViewController


@property (nonatomic, copy) void(^block)(YXWAlarmModel *alertModel);

@end
