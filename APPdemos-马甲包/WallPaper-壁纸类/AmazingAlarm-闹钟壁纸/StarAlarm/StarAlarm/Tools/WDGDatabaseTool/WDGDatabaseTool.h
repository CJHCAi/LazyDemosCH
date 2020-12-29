//
//  WDGDatabaseTool.h
//  WDGSqliteTool
//
//  Created by Wdgfnhui on 16/2/26.
//  Copyright © 2016年 Wdgfnhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGTypeDefine.h"
#import "WDGWhereCondition.h"


/*********************以下是配置区*********************/

#define DB_NAME @"Alarm"//数据库名，务必要设置，只写库名，不加后缀；
#define DB_PREFIX @""//表前缀，可选；

/*********************配置区结束*********************/




@interface WDGDatabaseTool : NSObject




//直接用SQL语句创建Table，不需要打开关闭数据库
+ (void)creatTableWithSQL:(NSString *)sql;


//获取一个表的单例，可以同时获取多个表，同时操作多个表
+ (instancetype)DBManageWithTableName:(NSString *)tableName;


//打开数据库
- (BOOL)openDatabase;


//关闭数据库
- (BOOL)closeDatabase;


//用字典的方式插入一行数据
- (BOOL)insertDataWithDictionary:(NSDictionary *)dic;


//按条件查找，返回一个数组，数组里存N个字典，每个字典存一行数据，给定空条件查询全部，（WDGWhereCondition 用法见（WDGWhereCondition.h））
- (NSArray *)selectDataWithWhereCondition:(WDGWhereCondition *)condition;


//按条件删除一行或多行数据
- (BOOL)deleteDataWithWhereCondition:(WDGWhereCondition *)condition;


//按条件更新一行或多行数据
- (BOOL)updateDataWithNewData:(NSDictionary *)dataDic WhereCondition:(WDGWhereCondition *)condition;


//获取全部数据
- (NSArray *)selectAllData;

- (NSArray *)selectWithFields:(NSArray *)fields Condition:(WDGWhereCondition *)condition;


- (instancetype)orderWithDictionary:(NSDictionary *)dic;

- (instancetype)limitForRows:(NSInteger)num;

- (instancetype)limitAtIndex:(NSInteger)index Rows:(NSInteger)row;

- (NSInteger)getRowCount;
/**
 *  打开调试模式，打开后可以输出SQL语句
 *
 *  @param isOutPutMode true 为打开，fasle则关闭
 */
+ (void)openDebugMode:(BOOL)isOutPutMode;
@end
