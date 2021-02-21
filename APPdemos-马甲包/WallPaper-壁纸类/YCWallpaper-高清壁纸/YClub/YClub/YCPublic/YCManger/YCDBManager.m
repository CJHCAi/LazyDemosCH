//
//  YCDBManager.m
//  YClub
//
//  Created by yuepengfei on 17/5/17.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCDBManager.h"

@interface YCDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *cacheDBQueque;
@end

static NSString *const cacheDBPath                = @"YCCache.db";

@implementation YCDBManager

+ (instancetype)shareInstance
{
    static YCDBManager *dbManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dbManger = [[YCDBManager alloc] init];
    });
    return dbManger;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configDB];
    }
    return self;
}
- (void)configDB
{
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbDir       = [libraryPath stringByAppendingString:@"/YCClub"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbDir]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dbDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbPath      = [dbDir stringByAppendingString:[NSString stringWithFormat:@"/%@", cacheDBPath]];
    _cacheDBQueque = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!_cacheDBQueque) return;
    [_cacheDBQueque inDatabase:^(FMDatabase *db) {
        
        NSString *collectTable = @"create table if not exists collectPics(thumb text UNSIGNED NOT NULL PRIMARY KEY, img text, joinDate dateTime, reserve text);";
        BOOL collectResult = [db executeUpdate:collectTable];
        if (collectResult) {
            NSLog(@"---------收藏创建成功");
            NSLog(@"---------%@",dbPath);
        }
        
    }];
}
#pragma mark -------- action
// 保存
- (BOOL)savePic:(YCBaseModel *)pic
{
    __block BOOL reslut = NO;
    NSString *insertSql = @"insert or replace into collectPics(thumb,img,joinDate,reserve) values(?,?,?,?)";;
    [_cacheDBQueque inDatabase:^(FMDatabase *db) {
        
        reslut = [db executeUpdate:insertSql,pic.thumb,pic.img,[NSDate date],pic.reserve];
    }];
    return reslut;
}
// 删除
- (BOOL)deletePic:(YCBaseModel *)pic
{
    __block BOOL reslut = NO;
    NSString *deleteSql = @"delete from collectPics where thumb = ?";
    [_cacheDBQueque inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        reslut = [db executeUpdate:deleteSql,pic.thumb];
    }];
    return reslut;
}
// 获取
- (NSArray *)getAllPics
{
    NSMutableArray *foods = [NSMutableArray array];
    NSString *selectSql = @"select * from collectPics order by joinDate desc";
    [_cacheDBQueque inDatabase:^(FMDatabase *db) {
        
        FMResultSet * data = [db executeQuery:selectSql];
        while (data.next) {
            YCBaseModel *pic = [[YCBaseModel alloc] init];
            pic.thumb        = [data objectForColumn:@"thumb"];
            pic.img          = [data objectForColumn:@"img"];
            pic.reserve      = [data objectForColumn:@"reserve"];
            [foods addObject:pic];
        }
        [data close];
    }];
    return foods;
}
+ (void)runBlockInBackground:(void (^)())block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block)
        {
            block();
        }
    });
}
@end
