//
//  ExpertRecommendModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/9.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertRecommendModel : NSObject
/** ID*/
@property (nonatomic, assign) NSInteger ExId;
/** 会员ID */
@property (nonatomic, assign) NSInteger ExMeid;
/** 姓名*/
@property (nonatomic, strong) NSString *ExName;
/** 称谓*/
@property (nonatomic, strong) NSString *ExCw;
/** 看病时间*/
@property (nonatomic, strong) NSString *ExDoctortime;
/** 添加日期*/
@property (nonatomic, strong) NSString *ExCreatetime;
/** 疾病或事件*/
@property (nonatomic, strong) NSString *ExDisease;
/** 说明*/
@property (nonatomic, strong) NSString *ExMemo;
@end
