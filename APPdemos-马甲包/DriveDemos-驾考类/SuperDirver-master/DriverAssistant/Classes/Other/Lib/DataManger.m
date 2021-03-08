//
//  DataManger.m
//  DriverAssistant
//
//  Created by C on 16/3/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "DataManger.h"
#import "FMDatabase.h"
#import "TestSelectModel.h"
#import "AnswerModel.h"
#import "SubChapterModel.h"

@implementation DataManger
+(NSArray *)getData:(DataType)type
{
    static FMDatabase *dataBase;
    NSMutableArray *array = [NSMutableArray array];
    if (dataBase == nil)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"sqlite"];
        dataBase = [FMDatabase databaseWithPath:path];
    }
    if (dataBase.open)
    {

    }
    else
    {
        return array;
    }
    switch (type) {
        case chapter:
        {
            NSString *sql = @"select pid,pname,pcount from firstlevel";
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                TestSelectModel *model = [[TestSelectModel alloc] init];
                model.pid = [NSString stringWithFormat:@"%d", [rs intForColumn:@"pid"]];
                model.pname = [rs stringForColumn:@"pname"];
                model.pcount = [NSString stringWithFormat:@"%d", [rs intForColumn:@"pcount"]];
                [array addObject:model];
            }
        }
            break;
        case answer:
        {
            NSString *sql = @"select mquestion,mdesc,mid,manswer,mimage,pid,sid,sname,mtype from leaflevel";
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                AnswerModel *model = [[AnswerModel alloc] init];
                model.mquestion = [rs stringForColumn:@"mquestion"];
                model.mdesc = [rs stringForColumn:@"mdesc"];
                model.mid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"mid"]];
                model.manswer = [rs stringForColumn:@"manswer"];
                model.mimage = [rs stringForColumn:@"mimage"];
                model.pid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pid"]];
                model.sid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"sid"]];
                model.sname = [rs stringForColumn:@"sname"];
                model.mtype = [NSString stringWithFormat:@"%d",[rs intForColumn:@"mtype"]];
                [array addObject:model];
            }
        }
            break;
        case subChapter:
        {
            NSString *sql = @"select serial,sid,sname,pid,scount from secondlevel";
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                SubChapterModel *model = [[SubChapterModel alloc] init];
                model.serial = [rs stringForColumn:@"serial"];
                model.sid = [NSString stringWithFormat:@"%.2f", [rs doubleForColumn:@"sid"]];
                model.sname = [rs stringForColumn:@"sname"];
                model.pid = [NSString stringWithFormat:@"%d", [rs intForColumn:@"pid"]];
                model.scount = [NSString stringWithFormat:@"%d", [rs intForColumn:@"scount"]];
                [array addObject:model];
            }
        }
            break;
        default:
            break;
    }
    return array;
}
@end
