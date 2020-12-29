//
//  HKPublishNewPositionViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFormSubmitViewController.h"
#import "HK_RecruitPositionData.h"
@interface HKPublishNewPositionViewController : HKFormSubmitViewController
@property (nonatomic, strong) NSString *enterpriseId;
@property (nonatomic, strong) HK_RecruitPositionData *postionData;
@end
