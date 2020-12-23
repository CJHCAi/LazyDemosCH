//
//  savehistoryData.m
//  Calculator1
//
//  Created by ruru on 16/6/21.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "savehistoryData.h"

@implementation savehistoryData{
int index;
}
//-(void)initSaveHistoryData{
//    index = 10;
//    self.test = @"asdf";
//}
//-(void)setTheIndex:(int)set{
//    index = set;
//}
//-(int)getTheIndex{
//    return index;
//}
//+(void)pageNext{
//    savehistoryData * temp = [savehistoryData sharedInstance];
//    temp.test = @"asdf";
//    [temp setTheIndex:[temp getTheIndex]+1];
//}
//+(void)pageUp{
//    savehistoryData * temp = [savehistoryData sharedInstance];
//    temp.test = @"asdf";
//    [temp setTheIndex:[temp getTheIndex]-1];
//}
+(instancetype)sharedInstance{
    static savehistoryData * singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
//        [singleton initSaveHistoryData];
        [singleton getFmdbBase];
    });
    return singleton;
}
-(FMDatabase *)getFmdbBase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"historyData.db"];
    self.db = [FMDatabase databaseWithPath:dbPath];
    [self.db open];
    [self.db executeUpdate:@"CREATE TABLE historyTable (ID integer primary key  autoincrement,time integer,beforeNub text, operationType text,CurrentNub text,result text)"];
    return self.db;
}

+(void)historyAdd:(NSString *)curretTime beforeNum:(NSString *)beforeNub operationType:(NSString *)operationType CurrentNub:(NSString *)currentNub result:(NSString *)resultdate{
    savehistoryData *His=[savehistoryData sharedInstance];
    [His.db executeUpdate:@"INSERT INTO historyTable (time,beforeNub,operationType,CurrentNub,result) VALUES (?,?,?,?,?)",curretTime,beforeNub,operationType,currentNub, resultdate];
}
#pragma mark 初始化加载历史记录数据
+(NSMutableArray *)seachHistoryData{
    NSMutableArray *history=[[NSMutableArray alloc]init];
    savehistoryData *his=[savehistoryData sharedInstance];
    FMResultSet *rs = [his.db executeQuery:@"SELECT * FROM historyTable"];
    while ([rs next]) {
        int ID=[rs intForColumn:@"ID"];
        NSString *IDStr=[NSString stringWithFormat:@"%d",ID];
        NSString *time=[rs stringForColumn:@"time"];
        NSString *beforeNub=[rs stringForColumn:@"beforeNub"];
        NSString *operationType = [rs stringForColumn:@"operationType"];
        NSString *currentNub=[rs stringForColumn:@"currentNub"];
        NSString *ResultStr = [rs stringForColumn:@"result"];
        NSDictionary *dic=@{@"ID":IDStr,@"time":time,@"beforeNub":beforeNub,@"operationType":operationType,@"currentNub":currentNub,@"ResultStr":ResultStr};
        [history insertObject:dic atIndex:0];
    }
    [rs close];
    return history;
}
+(void)deleteAllHistory{
    savehistoryData *his=[savehistoryData sharedInstance];
    [his.db executeUpdate:@"DELETE FROM historyTable"];
}
+(void)deleteSelectHistory:(NSString *)IDStr{
    savehistoryData *his=[savehistoryData sharedInstance];
    [his.db executeUpdate:@"delete from historyTable where ID = ?",IDStr];
}

@end
