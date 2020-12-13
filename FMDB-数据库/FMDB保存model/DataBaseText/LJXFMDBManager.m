
//  LJXFMDBManager.m
//  DataBaseText
//
//  Created by 劳景醒 on 16/12/5.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import "LJXFMDBManager.h"
#import <objc/runtime.h>

@implementation LJXFMDBManager

+ (LJXFMDBManager *)ShareFMDBManager
{
    static dispatch_once_t onceToken;
    static LJXFMDBManager *FMDBManager = nil;
    dispatch_once(&onceToken, ^{
        if (FMDBManager == nil) {
            FMDBManager = [[LJXFMDBManager alloc] init];
        }
    });
    
    return FMDBManager;
}


- (BOOL)createDataBaseWithPath:(NSString *)pathString
{
    self.dataBase = [FMDatabase databaseWithPath:pathString];
    if (self.dataBase) {
        return YES;
    } else {
        // 可能是路径错误
        return NO;
    }
}

#pragma mark - -----------外部操作方法----------
// 创表
- (BOOL)createTableWithName:(NSString *)tableName model:(Class)model primaryKey:(NSString *)primaryKey
{
    if (self.dataBase) {
        // 打开数据库
        [self.dataBase open];
        // 判断表是否存在
        BOOL success = [self.dataBase tableExists:tableName];

        if (success) {
            // 存在就不用创建了，操作完成。记得关闭数据库
            [self.dataBase close];
            return YES;
        } else {
            // 不存在的话，
            // 创建SQL语句;
            NSString *SQLString = [self createTableSQLString:model tableName:tableName primaryKey:primaryKey];
            NSLog(@"%@",SQLString);
            if ([self.dataBase executeUpdate:SQLString]) {
                // 创建表成功，关闭
                [self.dataBase close];
                return YES;
            } else {
                return NO;
            }
        }
    } else {
        NSLog(@"数据库不存在");
        return NO;
    }
}

// 查询
- (NSArray *)searchModel:(Class)modelClass WithKey:(NSString *)keyString value:(NSString *)valueString inTable:(NSString *)tableName
{
    NSMutableArray *resultModelArr = [NSMutableArray array];
    if (self.dataBase) {
        // 打开数据库
        [self.dataBase open];
        // 判断表是否存在
        if ([self.dataBase executeQuery:[NSString stringWithFormat:@"select * from %@", tableName]]) {
            // 查询结果
            FMResultSet *FMResult = [self.dataBase executeQuery:[self searchSQLStringWithKey:keyString value:valueString inTable:tableName]];
            //
            id reslutModel = [[modelClass class] new];
            
            // 遍历查询结果
            while ([FMResult next]) {
                unsigned int propertyCount = 0;
                // 获取属性列表
                objc_property_t* propertyList = class_copyPropertyList(modelClass, &propertyCount);
                for (int i = 0; i < propertyCount; i ++) {
                    objc_property_t propertyName = propertyList[i];
                    const char* charProperty = property_getName(propertyName);
                    // oc string  结果中的键
                    NSString *ockeyString = [NSString stringWithUTF8String:charProperty];
                    
                    // 拿到键后，再去拿结果中的值
                    NSString *value = [FMResult objectForColumnName:ockeyString];
                    
                    // 保存键值对
                    [reslutModel setValue:value forKey:ockeyString];
                    
                }
                // 保存到数组中
                [resultModelArr addObject:reslutModel];
            }
        }
        
        [self.dataBase close];
    }
    
    return resultModelArr;
}

- (NSArray *)searchAllModel:(Class)modelClass tableName:(NSString *)tableName
{
    NSMutableArray *resultModelArr = [NSMutableArray array];
    if (self.dataBase) {
        // 打开数据库
        [self.dataBase open];
        // 判断表是否存在
        if ([self.dataBase tableExists:tableName]) {
            // 查询结果
            NSString *selectAllSQLString = [NSString stringWithFormat:@"select * from %@", tableName];
            FMResultSet *FMResult = [self.dataBase executeQuery:selectAllSQLString];
            
            // 遍历查询结果
            while ([FMResult next]) {
                id reslutModel = [[modelClass class] new];

                unsigned int propertyCount = 0;
                // 获取属性列表
                objc_property_t* propertyList = class_copyPropertyList(modelClass, &propertyCount);
                for (int i = 0; i < propertyCount; i ++) {
                    objc_property_t propertyName = propertyList[i];
                    const char* charProperty = property_getName(propertyName);
                    // oc string  结果中的键
                    NSString *ockeyString = [NSString stringWithUTF8String:charProperty];
                    
                    // 拿到键后，再去拿结果中的值
                    NSString *value = [FMResult objectForColumnName:ockeyString];
                    
                    // 保存键值对
                    [reslutModel setValue:value forKey:ockeyString];
                }
                
                // 保存到数组中
                [resultModelArr addObject:reslutModel];
            }
        } else {
            // 表不存在
            NSLog(@"查询失败，表不存在");
        }
        
        [self.dataBase close];
    }
    
    return resultModelArr;

}

// 插入
- (BOOL)insterModel:(id)model toTable:(NSString *)tableName
{
    if (self.dataBase) {
        // 凡事先打开数据库
        [self.dataBase open];
        if ([self.dataBase tableExists:tableName]) {
                if ([self.dataBase executeUpdate:[self insertSQLStringWith:model tableName:tableName]]) {
                    // 插入成功
                    [self.dataBase close];
                    return YES;
                } else {
                    // 插入失败
                    [self.dataBase close];
                    return NO;
                }
        }else {
            // 表不存在
            NSLog(@"插入失败，表不存在");
            [self.dataBase close];
            return NO;
        }
    } else {
        // 数据库都不存在，先去创建数据库吧
        NSLog(@"数据库不存在");
        return NO;
    }
}

// 插入一组
- (BOOL)insterModelArray:(NSArray *)modelArray toTable:(NSString *)tableName
{
    if (self.dataBase) {
        // 凡事先打开数据库
        [self.dataBase open];
        
        if ([self.dataBase tableExists:tableName]) {
            NSString *sqlString = @"";
            for (NSInteger i = 0; i < modelArray.count; i ++) {
                // 拼接sql语句
                NSString *subString = [self insertSQLStringWith:modelArray[i] tableName:tableName];
                if (i == 0) {
                    sqlString = [sqlString stringByAppendingString:subString];
                } else {
                    sqlString = [sqlString stringByAppendingFormat:@"; %@", subString];
                }
            }
            
            // 多行执行
            BOOL success = [self.dataBase executeStatements:sqlString];
            [self.dataBase close];
            return success;
        }else {
            // 表不存在
            NSLog(@"插入失败，表不存在");
            [self.dataBase close];
            return NO;
        }
    } else {
        // 数据库都不存在，先去创建数据库吧
        NSLog(@"数据库不存在");
        return NO;
    }
}

// 删除表.
- (BOOL)dropTable:(NSString *)tableName
{
    if (self.dataBase) {
        [self.dataBase open];
        if ([self.dataBase tableExists:tableName]) {
            NSString *deleteSQLString = [NSString stringWithFormat:@"drop table %@", tableName];
            BOOL success = [self.dataBase executeUpdate:deleteSQLString];
            [self.dataBase close];
            return success;
        } else {
            NSLog(@"删除失败，表不存在");
            [self.dataBase close];
            return NO;
        }
    } else {
        NSLog(@"数据库不存在");
        return NO;
    }
}

// 删除表中所有所有的数据，但不删除表
- (BOOL)truncateTable:(NSString *)tableName
{
    if (self.dataBase) {
        [self.dataBase open];
        if ([self.dataBase tableExists:tableName]) {
            NSString *deleteSQLString = [NSString stringWithFormat:@"delete from %@", tableName];
            BOOL success = [self.dataBase executeUpdate:deleteSQLString];
            [self.dataBase close];
            return success;
        } else {
            NSLog(@"删除失败，表不存在");
            [self.dataBase close];
            return NO;
        }
    } else {
        NSLog(@"数据库不存在");
        return NO;
    }
}

// 删除某个model
- (BOOL)deleteModelColumnName:(NSString *)columnName columnValue:(NSString *)columnValue tableName:(NSString *)tableName
{
    if (self.dataBase) {
        [self.dataBase open];
        if ([self.dataBase tableExists:tableName]) {
            NSString *deleteSQLString = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, columnName, columnValue];
            BOOL success = [self.dataBase executeUpdate:deleteSQLString];
            [self.dataBase close];
            return success;
        } else {
            NSLog(@"删除失败，表不存在");
            [self.dataBase close];
            return NO;
        }
    } else {
        NSLog(@"数据库不存在");
        return NO;
    }
}
#pragma mark - 组合SQL语句
// 创表语句
- (NSString *)createTableSQLString:(id)model tableName:(NSString *)tableName primaryKey:(NSString *)primaryKey
{
    // 为了提交表数据的容错性，都用text 类型
    NSString *sqliteString = [NSString stringWithFormat:@"create table if not exists %@ (%@ text primary key", tableName, primaryKey];
    
    // model的属性作为表的列名
    // 可以通过RunTime的方法来获取model的属性
    
    // model属性的个数
    unsigned int propertyCount = 0;
    
    // 通过运行时获取model的属性 这里要导入 #import <objc/runtime.h>
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i ++) {
        // 取出元素
        objc_property_t property = propertys[i];
        // 得到的是char*型的
        const char *propertyName = property_getName(property);
        // 转化
        NSString *OCString = [NSString stringWithUTF8String:propertyName];
//        NSLog(@"%@", OCString);
        // 如果是主键的话，就不用拼接上去了，因为一开始就拼了
        if (![OCString isEqualToString:primaryKey]) {
            // 拼接
            if (i == 0) {
                sqliteString = [sqliteString stringByAppendingString:[NSString stringWithFormat:@", %@ text", OCString]];
            } else {
                sqliteString = [sqliteString stringByAppendingString:[NSString stringWithFormat:@", %@ text", OCString]];
            }
        }
        
    }
    sqliteString = [sqliteString stringByAppendingString:@")"];
    
    return sqliteString;
}

// 插入数据语句
- (NSString *)insertSQLStringWith:(id)model tableName:(NSString *)tableName
{
    NSString *sqliteString = [NSString stringWithFormat:@"insert or replace into %@ (", tableName];
    // 一般是以model的属性作为表的列名
    // 可以通过RunTime的方法来获取model的属性
    
    // model属性的个数
    unsigned int propertyCount = 0;
    
    // 通过运行时获取model的属性 这里要导入 #import <objc/runtime.h>
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    // 装属性的数组
    NSMutableArray *keyArray = [NSMutableArray array];
    for (int i = 0; i < propertyCount; i ++) {
        // 取出元素
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        // 转化
        NSString *OCString = [NSString stringWithUTF8String:propertyName];
        
        NSString *valueString = [NSString stringWithFormat:@"%@",[model valueForKey:OCString]];
        if (valueString.length > 0) {
            // 如果model的属性没有值的话，那就不加操作那列值了
            // 保存键
            [keyArray addObject:OCString];
            // 拼接
            if (i == 0) {
                sqliteString = [sqliteString stringByAppendingString:[NSString stringWithFormat:@"'%@'",OCString]];
            } else {
                sqliteString = [sqliteString stringByAppendingString:[NSString stringWithFormat:@", '%@'", OCString]];
            }
        }
    }
    sqliteString = [sqliteString stringByAppendingString:@") values ("];
    
    // 值
    for (int i = 0; i < keyArray.count; i ++) {
        NSString *key = keyArray[i];
        NSString *keyString;
        // 拼接 记得加单引号
        if (i == 0) {
            keyString = [NSString stringWithFormat:@"'%@'", [model valueForKey:key]];
        } else {
              keyString = [NSString stringWithFormat:@", '%@'", [model valueForKey:key]];
        }
       
        sqliteString = [sqliteString stringByAppendingString:keyString];
    }
    //
    sqliteString = [sqliteString stringByAppendingString:@")"];
    return sqliteString;
}

// 更新语句
- (NSString *)updateSQLString:(id)model inTable:(NSString *)tableName
{
    NSString *updateSQLString = [NSString stringWithFormat:@"update %@ set ", tableName];
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    // 遍历
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t properName = propertys[i];
        const char *charProperty = property_getName(properName);
        
        // key
        NSString *OCString = [NSString stringWithUTF8String:charProperty];
        // value
        NSString *value = [model valueForKey:OCString];
        // 如果没有值的话，就不去操作它
        if (value.length > 0) {
            if (i == 0) {
                updateSQLString = [updateSQLString stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'", OCString, value]];
            } else {
                updateSQLString = [updateSQLString stringByAppendingString:[NSString stringWithFormat:@", %@ = '%@'", OCString, value]];
            }
        }
    }
    
    return updateSQLString;
}

// 查询语句
- (NSString *)searchSQLStringWithKey:(NSString *)keyString value:(NSString *)valueString inTable:(NSString *)tableName
{
//    NSString *updateSQLString = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, keyString, valueString];
    NSString *updateSQLString = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, keyString, valueString];
    
    return updateSQLString;
}

#pragma mark - ----------内部使用，不用关闭数据库-----------

/**
 用model去更新表里面这条数据

 @param model model description
 @param tableName tableName description
 @return return value description
 */
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName
{
    if ([self.dataBase tableExists:tableName]) {
        // 拿到更新语句
        NSString *updateString = [self updateSQLString:model inTable:tableName];
        // 去更新
        if ([self.dataBase executeUpdate:updateString]) {
            // 更新成功
            return YES;
        } else {
            return NO;
        }
    } else {
        // 表不存在，也创建不了
        return NO;
    }
}


// 内部查询
- (NSArray *)inner_searchModel:(Class)modelClass WithKey:(NSString *)keyString value:(NSString *)valueString inTable:(NSString *)tableName
{
    NSMutableArray *resultModelArr = [NSMutableArray array];
        // 打开数据库
        // 判断表是否存在
        if ([self.dataBase tableExists:tableName]) {
            // 查询结果
            FMResultSet *FMResult = [self.dataBase executeQuery:[self searchSQLStringWithKey:keyString value:valueString inTable:tableName]];
            
            // 遍历查询结果
            while ([FMResult next]) {
                //
                id reslutModel = [[modelClass class] new];

                unsigned int propertyCount = 0;
                // 获取属性列表
                objc_property_t* propertyList = class_copyPropertyList(modelClass, &propertyCount);
                for (int i = 0; i < propertyCount; i ++) {
                    objc_property_t propertyName = propertyList[i];
                    const char* charProperty = property_getName(propertyName);
                    // oc string  结果中的键
                    NSString *ockeyString = [NSString stringWithUTF8String:charProperty];
                    
                    // 拿到键后，再去拿结果中的值
                    NSString *value = [FMResult objectForColumnName:ockeyString];
                    
                    // 保存键值对
                    [reslutModel setValue:value forKey:ockeyString];
                }
                
                // 保存到数组中
                [resultModelArr addObject:reslutModel];

            }
        
        }
    return resultModelArr;
}
@end
