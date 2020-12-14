//
//  DPSqliteUtil.h
//  Buyer
//
//  Created by ZhangJunjie on 14-6-19.
//  Copyright (c) 2014年 DongPi. All rights reserved.
//

#import <Foundation/Foundation.h>
//宏定义单例模式
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
static className *shared##className = nil; \
+ (className *)shared##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

//定义XMPP宏定义单利
// .h
#define singleton_interface(class) + (instancetype)shared##class;


#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)


// .m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}


@interface SqliteUtil : NSObject

//单例
DEFINE_SINGLETON_FOR_HEADER(SqliteUtil);

/**
 *  获取数据路路径
 *
 *  @return 数据路路径
 */
- (NSString *)databaseFilePath;

/**
 *  建表
 *
 *  @param sql 建表sql语句
 */
- (void)creatTable:(NSString *)sql;

/**
 *  插入或更新数据库
 *
 *  @param sql sql语句
 */
- (void)insertOrUpdateData:(NSString *)sql;

/**
 *  查询数据路
 *
 *  @param sql sql语句
 *
 *  @return 查询到的数据
 */
- (NSMutableArray *)queryData:(NSString *)sql;


//查询到的老师答案。下次删掉。
- (NSMutableArray *)teacherAnwser:(NSString *)sql;

/**
 *  删除数据库数据
 *
 *  @param sql sql语句
 */
- (void)deleteData:(NSString *)sql;

@end
