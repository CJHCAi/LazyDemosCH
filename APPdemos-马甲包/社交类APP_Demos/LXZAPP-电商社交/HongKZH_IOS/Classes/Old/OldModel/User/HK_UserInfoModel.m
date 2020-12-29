//
//  HK_UserInfoModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_UserInfoModel.h"

@implementation HK_UserInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _islogin = NO;
    }
    return self;
}
//主键
+(NSString *)getPrimaryKey
{
    return @"useruid";
}
///复合主键  这个优先级最高
//+(NSArray *)getPrimaryKeyUnionArray
//{
//    return @[@"name",@"mobileNum"];
//}
//表名
+(NSString *)getTableName
{
    return @"HK_UserInfoModel";
}

+(LKDBHelper *)getUsingLKDBHelper
{
//    return [XY_CommodityModel getUsingLKDBHelper];
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"asd/asd.db"];
        //        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
        //or
        db = [[LKDBHelper alloc]init];
    });
    return db;
}
@end
