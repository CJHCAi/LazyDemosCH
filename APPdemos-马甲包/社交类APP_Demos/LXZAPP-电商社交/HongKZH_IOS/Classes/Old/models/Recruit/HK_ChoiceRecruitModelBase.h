//
//  HK_ChoiceRecruitModelBase.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"
#import "HK_ChoiceRecruitDataModel.h"

@interface HK_ChoiceRecruitModelBase : BaseModel
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_ChoiceRecruitDataModel *data;

@property (nonatomic, assign) NSInteger code;
@end
