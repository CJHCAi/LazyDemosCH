//
//  HK_BaseModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_BaseModel : BaseModel
@property (nonatomic, strong) BaseModel *rootAllCategorys;

@property (nonatomic, strong) BaseModel *rootAllMediaCategorys;

@property (nonatomic, strong) BaseModel *rootRecruitCategorys;

@property (nonatomic, strong) BaseModel *rootDict;

@property (nonatomic, strong) BaseModel *rootRecruitIndustrys;
@end
