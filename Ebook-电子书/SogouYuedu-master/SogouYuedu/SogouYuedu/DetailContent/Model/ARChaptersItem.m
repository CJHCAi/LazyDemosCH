//
//  ARChaptersItem.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARChaptersItem.h"
#import "ARSqliteTool.h"

@implementation ARChaptersItem

+ (instancetype) ChaptersWithFree:(NSString *)free
                               gl:(NSString *)gl
                              buy:(NSString *)buy
                              rmb:(NSString *)rmb
                             name:(NSString *)name
                              md5:(NSString *)md5
                              url:(NSString *)url
                              cmd:(NSString *)cmd

{
    
    ARChaptersItem *chaptersItem = [[ARChaptersItem alloc]init];
    chaptersItem.free = free;
    chaptersItem.gl = gl;
    chaptersItem.buy = buy;
    chaptersItem.rmb = rmb;
    chaptersItem.name = name;
    chaptersItem.md5 = md5;
    chaptersItem.url = url;
    chaptersItem.cmd = cmd;
    
    return chaptersItem;
    
}

+ (NSMutableArray *)readDatabaseFromTable:(NSString *)table{
    NSMutableArray *chaptersArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@;",table];
    
    chaptersArray = [ARSqliteTool selectChaptersWithSql:sql];
    
    return chaptersArray;
}
//只读取一章，解决开销
+ (NSMutableArray *)readOneChapterFromTable:(NSString *)table Index:(NSInteger )index{
    NSMutableArray *chaptersArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where id=%d;",table,index];
    
    chaptersArray = [ARSqliteTool selectChaptersWithSql:sql];
    
    return chaptersArray;
}
@end
