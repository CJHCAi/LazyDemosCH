//
//  HK_RecruitEnterpriseInfo.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"
#import "HK_RecruitEnterpriseInfoData.h"

@interface HK_RecruitEnterpriseInfo : BaseModel
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_RecruitEnterpriseInfoData *data;

@property (nonatomic, assign) NSInteger code;
@end
