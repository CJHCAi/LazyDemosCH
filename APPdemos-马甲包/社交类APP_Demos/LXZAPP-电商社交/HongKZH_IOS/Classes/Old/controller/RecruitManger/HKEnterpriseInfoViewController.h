//
//  HKEnterpriseInfoViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFormSubmitViewController.h"
#import "HK_RecruitEnterpriseInfoData.h"
/*
    发布视频--->公司信息
 */
@interface HKEnterpriseInfoViewController : HKFormSubmitViewController
@property (nonatomic, weak) HK_RecruitEnterpriseInfoData *enterpriseInfoData;
@property (nonatomic, strong) NSString *enterpriseId;
@end
