//
//  HK_UserExperienceData.h
//  HongKZH_IOS
//
//  Created by zhj on 2018/7/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseModel.h"

@interface HK_UserExperienceData : HK_BaseModel
@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *corporateName;    //公司名称

@property (nonatomic, copy) NSString *outDate;      //离职时间

@property (nonatomic, copy) NSString *experienceId;

@property (nonatomic, copy) NSString *job;  //职位

@property (nonatomic, copy) NSString *entryDate;    //入职时间

@property (nonatomic, copy) NSString *workContent;  //工作内容

@property (nonatomic, assign) NSInteger lineStyle; //1--首个 2--中间 3--最后一个
@end
