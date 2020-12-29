//
//  ZSDBManageBaseModel.m
//  HandsUp
//
//  Created by wanghui on 2018/4/19.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import "ZSDBManageBaseModel.h"
#import "DatabaseToll.h"
#import "ZSDBBaseModel.h"
#import "NSArray+Extension.h"
@implementation ZSDBManageBaseModel
SISingletonM(ZSDBManageBaseModel)
-(BOOL)insertWithModel:(ZSDBBaseModel*)dataModel{

    DatabaseToll *dbTool = [DatabaseToll sharedDatabaseToll] ;
    BOOL isSuc;
    
       isSuc= [dbTool executeWithUpdate:[self getSqlString:dataModel withImplementType:implementType_insert]];
   

  
  
    return isSuc;
}
-(void)insertWithArray:(NSArray*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock{
   DatabaseToll*dbToll =   [DatabaseToll sharedDatabaseToll];
    [dbToll.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
       
        @try {
            
               for (ZSDBBaseModel*dataModel in dataArray) {
                   NSString *sqlStr = [self getSqlString:dataModel withImplementType:implementType_insert];
                 BOOL isSuc =  [dbToll executeWithDB:db andUpdate:sqlStr];
                   if (isSuc) {
                       DLog(@"插入数据成功");
                   }else{
                       *rollback = YES;
                   }
               }
            
        } @catch (NSException *exception) {
            *rollback = YES;
            [db rollback];
            sucBlock(NO);
        } @finally {
            if (!*rollback) {
                [db commit];
                sucBlock(YES);
            }else{
               [db rollback];
//               DLog(@"%d",rollback);
            }
            
        }
    }];
   
}
-(void)deleteWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock{
    DatabaseToll*dbToll =   [DatabaseToll sharedDatabaseToll];
    [dbToll.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        @try {
            
            for (ZSDBBaseModel*dataModel in dataArray) {
                NSString *sqlStr = [self getSqlString:dataModel withImplementType:implementType_delete];
                BOOL isSuc =  [dbToll executeWithDB:db andUpdate:sqlStr];
                if (isSuc) {
                    DLog(@"删除数据成功");
                }else{
                    *rollback = YES;
                }
            }
            
        } @catch (NSException *exception) {
            *rollback = YES;
            [db rollback];
            sucBlock(NO);
        } @finally {
            if (!*rollback) {
                [db commit];
                sucBlock(YES);
            }else{
                [db rollback];
                //               DLog(@"%d",rollback);
            }
            
        }
    }];
    
}
-(void)deleteUpdateWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock{
    DatabaseToll*dbToll =   [DatabaseToll sharedDatabaseToll];
    [dbToll.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        @try {
            
            for (ZSDBBaseModel*dataModel in dataArray) {
                dataModel.updateDict = @{@"isDelete":@(1)};
                NSString *sqlStr = [self getSqlString:dataModel withImplementType:implementType_update];
                BOOL isSuc =  [dbToll executeWithDB:db andUpdate:sqlStr];
                if (isSuc) {
                    DLog(@"删除数据成功");
                }else{
                    *rollback = YES;
                }
            }
            
        } @catch (NSException *exception) {
            *rollback = YES;
            [db rollback];
            sucBlock(NO);
        } @finally {
            if (!*rollback) {
                [db commit];
                sucBlock(YES);
            }else{
                [db rollback];
                //               DLog(@"%d",rollback);
            }
            
        }
    }];
    
}
-(void)deleteWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andIsLogicallyelete:(BOOL)isLogicallyDelete andSuc:(void(^)(BOOL isSuc))sucBlock{
    if (isLogicallyDelete) {
        [self deleteUpdateWithArray:dataArray andSuc:^(BOOL isSuc) {
            sucBlock(isSuc);
        }];
    }else{
        [self deleteWithArray:dataArray andSuc:^(BOOL isSuc) {
            sucBlock(isSuc);
        }];
    }
}

-(void)updateDataWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock{
    DatabaseToll*dbToll =   [DatabaseToll sharedDatabaseToll];
    [dbToll.queue inDeferredTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        @try {
            
            for (ZSDBBaseModel*dataModel in dataArray) {
                NSString *sqlStr = [self getSqlString:dataModel withImplementType:implementType_update];
                BOOL isSuc =  [dbToll executeWithDB:db andUpdate:sqlStr];
                if (isSuc) {
                    DLog(@"修改数据成功");
                }else{
                    *rollback = YES;
                }
            }
            
        } @catch (NSException *exception) {
            *rollback = YES;
            [db rollback];
            sucBlock(NO);
        } @finally {
            if (!*rollback) {
                [db commit];
                sucBlock(YES);
            }else{
                [db rollback];
                //               DLog(@"%d",rollback);
            }
            
        }
    }];
}
-(NSString*)getSqlString:(ZSDBBaseModel*)dataModel withImplementType:(implementType)type{
    if (type == implementType_insert) {
        return [self getInsertString:dataModel];
    }else if (type == implementType_delete){
         return [self getDeleteString:dataModel];
    }else if (type == implementType_update){
        return [self getUpdateString:dataModel];
    }else if(type == implementType_select){
       return [self getSelectString:dataModel];
    }
    return @"";
}
-(NSString *)getSelectString:(ZSDBBaseModel*)dataModel{
    NSMutableString*strSql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ",dataModel.tableName ];
    
    if (dataModel.whereIdDict.count > 0) {
        [strSql appendFormat:@"WHERE "];
        for (int i = 0;i<dataModel.whereIdDict.count;i++) {
            NSString*keys = dataModel.whereIdDict[i];
            [strSql appendFormat:@"%@ = ",keys];
            if ([[dataModel valueForKey:keys]isKindOfClass:[NSString class]]) {
                
                [strSql appendFormat:@"'%@' ",[[dataModel valueForKey:keys] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
            }else{
                [strSql appendFormat:@"%d ",[[dataModel valueForKey:keys]intValue]];
            }
            if (i < dataModel.whereIdDict.count-1) {
                [strSql appendString:@"and "];
            }
        }
        
    }
    return strSql;
}
-(NSString *)getDeleteString:(ZSDBBaseModel*)dataModel{
    NSMutableString *whereStr = [NSMutableString stringWithString:@"where "];
    
    for (int i = 0;i< dataModel.whereIdDict.count;i++) {
        NSString*keys = dataModel.whereIdDict[i];
        [whereStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=",keys]];
        if ([[dataModel valueForKey:keys] isKindOfClass:[NSString class]]) {
            
            [whereStr appendFormat:@"'%@'",[[dataModel valueForKey:keys] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
        }else{
            [whereStr appendFormat:@"%d",[[dataModel valueForKey:keys]intValue]];
        }
        if (i < dataModel.whereIdDict.count - 1) {
            [whereStr appendFormat:@" and "];
        }
    }
    DLog(@"%@",whereStr);
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ %@",dataModel.tableName,whereStr];
    return sqlStr;
}
-(NSString *)getInsertString:(ZSDBBaseModel*)dataModel{
//    NSDictionary*dict = [NSDictionary getObjectData:dataModel];
        NSArray *arry = [NSArray getProperties:[dataModel class]];
    NSMutableString *fieldStr = [NSMutableString string];
    NSMutableString*value = [NSMutableString string];
    for (NSString* field in arry) {
        if (![field isEqualToString:@"ID"]) {
            if ([dataModel valueForKey:field] != nil && (![[dataModel valueForKey:field]  isKindOfClass:[NSDictionary class]]) &&(![[dataModel valueForKey:field]  isKindOfClass:[ZSDBBaseModel class]])) {
            
            [fieldStr appendString:field];
            [fieldStr appendString:@","];
            if ([[dataModel valueForKey:field]  isKindOfClass:[NSString class]]) {
                
                [value appendString:[NSString stringWithFormat:@"'%@'",[[dataModel valueForKey:field]  stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]]] ;
            }else{
                [value appendString:[NSString stringWithFormat:@"%d",[[dataModel valueForKey:field] intValue]] ];
            }
            [value appendString:@","];
                
            }
        }
        
    }
    if (fieldStr.length > 0) {
        [fieldStr deleteCharactersInRange:NSMakeRange(fieldStr.length - 1, 1)];
    }
    if (value.length > 0) {
        [value deleteCharactersInRange:NSMakeRange(value.length - 1, 1)];
    }
    NSString *insertString = [NSString stringWithFormat:@"INSERT INTO %@(%@)VALUES(%@)",dataModel.tableName,fieldStr,value];
    return insertString;
}
-(NSString *)getUpdateString:(ZSDBBaseModel*)dataModel{
    NSMutableString *whereStr = [NSMutableString stringWithString:@"where "];
    NSMutableString *setString = [NSMutableString string];
    for (int i = 0;i< dataModel.whereIdDict.count;i++) {
        NSString*keys = dataModel.whereIdDict[i];
        [whereStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=",keys]];
        if ([[dataModel valueForKey:keys] isKindOfClass:[NSString class]]) {
            
            [whereStr appendFormat:@"'%@'",[[dataModel valueForKey:keys] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
        }else{
            [whereStr appendFormat:@"%d",[[dataModel valueForKey:keys]intValue]];
        }
        if (i < dataModel.whereIdDict.count - 1) {
            [whereStr appendFormat:@" and "];
        }
    }
    if (dataModel.updateDict) {
    
    for (NSString *str in dataModel.updateDict.allKeys) {
        if (![dataModel isElideField:str]) {
        if ([dataModel.updateDict[str] isKindOfClass:[NSNull class]]) {
            if ([[dataModel valueForKey:str]isKindOfClass:[NSString class]]) {
                
                [setString appendFormat:@"%@ = '%@',",str,[[dataModel valueForKey:str] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
            }else{
                [setString appendFormat:@"%@ = %d,",str,[[dataModel valueForKey:str]intValue]];
            }
        }else{
            if ([dataModel.updateDict[str]isKindOfClass:[NSString class]]) {
                [setString appendFormat:@"%@ = '%@',",str,[dataModel.updateDict[str] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
            }else{
                [setString appendFormat:@"%@ = %d,",str,[dataModel.updateDict[str]intValue]];
            }
        }
    }
    }
    }else{
        NSArray *array = [NSArray getProperties:[dataModel class]];
        for (NSString *keys in array) {
            if (![dataModel isElideField:keys]) {
                if ([dataModel valueForKey:keys]!=nil &&(![[dataModel valueForKey:keys] isKindOfClass:[ZSDBBaseModel class]])) {
                    if ([[dataModel valueForKey:keys]isKindOfClass:[NSString class]]) {
                        
                        [setString appendFormat:@"%@ = '%@',",keys,[[dataModel valueForKey:keys] stringByReplacingOccurrencesOfString:@"\'"withString:@"\'\'"]];
                    }else{
                        [setString appendFormat:@"%@ = %d,",keys,[[dataModel valueForKey:keys]intValue]];
                    }
                }
                
            }
        }
    }
    if (setString.length >0) {
        
        [setString deleteCharactersInRange:NSMakeRange(setString.length-1, 1)];
    }
    DLog(@"%@",whereStr);
    NSString *sqlStr = [NSString stringWithFormat:@"update %@ set %@ %@ ",dataModel.tableName,setString,whereStr];
    return sqlStr;
}
-(FMResultSet*)queryWithSql:(NSString *)sqlStr{
    DatabaseToll *tool = [DatabaseToll sharedDatabaseToll];
    FMResultSet *rs =   [tool executeQuery:sqlStr];
    return rs;
}
-(ZSDBBaseModel*)queryWithModel:(ZSDBBaseModel*)dataModel{
    NSString*sqlStr = [self getSqlString:dataModel withImplementType:implementType_select];
    DatabaseToll *tool = [DatabaseToll sharedDatabaseToll];
    FMResultSet *rs =   [tool executeQuery:sqlStr];
    NSArray*array = [NSArray getProperties:[dataModel class]];
    ZSDBBaseModel*model = [[dataModel class] new];
    while ([rs next]) {
//        NSString *clsse = NSStringFromClass([dataModel class]);
        
        for (NSString *keys in array) {
            
            if ([rs stringForColumn:keys] != nil) {
                [model setValue:[rs stringForColumn:keys] forKey:keys];
            }
            
            
        }
        
    }
    return model;
}
-(NSArray*)queryWihtClass:(Class)cls andSql:(NSString*)sql{
    FMResultSet *rs = [self queryWithSql:sql];
    NSMutableArray*dataArray = [NSMutableArray array];
    while ([rs next]) {
        NSArray*array = [NSArray getProperties:cls];
        ZSDBBaseModel* model = [cls  new];
        for (NSString *keys in array) {
            
            if ([rs stringForColumn:keys] != nil) {
                [model setValue:[rs stringForColumn:keys] forKey:keys];
            }
        }
       
        [dataArray addObject:model];
    }
    return dataArray;
}
-(NSArray*)analysisWihtClass:(Class)cls andRs:(FMResultSet*)rs{
    NSMutableArray*dataArray = [NSMutableArray array];
    while ([rs next]) {
        NSArray*array = [NSArray getProperties:cls];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *keys in array) {
            
            if ([rs stringForColumn:keys] != nil) {
                [dict setObject:[rs stringForColumn:keys] forKey:keys];
            }
        }
        ZSDBBaseModel* model = [cls  mj_objectWithKeyValues:dict];
        [dataArray addObject:model];
    }
    return dataArray;
}
-(void)updateNotThingDataWithArray:(ZSDBBaseModel*)dataModel andSuc:(void(^)(BOOL isSuc))sucBlock{
  
    
}
@end
