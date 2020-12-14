//
//  YTChaptersItem.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/12.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTChaptersItem.h"
#import "YTSqliteTool.h"
@implementation YTChaptersItem

//@property(nonatomic,copy)NSString *free;
//
//@property(nonatomic,copy)NSString *gl;
//
//@property(nonatomic,copy)NSString *buy;
//
//@property(nonatomic,copy)NSString *rmb;
//
//@property(nonatomic,copy)NSString *name;
//
//@property(nonatomic,copy)NSString *md5;
//
//
////nobkey 有三个属性，分别是name ,cmd ,url
//@property(nonatomic,copy)NSString *url;
//
//@property(nonatomic,copy)NSString *cmd;
+ (instancetype) ChaptersWithFree:(NSString *)free
                         gl:(NSString *)gl
                           buy:(NSString *)buy
                               rmb:(NSString *)rmb
                            name:(NSString *)name
                           md5:(NSString *)md5
                              url:(NSString *)url
                              cmd:(NSString *)cmd

{

    YTChaptersItem *chaptersItem = [[YTChaptersItem alloc]init];
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
    
    chaptersArray = [YTSqliteTool selectChaptersWithSql:sql];

    return chaptersArray;
}
//只读取一章，解决开销
+ (NSMutableArray *)readOneChapterFromTable:(NSString *)table Index:(NSInteger )index{
    NSMutableArray *chaptersArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where id=%d;",table,index];
    
    chaptersArray = [YTSqliteTool selectChaptersWithSql:sql];
    
    return chaptersArray;
}
@end
