//
//  DFBaseStorageService.m
//  DFChatStorage
//
//  Created by Allen Zhong on 15/5/1.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseStorageService.h"




@interface DFBaseStorageService()

@property (nonatomic, strong) FMDatabase *db;

@end



@implementation DFBaseStorageService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _db = [DFDatabaseHelper sharedDatabase:[self getDatabaseName]];
    }
    return self;
}

-(NSString *) getDatabaseName
{
    return @"default";
}
-(void)openSession
{
    if (_db == nil) {
        return;
    }
    if (![_db open]) {
        NSLog(@"db can not open!");
    }
}

-(void)closeSession
{
    if (_db == nil) {
        return;
    }
    
    [_db close];
}


-(BOOL)executeUpdate:(NSString *)sql params:(NSDictionary *) params
{
    BOOL result = NO;
    [self openSession];
    result = [_db executeUpdate:sql withParameterDictionary:params];
    [self closeSession];
    return result;
}

-(FMResultSet *)executeQuery:(NSString *) sql params:(NSDictionary *)params
{
    FMResultSet *rs = nil;
    [self openSession];
    rs = [_db executeQuery:sql withParameterDictionary:params];
    return rs;
}

@end
