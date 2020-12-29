//
//  HK_RecruitPosition.h
//  HongKZH_IOS
//
//  Created by zhj on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_RecruitPosition : BaseModel
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) BaseModel *data;

@property (nonatomic, assign) NSInteger code;
@end
