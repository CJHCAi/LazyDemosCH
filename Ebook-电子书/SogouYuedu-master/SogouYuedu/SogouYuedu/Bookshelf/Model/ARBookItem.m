//
//  ARBookItem.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARBookItem.h"
#import "ARSqliteTool.h"

@implementation ARBookItem

+ (instancetype) BookItemWithName:(NSString *)name
                         imageKey:(NSString *)imageKey
                           bookid:(NSString *)bookid
                               md:(NSString *)md
                            count:(NSString *)count
                           author:(NSString *)author
                              loc:(NSString *)loc
                              eid:(NSString *)eid
                             bkey:(NSString *)bkey
                            token:(NSString *)token
{
    ARBookItem *bookItem = [[ARBookItem alloc]init];
    bookItem.name = name;
    bookItem.imageKey = imageKey;
    bookItem.bookid = bookid;
    bookItem.md = md;
    bookItem.count = count;
    bookItem.author = author;
    bookItem.loc = loc;
    bookItem.eid = eid;
    bookItem.bkey = bkey;
    bookItem.token = token;
    
    return bookItem;
    
}

+(NSMutableArray *)readDatabase{
    NSMutableArray *booksArray = [NSMutableArray array];
    NSString *sql = @"select * from t_bookshelf;";
    //读取数据存到数组里
    booksArray = [ARSqliteTool selectWithSql:sql];
    
    
    return booksArray;
}

@end
