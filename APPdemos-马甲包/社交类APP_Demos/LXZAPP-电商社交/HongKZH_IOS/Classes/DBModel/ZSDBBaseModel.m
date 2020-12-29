//
//  ZSDBBaseModel.m
//  HandsUp
//
//  Created by wanghui on 2018/4/19.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import "ZSDBBaseModel.h"
#import "DatabaseToll.h"
#import "NSArray+Extension.h"
@implementation ZSDBBaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}
-(BOOL)isExsistWithFieldArray:(NSArray*)array andDB:(FMDatabase*)db{
    if (db == nil) {
        db = [DatabaseToll sharedDatabaseToll].db;
    }
    NSMutableString * whereStr = [NSMutableString string];
    for (int i = 0; i< array.count;i++) {
        NSString*str = array[i];
        [whereStr appendFormat:@"%@ =",str];
        if ([[self valueForKey:str] isKindOfClass:[NSString class]]) {
            [whereStr appendFormat:@"'%@' ",[[self valueForKey:str] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
        }else{
            [whereStr appendFormat:@"%d ",[[self valueForKey:str]intValue]];
        }
        if (i < array.count-1) {
            [whereStr appendFormat:@"and "];
        }
    }
    NSString *string  =[NSString stringWithFormat:@"select count(*) as countNum  from %@ where %@",self.tableName,whereStr];
    FMResultSet *rs =   [db executeQuery:string];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"countNum"];
        if (count >= 1) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)isElideField:(NSString*)Field{
    if ((![Field isEqualToString:@"ID"])&&(![Field isEqualToString:@"tableName"])&&(![Field isEqualToString:@"whereIdDict"])&&(![Field isEqualToString:@"updateDict"])&&(![Field isEqualToString:@"elideField"])) {
        if (self.elideField == nil) {
            return NO;
        }else{
            BOOL isExit = NO;
            for (NSString *keys in self.elideField) {
                if ([keys isEqualToString:Field]) {
                    isExit = YES;
                    break;
                }
            }
            return isExit;
        }
    }else{
        return YES;
        
        
    }
}

+(instancetype)getModelWithRs:(FMResultSet*)rs andCls:(Class)cls{
    NSArray*array = [NSArray getProperties:cls];
    Class model =  NSClassFromString(NSStringFromClass(cls));
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    ZSDBBaseModel*model2 = [model new];
    for (NSString *keys in array) {
        if (([rs stringForColumn:keys]) ) {
            [model2 setValue:[rs stringForColumn:keys] forKey:keys];
            
        }
    }
    
        return model2;
}
-(BOOL)isHasTable:(FMDatabase*)db{
  NSArray*array =  [NSArray getProperties:[self class]];
    NSMutableString* strA = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT",self.tableName];
    for (NSString*s in array) {
        if ((![[self valueForKey:s]isKindOfClass:[NSArray class]])&& (![[self valueForKey:s]isKindOfClass:[NSDictionary class]])) {
            [strA appendFormat:@"%@", [NSString stringWithFormat:@",%@ text",s]];
        }
        
    }
    [strA appendFormat:@",param1 text,param2 text,param3 text,param4 text,param5 text,param6 text,param7 text,param text,param8 text,param9 text,param10 text)"];
   
        BOOL createTableResult=[db executeUpdate:strA];
        if (createTableResult) {
            DLog(@"创建表成功");
            return YES;
        }else{
            return NO;
            DLog(@"创建表失败");
        }
   
    return YES;
}
@end
