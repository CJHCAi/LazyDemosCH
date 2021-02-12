//
//  LJXFMDBManager.h
//  DataBaseText
//
//  Created by 劳景醒 on 16/12/5.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface LJXFMDBManager : NSObject
+ (LJXFMDBManager *)ShareFMDBManager;

@property (nonatomic, strong) FMDatabase *dataBase;
/**
 创建数据库

 @param pathString 数据库路径
 */
- (BOOL)createDataBaseWithPath:(NSString *)pathString;

/**
 创建表

 @param tableName 表名
 @param primaryKey 设置主键以便操作
 @return 创建表是否成功
 */
- (BOOL)createTableWithName:(NSString *)tableName model:(Class)model primaryKey:(NSString *)primaryKey;



/**
 插入 模型 单个
 
 @param model 要插入的模型
 @param tableName 表名
 @return 插入是否成功
 */
- (BOOL)insterModel:(id)model toTable:(NSString *)tableName;

/**
  插入 模型 数组

 @param modelArray 模型数组
 @param tableName 表名
 @return 插入是否成功
 */
- (BOOL)insterModelArray:(NSArray *)modelArray toTable:(NSString *)tableName;


/**
 查询某条数据所在的model。比如学号(key)为2001(vlaue)的model
 
 @param model 所查model类型
 @param keyString 所查的键
 @param valueString 所查的值
 @param tableName 所查的表
 @return 返回的model数组
 */
- (NSArray *)searchModel:(Class)model WithKey:(NSString *)keyString value:(NSString *)valueString inTable:(NSString *)tableName;

/**
 查询所有的model

 @param modelClass 所查的model类型
 @param tableName 表名
 @return 所有的model
 */
- (NSArray *)searchAllModel:(Class)modelClass tableName:(NSString *)tableName;


#pragma mark - 删除

/**
 删除表中所有的数据, 不删除表, 但不删除列名

 @param tableName 表名
 @return 是否删除成功
 */
- (BOOL)truncateTable:(NSString *)tableName;

/**
 删除整个表

 @param tableName 表名
 @return 是否删除成功
 */
- (BOOL)dropTable:(NSString *)tableName;


/**
 删除指定条件的model
 如：删除学号 为 2002的model
 @param columnName 指定列名
 @param columnValue 指定列值
 @param tableName 表名
 @return 删除成功与否
 */
- (BOOL)deleteModelColumnName:(NSString *)columnName columnValue:(NSString *)columnValue tableName:(NSString *)tableName;

@end
