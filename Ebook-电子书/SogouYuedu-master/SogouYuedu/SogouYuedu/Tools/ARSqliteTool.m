//
//  ARSqliteTool.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARSqliteTool.h"
#import <sqlite3.h>
#import "ARChaptersItem.h"
#import "ARBookItem.h"

@implementation ARSqliteTool

static sqlite3 *_db;

// 初始化数据库
+ (void)initialize
{
    // 之前是都是保存到docment，最近保存到docment，苹果不允许上传。
    // 游戏一般都是document
    // 获取cache文件夹路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"fangsougou.sqlite"];
    
    
    // 打开数据库，就会创建数据库文件
    // fileName保存数据库的全路径文件名
    // ppDb:数据库实例
    
    
    // 打开数据库
    if (sqlite3_open(filePath.UTF8String, &_db) == SQLITE_OK) {// 打开成功
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
        
    }
}
+ (void)execWithSql:(NSString *)sql
{
    
    char *errmsg;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    
    if (errmsg) {
        NSLog(@"数据库操作失败--%s",errmsg);
    }else{
        NSLog(@"数据库操作成功");
    }
}

+ (NSMutableArray *)selectWithSql:(NSString *)sql
{
    
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        // 准备成功
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int ID = sqlite3_column_int(stmt, 0);
            
            
            // 有数据
            NSString *name = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 1)];
            
            NSString *imageKey = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 2)];
            
            NSString *bookid = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 3)];
            
            NSString *md = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 4)];
            
            NSString *count = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 5)];
            
            NSString *author = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 6)];
            
            NSString *loc = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 7)];
            
            NSString *eid = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 8)];
            
            NSString *bkey = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 9)];
            
            NSString *token = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 10)];
            
            
            ARBookItem *bookItem = [ARBookItem BookItemWithName:name imageKey:imageKey bookid:bookid md:md count:count author:author loc:loc eid:eid bkey:bkey token:token];
            
            
            [arrM addObject:bookItem];
            
        }
        
    }
    
    return arrM;
}

+ (NSMutableArray *)selectChaptersWithSql:(NSString *)sql{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        // 准备成功
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int ID = sqlite3_column_int(stmt, 0);
            
            
            // 有数据
            NSString *free = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 1)];
            
            NSString *gl = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 2)];
            
            NSString *buy = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 3)];
            
            NSString *rmb = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 4)];
            
            NSString *name = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 5)];
            
            NSString *md5 = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 6)];
            
            NSString *url = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 7)];
            
            NSString *cmd = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 8)];
            
            ARChaptersItem *chaptersItem = [ARChaptersItem ChaptersWithFree:free gl:gl buy:buy rmb:rmb name:name md5:md5 url:url cmd:cmd];
            
            
            
            [arrM addObject:chaptersItem];
            
        }
        
    }
    
    return arrM;
    
}

@end
