//
//  HKReleaseVideoSaveDraft.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseVideoSaveDraft.h"

@implementation HKReleaseVideoSaveDraft

////初始化 DB
//+(LKDBHelper *)getUsingLKDBHelper
//{
//    static LKDBHelper* db;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        db = [[LKDBHelper alloc]init];
//    });
//    return db;
//}

//表名
+(NSString *)getTableName
{
    return @"SaveDraft";
}


@end
