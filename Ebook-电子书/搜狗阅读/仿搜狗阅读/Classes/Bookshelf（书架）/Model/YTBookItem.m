//
//  YTBookItem.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/11.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTBookItem.h"
#import "YTSqliteTool.h"
@implementation YTBookItem

//            @property(nonatomic,copy)NSString *bookid;
//
//            @property(nonatomic,copy)NSString *md;
//
//            @property(nonatomic,copy)NSString *count;
//
//            @property(nonatomic,copy)NSString *author;
//
//            @property(nonatomic,copy)NSString *loc;
//
//            @property(nonatomic,copy)NSString *eid;
//
//            @property(nonatomic,copy)NSString *bkey;


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
    YTBookItem *bookItem = [[YTBookItem alloc]init];
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
    booksArray = [YTSqliteTool selectWithSql:sql];
    
    
    return booksArray;
}

@end
