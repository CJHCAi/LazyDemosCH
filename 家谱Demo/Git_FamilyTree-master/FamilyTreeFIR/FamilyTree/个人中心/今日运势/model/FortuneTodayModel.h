//
//  FortuneTodayModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/28.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FortuneTodayJrModel,FortuneTodayBzModel;
@interface FortuneTodayModel : NSObject

@property (nonatomic, strong) FortuneTodayJrModel *jr;

@property (nonatomic, strong) FortuneTodayBzModel *bz;

@end

@interface FortuneTodayJrModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *datetime;

@property (nonatomic, copy) NSString *all;

@property (nonatomic, copy) NSString  *color;

@property (nonatomic, copy) NSString *health;

@property (nonatomic, copy) NSString *love;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) NSString *qfriend;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *work;

@end

@interface FortuneTodayBzModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *health;

@property (nonatomic, copy) NSString *job;

@property (nonatomic, copy) NSString *love;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *work;

@property (nonatomic, assign) NSInteger *resultcode;

@end
