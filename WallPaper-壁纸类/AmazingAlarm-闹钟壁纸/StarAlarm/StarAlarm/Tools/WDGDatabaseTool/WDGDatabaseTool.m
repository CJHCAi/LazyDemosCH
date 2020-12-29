//
//  WDGDatabaseTool.m
//  WDGSqliteTool
//
//  Created by Wdgfnhui on 16/2/26.
//  Copyright © 2016年 Wdgfnhui. All rights reserved.
//

#import "WDGDatabaseTool.h"

#import <sqlite3.h>


static sqlite3 *db = nil;
static NSMutableDictionary *tableSource = nil;
static NSString *databasePath = nil;
static BOOL debugMode=YES;

@interface WDGDatabaseTool ()

@property(nonatomic, copy) NSString *tableName;
@property(nonatomic, strong) NSMutableDictionary *tableStuct;
@property(nonatomic, strong) NSMutableSet *tableColumnNames;

@property(nonatomic, copy) NSMutableString *orderSql;
@property(nonatomic, copy) NSMutableString *limitSql;
@end

@implementation WDGDatabaseTool


- (instancetype)initWithTableName:(NSString *)tableName {
    self = [super init];
    if (self) {
        self.tableName = tableName;
        databasePath = [NSString stringWithFormat:@"%@/Documents/%@.sqlite", NSHomeDirectory(), DB_NAME];
        NSLog(@"%@", databasePath);
        _orderSql = [NSMutableString string];
        _limitSql = [NSMutableString string];
        _tableStuct = [NSMutableDictionary dictionaryWithCapacity:0];
        sqlite3 *dbTemp;
        sqlite3_open([databasePath UTF8String], &dbTemp);
        sqlite3_stmt *statement;
        NSString *getsql = [NSString stringWithFormat:@"PRAGMA table_info(%@)", self.tableName];
        const char *getColumn = getsql.UTF8String;
        sqlite3_prepare_v2(dbTemp, getColumn, -1, &statement, nil);
        int i = 0;
        while (sqlite3_step(statement) == ROW) {
            i++;
            NSString *columnName = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
            NSString *columnType = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
            [self.tableStuct setValue:@[[self typeJugeWithTypeName:columnType], @(i)] forKey:[columnName lowercaseString]];
        }
        if([_tableStuct count]==0)
        {
            NSLog(@"No such table '%@' in database '%@'",_tableName,DB_NAME);
            //请查看控制台提示的错误信息
             [NSException raise:@"WDGDatabaseTool" format:@"No such table '%@' in database '%@'", _tableName, DB_NAME];
        }
        sqlite3_finalize(statement);
        sqlite3_close(dbTemp);
        _tableColumnNames = [NSMutableSet setWithArray:[_tableStuct allKeys]];
        [_tableColumnNames addObject:@"*"];
        NSLog(@"%@", databasePath);
    }
    return self;
}


- (NSNumber *)typeJugeWithTypeName:(NSString *)name {
    NSString *name2 = [name lowercaseString];
    if ([name2 containsString:@"varchar"] || [name2 containsString:@"text"]) {
        return @(STRINGTYPE);
    }
    else if ([name2 containsString:@"integer"])
        return @(INT64TYPE);
    else if ([name2 containsString:@"int"])
        return @(INT32TYPE);
    else if ([name2 containsString:@"float"] || [name2 containsString:@"double"])
        return @(DOUBLETYPE);
    else if ([name2 containsString:@"date"])
        return @(DATETYPE);
    else if ([name2 containsString:@"time"])
        return @(TIMETYPE);
    return @(ERRORTYPE);
}

+ (instancetype)DBManageWithTableName:(NSString *)tableName {
    tableName = [DB_PREFIX stringByAppendingString:tableName];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tableSource = [NSMutableDictionary dictionaryWithCapacity:0];
    });
    if (tableSource[tableName]) {
        return tableSource[tableName];
    }
    WDGDatabaseTool *wdg = [[WDGDatabaseTool alloc] initWithTableName:tableName];
    [tableSource setObject:wdg forKey:tableName];
    return wdg;
}


- (BOOL)openDatabase {

    return sqlite3_open(databasePath.UTF8String, &db) == OK;
    
}


- (BOOL)closeDatabase {
    return sqlite3_close(db) == OK;
}


+ (void)creatTableWithSQL:(NSString *)sql {

    if (debugMode) {
        NSLog(@"SQL:%@",sql);
    }
    databasePath = [NSString stringWithFormat:@"%@/Documents/%@.sqlite", NSHomeDirectory(), DB_NAME];
    if (sqlite3_open(databasePath.UTF8String, &db) == OK) {


        if (sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL) == OK) {
            NSLog(@"Create Table OK");
        }
        else {
            NSLog(@"Create Table Error");
        }
    }
    else {
        NSLog(@"Open Sql Error");
    }
    sqlite3_close(db);

}


- (void)bindDataWithSTMT:(STMT *)stmt Order:(int)order Value:(id)value Type:(NSNumber *)type {
    BOOL typeRight=true;
    switch (type.intValue) {
        case STRINGTYPE:
            typeRight=[[value class] isSubclassOfClass:[NSString class]];
            if (typeRight) {
                sqlite3_bind_text(stmt, order, ((NSString *) value).UTF8String, -1, NULL);
            }
            break;
        case INT32TYPE:
            typeRight=[[value class] isSubclassOfClass:[NSNumber class]];
            if (typeRight) {
                sqlite3_bind_int(stmt, order, ((NSNumber *) value).intValue);
            }
            break;
        case INT64TYPE:
            typeRight=[[value class] isSubclassOfClass:[NSNumber class]];
            if(typeRight)
            {
                sqlite3_bind_int64(stmt, order, ((NSNumber *) value).integerValue);
            }
            break;
        case DOUBLETYPE:
            typeRight=[[value class] isSubclassOfClass:[NSNumber class]];
            if (typeRight) {
                sqlite3_bind_double(stmt, order, ((NSNumber *) value).doubleValue);
            }
            break;
        default:
            typeRight=false;
            break;
    }
    if (!typeRight) {
        NSLog(@"In the table '%@' : Te type of\n '%@' \n is illegle", _tableName,value);
        //请查看控制台提示的错误信息
        [NSException raise:@"WDGDatabaseTool" format:@"In table '%@':Te type of '%@' error", _tableName,value];
    }
}

- (id)columnDataWithSTMT:(STMT *)stmt Order:(int)order Type:(NSNumber *)type {
    switch (type.intValue) {
        case STRINGTYPE:
            if ((const char *)sqlite3_column_text(stmt, order))
                return [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, order)];
            return @"";
            break;
        case INT32TYPE:
            return @(sqlite3_column_int(stmt, order));
            break;
        case INT64TYPE:
            return @(sqlite3_column_int64(stmt, order));
            break;
        case DOUBLETYPE:
            return @(sqlite3_column_double(stmt, order));
            break;
        default:
            return nil;
            break;
    }
}

- (void)whereSqlAppendWitihWhereCondition:(WDGWhereCondition *)condition SQL:(NSMutableString *)sql {
    if (condition) {
        if ([self isCorrectWhereConditionWithCondition:condition]) {
            [sql appendFormat:@" WHERE %@ %@ ?", condition.columnName, condition.Operator];
            if (condition.otherConditions.count > 0) {
                for (int i = 0; i < condition.otherConditions.count; i++) {
                    WDGWhereCondition *otherCondition = condition.otherConditions[i];
                    [sql appendFormat:@" %@ %@ %@ ?", condition.relations[i], otherCondition.columnName, otherCondition.Operator];
                }
            }
        }
    }
}

- (void)whereBindDataWithWhereCondition:(WDGWhereCondition *)condition AndSTMT:(STMT *)stmt {
    [self whereBindDataWithWhereCondition:condition AndSTMT:stmt NowOrder:0];
}

- (void)whereBindDataWithWhereCondition:(WDGWhereCondition *)condition AndSTMT:(STMT *)stmt NowOrder:(int)nowOrder {

    if (condition) {
        [self bindDataWithSTMT:stmt Order:1 + nowOrder Value:condition.value Type:_tableStuct[condition.columnName][0]];
        if (condition.otherConditions.count > 0) {
            for (int i = 0; i < condition.otherConditions.count; i++) {
                WDGWhereCondition *otherCondition = condition.otherConditions[i];
                [self bindDataWithSTMT:stmt Order:i + 2 + nowOrder Value:otherCondition.value Type:_tableStuct[otherCondition.columnName][0]];
            }
        }
    }

}


- (BOOL)insertDataWithDictionary:(NSDictionary *)dataDic {
    dataDic=[self transformDataDic:dataDic];
    NSArray *allKeys = [dataDic allKeys];
    STMT *stmt = NULL;
    if ([self isKeyInTableWithKeys:allKeys]) {
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@(", self.tableName];
        long lessOneCount = allKeys.count - 1;
        int p = 0;
        for (p = 0; p < lessOneCount; p++) {
            [sql appendFormat:@"%@, ", allKeys[p]];
        }
        [sql appendFormat:@"%@) VALUES(", allKeys[p]];
        for (p = 0; p < lessOneCount; p++) {
            [sql appendFormat:@"?, "];
        }
        [sql appendString:@"?)"];
        [self printSQL:sql DataDic:dataDic];
        
        int result = sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL);
        if (result == OK) {
            for (int i = 0; i < allKeys.count; i++) {
                [self bindDataWithSTMT:stmt Order:i + 1 Value:dataDic[allKeys[i]] Type:_tableStuct[allKeys[i]][0]];
            }
            BOOL flag = sqlite3_step(stmt) == DONE;
            sqlite3_finalize(stmt);
            return flag;
        }
    }
    sqlite3_finalize(stmt);
    return false;
}

- (NSArray *)selectDataWithWhereCondition:(WDGWhereCondition *)condition {

    NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@", self.tableName];

    [self whereSqlAppendWitihWhereCondition:condition SQL:sql];
    if (_orderSql.length > 0) {
        [sql appendString:_orderSql];
        [self clearStringWithMutableString:_orderSql];
    }
    if (_limitSql.length > 0) {
        [sql appendString:_limitSql];
        [self clearStringWithMutableString:_limitSql];
    }
    [self printSQL:sql DataDic:nil Condition:condition];
    STMT *stmt = NULL;
    int result = sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == OK) {
        [self whereBindDataWithWhereCondition:condition AndSTMT:stmt];
        NSArray *allKeys = [_tableStuct allKeys];
        while (STEP(stmt) == ROW) {
            NSMutableDictionary *rowData = [NSMutableDictionary dictionaryWithCapacity:0];
            for (int i = 0; i < allKeys.count; i++) {
//                int fields=sqlite3_column_count(stmt);
//                printf("%d",fields);
                [rowData setObject:[self columnDataWithSTMT:stmt Order:((NSNumber *) _tableStuct[allKeys[i]][1]).intValue - 1 Type:_tableStuct[allKeys[i]][0]] forKey:allKeys[i]];
            }
            [data addObject:rowData];
        }
    }
    sqlite3_finalize(stmt);
    return data;
}

- (BOOL)deleteDataWithWhereCondition:(WDGWhereCondition *)condition {

    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", self.tableName];
    [self whereSqlAppendWitihWhereCondition:condition SQL:sql];
    STMT *stmt = NULL;
    [self printSQL:sql DataDic:nil Condition:condition];
    int result = sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == OK) {
        [self whereBindDataWithWhereCondition:condition AndSTMT:stmt];
        BOOL flag = STEP(stmt) == DONE;
        sqlite3_finalize(stmt);
        return flag;
    }
    sqlite3_finalize(stmt);
    return NO;
}

- (BOOL)updateDataWithNewData:(NSDictionary *)dataDic WhereCondition:(WDGWhereCondition *)condition {
    dataDic=[self transformDataDic:dataDic];
    NSArray *allKeys = [dataDic allKeys];
    STMT *stmt = NULL;
    if ([self isKeyInTableWithKeys:allKeys]) {
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET", self.tableName];
        long lessOneCount = allKeys.count - 1;
        int p = 0;
        for (p = 0; p < lessOneCount; p++) {
            [sql appendFormat:@" %@ = ?,", allKeys[p]];
        }
        [sql appendFormat:@" %@ = ?", allKeys[p]];
        [self whereSqlAppendWitihWhereCondition:condition SQL:sql];

        int result = sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL);
        [self printSQL:sql DataDic:dataDic Condition:condition];
        if (result == OK) {
            int p = 0;
            for (; p < allKeys.count; p++) {
                [self bindDataWithSTMT:stmt Order:p + 1 Value:dataDic[allKeys[p]] Type:_tableStuct[allKeys[p]][0]];
            }
            [self whereBindDataWithWhereCondition:condition AndSTMT:stmt NowOrder:p];

            BOOL flag = STEP(stmt) == DONE;
            sqlite3_finalize(stmt);
            return flag;
        }

    }
    sqlite3_finalize(stmt);
    return NO;
}

- (NSArray *)selectAllData {
    return [self selectDataWithWhereCondition:nil];
}

- (instancetype)orderWithDictionary:(NSDictionary *)dic {
    [_orderSql appendString:@" ORDER BY "];
    dic=[self transformDataDic:dic];
    NSArray *allKeys = [dic allKeys];
    if ([self isKeyInTableWithKeys:allKeys]) {
        int i = 0;
        for (; i < allKeys.count; i++) {
            if ([[dic[allKeys[i]] uppercaseString] isEqualToString:@"DESC"]) {
                [_orderSql appendFormat:@"%@ DESC, ", allKeys[i]];
            }
            else {
                [_orderSql appendFormat:@"%@ ASC, ", allKeys[i]];
            }
        }
        NSRange range = {_orderSql.length - 2, 2};
        [_orderSql deleteCharactersInRange:range];
        //NSLog(@"%@", _orderSql);
        return self;
    }
    return nil;
}

- (BOOL)isKeyInTableWithKeys:(NSArray *)keys {

    for (NSString *key in keys) {
        if (![_tableColumnNames containsObject:[key lowercaseString]]) {

            if ([_tableColumnNames containsObject:[[[key lowercaseString] stringByReplacingOccurrencesOfString:@"distinct" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                continue;
            }
            
            NSLog(@"No such column_name '%@' in table '%@'", key, _tableName);
            //请查看控制台提示的错误信息
            [NSException raise:@"WDGDatabaseTool" format:@"No such column_name '%@' in table '%@'", key, _tableName];
            //exit(EXIT_FAILURE);
            return NO;
        }
    }
    return YES;
}

- (BOOL)isCorrectWhereConditionWithCondition:(WDGWhereCondition *)condition {
    if (!condition) {
        return NO;
    }
    if ([_tableColumnNames containsObject:condition.columnName]) {
        for (WDGWhereCondition *other in condition.otherConditions) {
            if (![_tableColumnNames containsObject:other.columnName]) {
                NSLog(@"No such column_name '%@' in table %@", other.columnName, _tableName);
                //请查看控制台提示的错误信息
                [NSException raise:@"WDGDatabaseTool" format:@"No such column_name '%@' in table %@", other.columnName, _tableName];
                return NO;
            }
        }
        for (NSString *relation in condition.relations) {
            if ((![relation isEqualToString:@"AND"]) && (![relation isEqualToString:@"OR"])) {
                NSLog(@"The relation '%@' is illegal", relation);
                //请查看控制台提示的错误信息
                [NSException raise:@"WDGDatabaseTool" format:@"The relation '%@' is illegal", relation];
                return NO;
            }
        }
        return YES;
    }
    NSLog(@"No such column_name '%@' in table %@", condition.columnName, _tableName);
    //请查看控制台提示的错误信息
    [NSException raise:@"WDGDatabaseTool" format:@"No such column_name '%@' in table %@", condition.columnName, _tableName];
    return NO;
}


- (instancetype)limitAtIndex:(NSInteger)index Rows:(NSInteger)row {
    [_limitSql appendFormat:@" LIMIT %ld, %ld", index, row];
    return self;
}

- (instancetype)limitForRows:(NSInteger)num {
    return [self limitAtIndex:0 Rows:num];
}

- (void)clearStringWithMutableString:(NSMutableString *)str {
    NSRange range = {0, str.length};
    [str deleteCharactersInRange:range];
}

- (NSArray *)selectWithFields:(NSArray *)fields Condition:(WDGWhereCondition *)condition {
    STMT *stmt = NULL;
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
    if ([self isKeyInTableWithKeys:fields]) {
        NSMutableString *sql = [NSMutableString stringWithString:@"SELECT"];
        long lessOneCount = fields.count - 1;
        int p = 0;
        for (p = 0; p < lessOneCount; p++) {
            [sql appendFormat:@" %@,", fields[p]];
        }
        [sql appendFormat:@" %@ FROM %@", fields[p], _tableName];
        [self whereSqlAppendWitihWhereCondition:condition SQL:sql];
        if (_orderSql.length > 0) {
            [sql appendString:_orderSql];
            [self clearStringWithMutableString:_orderSql];
        }
        if (_limitSql.length > 0) {
            [sql appendString:_limitSql];
            [self clearStringWithMutableString:_limitSql];
        }
        [self printSQL:sql DataDic:nil Condition:condition];

//        NSMutableArray *newFiels = [NSMutableArray arrayWithCapacity:0];
        int result = sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL);
        if (result == OK) {
            [self whereBindDataWithWhereCondition:condition AndSTMT:stmt];
            while (STEP(stmt) == ROW) {
                NSMutableDictionary *rowData = [NSMutableDictionary dictionaryWithCapacity:0];
                for (int i = 0; i < fields.count; i++) {
                    [rowData setObject:[self columnDataWithSTMT:stmt Order:i Type:_tableStuct[fields[i]][0]] forKey:fields[i]];
                }
                [data addObject:rowData];
            }
        }

    }
    sqlite3_finalize(stmt);
    return data;
}


-(NSDictionary *)transformDataDic:(NSDictionary *)dic{
    NSArray *allkeys=dic.allKeys;
    NSMutableDictionary *newDic=[NSMutableDictionary dictionary];
    for (NSString *key in allkeys) {
        [newDic setObject:dic[key] forKey:[key lowercaseString]];
    }
    return newDic;
}
-(void)printSQL:(NSString *)preSQL DataDic:(NSDictionary *)dataDic{
    [self printSQL:preSQL DataDic:dataDic Condition:nil];
   }
-(void)printSQL:(NSString *)preSQL DataDic:(NSDictionary *)dataDic Condition:(WDGWhereCondition *)condition{
    
    if (debugMode) {
        
        NSMutableString *sql=[NSMutableString stringWithString:preSQL];
        if (dataDic) {
            NSArray *allkeys=dataDic.allKeys;
            for (NSString *key in allkeys) {
                NSRange range=[sql rangeOfString:@"?"];
                [self replaceSQL:sql Range:range ColomName:key Value:dataDic[key]];
            }
        }
        if (condition) {
            NSRange range=[sql rangeOfString:@"?"];
            [self replaceSQL:sql Range:range ColomName:condition.columnName Value:condition.value];
            if (condition.otherConditions.count>0) {
                for (WDGWhereCondition *other in condition.otherConditions) {
                     NSRange range2=[sql rangeOfString:@"?"];
                    [self replaceSQL:sql Range:range2 ColomName:other.columnName Value:other.value];
                }
            }
        }
        NSLog(@"SQL:%@",sql);
    }
}

-(void)replaceSQL:(NSMutableString *)sql Range:(NSRange)range ColomName:(NSString *)colomname Value:(id)value{
    if (range.location==NSNotFound||range.length==0) {
        return;
    }
    BOOL typeRight=true;
    switch ([_tableStuct[colomname][0] intValue]) {
        case STRINGTYPE:
            typeRight=[[value class] isSubclassOfClass:[NSString class]];
            if (typeRight) {
                [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@"'%@'",value]];
            }
            break;
        case INT32TYPE:
            typeRight=[[value class] isSubclassOfClass:[NSNumber class]];
            if (typeRight) {
                [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%d",[value intValue]]];
            }
            break;
        case INT64TYPE:
            typeRight=[[value class] isSubclassOfClass:[NSNumber class]];
            if (typeRight) {
                 [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%ld",[value integerValue]]];
            }
            break;
        case DOUBLETYPE:
            typeRight=[[value class] isSubclassOfClass:[NSNumber class]];
            if (typeRight) {
                 [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%lf",[value doubleValue]]];
            }
            break;
        default:
            break;
    }
}

-(NSInteger)getRowCount{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT count(*) FROM %@",_tableName];
    [self printSQL:sql DataDic:nil Condition:nil];
    STMT *stmt = NULL;
    NSInteger row=0;
    int result = sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == OK) {
        while (STEP(stmt) == ROW) {
           row= ((NSNumber *)[self columnDataWithSTMT:stmt Order:0 Type:@(INT64TYPE)]).integerValue;
        }
    }
    sqlite3_finalize(stmt);
    return row;
}

+(void)openDebugMode:(BOOL)isOutPutMode{
    debugMode=isOutPutMode;
}
@end
