//
//  HK_UserEducationalData.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseModel.h"

@interface HK_UserEducationalData : HK_BaseModel

@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *major;

@property (nonatomic, copy) NSString *educatioId;

@property (nonatomic, copy) NSString *graduate;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *graduationTime;

@property (nonatomic, assign) NSInteger lineStyle; //1--首个 2--中间 3--最后一个

@end
