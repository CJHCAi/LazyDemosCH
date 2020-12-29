//
//  HKReleaseViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class RecruitInfoRespone,EnterpriseRecruitListRespone;
@interface HKReleaseViewModel : HKBaseViewModel
+(void)getRecruitInfo:(NSDictionary*)parameter success:(void (^)( RecruitInfoRespone* responde))success;
+(void)getEnterpriseRecruitListById:(NSDictionary*)parameter success:(void (^)( EnterpriseRecruitListRespone* responde))success;
@end
