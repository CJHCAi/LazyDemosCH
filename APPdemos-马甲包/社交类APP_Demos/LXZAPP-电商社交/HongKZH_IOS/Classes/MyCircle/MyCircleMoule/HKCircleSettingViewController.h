//
//  HKCircleSettingViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKMyCircleData.h"
@interface HKCircleSettingViewController : HKBaseViewController
@property (nonatomic, strong)HKMyCircleData *dataModel;
@property (nonatomic, copy)NSString *circleId;
@end
