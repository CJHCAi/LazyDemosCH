//
//  HK_BaseModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseModel.h"

@implementation HK_BaseModel
-(BaseModel *)rootAllCategorys
{
    if (!_rootAllCategorys) {
        _rootAllCategorys = [[BaseModel alloc] init];
    }
    return _rootAllCategorys;
}
-(BaseModel *)rootAllMediaCategorys
{
    if (!_rootAllMediaCategorys) {
        _rootAllMediaCategorys = [[BaseModel alloc] init];
    }
    return _rootAllMediaCategorys;
}
-(BaseModel *)rootRecruitCategorys
{
    if (!_rootRecruitCategorys) {
        _rootRecruitCategorys = [[BaseModel alloc] init];
    }
    return _rootRecruitCategorys;
}
-(BaseModel *)rootDict
{
    if (!_rootDict) {
        _rootDict = [[BaseModel alloc] init];
    }
    return _rootDict;
}
-(BaseModel *)rootRecruitIndustrys
{
    if (!_rootRecruitIndustrys) {
        _rootRecruitIndustrys = [[BaseModel alloc] init];
    }
    return _rootRecruitIndustrys;
}
@end
