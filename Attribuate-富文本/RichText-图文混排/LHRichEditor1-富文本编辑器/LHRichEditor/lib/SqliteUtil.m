//
//  DPSqliteUtil.m
//  Buyer
//
//  Created by ZhangJunjie on 14-6-19.
//  Copyright (c) 2014年 DongPi. All rights reserved.
//

#import "SqliteUtil.h"
#import "FMDatabase.h"

@implementation SqliteUtil
{
    FMDatabase *_db;
}

DEFINE_SINGLETON_FOR_CLASS(SqliteUtil)

- (id)init
{
    if (self = [super init]) {
        NSString *filePath = [self databaseFilePath];
        //创建数据库的操作
        _db = [FMDatabase databaseWithPath:filePath];
    }
    return self;
}

- (NSString *)databaseFilePath
{
  
    NSString *dbName = @"name.sqlite";
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    NSString *documentPath = [filePath objectAtIndex:0];
   // DDLogInfo(@"数据库路径：%@",filePath);
      DLog(@"数据库路径：%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:dbName];
    return dbFilePath;
}

- (void)creatTable:(NSString *)sql
{
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![_db open]) {
    
        DLog(@"数据库打开失败");
        return;
    }
    
    //为数据库设置缓存，提高查询效率
    [_db setShouldCacheStatements:YES];
    
    BOOL res = [_db executeUpdate:sql];
    if (!res) {
      //  DDLogWarn(@"error when creating db table");
        DLog(@"建表失败");
    }
    else {
       // DDLogWarn(@"succ to creating db table");
        DLog(@"建表成功");
    }
    [_db close];
}

- (void)insertOrUpdateData:(NSString *)sql
{
    if (![_db open]) {
      //  DDLogWarn(@"数据库打开失败");
        return;
    }
    
    [_db setShouldCacheStatements:YES];
    BOOL res = [_db executeUpdate:sql];
    if (!res) {
     
           DLog(@"插入失败");
    }
    else {
      
            DLog(@"进去了");
    }
    [_db close];
}

- (NSMutableArray *)queryData:(NSString *)sql
{
    if (![_db open]) {
      //  DDLogWarn(@"数据库打开失败");
        return nil;
    }
    
    [_db setShouldCacheStatements:YES];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet * rs = [_db executeQuery:sql];
    while ([rs next]) {
        NSDictionary *result = rs.resultDictionary;

        NSString *context = result[@"contexText"];
       // [context dataUsingEncoding:(NSStringEncoding)]
       NSData *data = [context dataUsingEncoding:NSUTF32BigEndianStringEncoding];
//
        NSArray *arr = [self toArrayOrNSDictionary:data];

        
//        //将context转成
        for (NSDictionary *dic in arr) {

            [array addObject:dic];

        }
//
    }
    [_db close];
    return array;
}


- (NSMutableArray *)teacherAnwser:(NSString *)sql
{
    if (![_db open]) {
        //  DDLogWarn(@"数据库打开失败");
        return nil;
    }
    
    [_db setShouldCacheStatements:YES];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet * rs = [_db executeQuery:sql];
    while ([rs next]) {
        NSDictionary *result = rs.resultDictionary;
        
        NSString *context = result[@"contexText"];
        // [context dataUsingEncoding:(NSStringEncoding)]
        NSData *data = [context dataUsingEncoding:NSUTF32BigEndianStringEncoding];
        
        NSArray *arr = [self toArrayOrNSDictionary:data];

        
         [array addObject:arr];
    }
    [_db close];
    return array;
}


- (void)deleteData:(NSString *)sql
{
    if (![_db open]) {
      //  DDLogWarn(@"数据库打开失败");
        return;
    }
    
    BOOL res = [_db executeUpdate:sql];
    if (!res) {
        //DDLogWarn(@"error to delete db data");
    }
    else {
        //DDLogWarn(@"succ to deleta db data");
    }
    [_db close];
}

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
@end
