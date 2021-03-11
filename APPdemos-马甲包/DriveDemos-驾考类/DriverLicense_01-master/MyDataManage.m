//
//  MyDataManage.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/10.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import "MyDataManage.h"
#import "FMDatabase.h"
#import "TestSelectModel.h"
#import "AnswerModel.h"
@implementation MyDataManage
+(NSArray *)getData:(DataType) type
{
    static FMDatabase *dataBase;
    NSMutableArray *array =[[NSMutableArray alloc]init];
    if (dataBase == nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"sqlite"];
        dataBase =[[FMDatabase alloc]initWithPath:path];
    }
    if ([dataBase open]) {
        NSLog(@"open success");
        
    }else{
        return array;
    }
    switch (type) {
        case chapter://章节数据处理
        {
            NSString *sql = @"select pid,pname,pcount FROM firstlevel";
            FMResultSet *rs = [dataBase executeQuery:sql];
            //重复
            while ([rs next]) {
                TestSelectModel *model = [[TestSelectModel alloc]init];
                model.pid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pid"]];
                model.pname = [rs stringForColumn:@"pname"];
                model.pcount = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pcount"]];
                [array addObject:model];
                
            }
        }
            break;
        case answer://问题数据处理
        {
            NSString *sql = @"select mquestion,mdesc,mid,manswer,mimage,pid,pname,sid,sname,mtype FROM leftlevel";
            FMResultSet *rs = [dataBase executeQuery:sql];
            //重复
            while ([rs next]) {
                AnswerModel *model = [[AnswerModel alloc]init];
                model.mquestion = [rs stringForColumn:@"mquestion"];
                model.mdesc = [rs stringForColumn:@"mdesc"];
            
                model.mid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"mid"]];
                model.manswer = [rs stringForColumn:@"manswer"];
                model.mimage = [rs stringForColumn:@"mimage"];
                
                model.pid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pid"]];
                model.pname = [rs stringForColumn:@"pname"];
                model.sid = [NSString stringWithFormat:@"%D",[rs intForColumn:@"sid"]];
                model.sname = [rs stringForColumn:@"sname"];
                model.mtype = [NSString stringWithFormat:@"%d",[rs intForColumn:@"mtype"]];
                [array addObject:model];
                
            }
        }

            
        default:
            break;
    }
    return array;
}
@end
