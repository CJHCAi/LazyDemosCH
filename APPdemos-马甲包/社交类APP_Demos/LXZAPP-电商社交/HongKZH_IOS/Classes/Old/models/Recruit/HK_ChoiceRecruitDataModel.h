//
//  HK_ChoiceRecruitDataModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_ChoiceRecruitDataModel : BaseModel
@property (nonatomic, copy) NSString *userEnterpriseId;     //企业id

@property (nonatomic, copy) NSString *isAuth;           //企业认证 2默认1是0否

@property (nonatomic, copy) NSString *userResumeId;     //个人简历id

@property (nonatomic, copy) NSString *coverImgSrc;      //

@property (nonatomic, copy) NSString *isEnterpriserecRuited;    //isEnterpriserecRuited 0 默认 1个人2企业

@property (nonatomic, copy) NSString *isEnterprise;         //企业发布 1是0否

@property (nonatomic, copy) NSString *isUserResume;         //个人简历 1是0否
@end
