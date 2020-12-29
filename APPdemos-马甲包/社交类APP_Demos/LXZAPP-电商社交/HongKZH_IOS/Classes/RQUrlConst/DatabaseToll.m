//
// DatabaseToll.m
// HandsUp
//
// Created by wanghui on 2018/4/18.
// Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import "DatabaseToll.h"
@implementation DatabaseToll
SISingletonM(DatabaseToll)
+(BOOL)setUpDatabase{
 
 int versions = [[[NSUserDefaults standardUserDefaults]objectForKey:DBVERSIONS] intValue];
    DLog(@"%@",[DatabaseToll dataFilePath]);
 if (versions < 1) {
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 FMDatabase *db = [FMDatabase databaseWithPath:dbbasePath];
 if(![fileManager fileExistsAtPath:[DatabaseToll dataFilePath]]) {
     DLog(@"还未创建数据库，现在正在创建数据库");
     [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:DBVERSIONS];
 if([db open]) {
   BOOL isSuc = [DatabaseToll createTabel:db];
    [db close];
    return isSuc;
 }else{
  DLog(@"database open error");
    return NO;
 }
 }
 DLog(@"FMDatabase:---------%@",db);
 
 }else{
      int versions = [[[NSUserDefaults standardUserDefaults]objectForKey:TableVERSIONS] intValue];
     if (versions < 1) {
         DLog(@"db:%@",dbbasePath);
     FMDatabase *db = [FMDatabase databaseWithPath:dbbasePath];
     if([db open]) {
         BOOL isSuc = [DatabaseToll createTabel:db];
         [db close];
         return isSuc;
     }else{
         DLog(@"database open error");
         return NO;
     }
         
     }
 return YES;
 }
 return NO;
}
+(BOOL)createTabel:(FMDatabase*)db{
 [db beginTransaction];
 BOOL isSuc = YES;
 for (NSString*sql_str in [DatabaseToll getSqlStrArry]) {
 BOOL createTableResult=[db executeUpdate:sql_str];
 if (createTableResult) {
  DLog(@"创建表成功");
 
 }else{
  isSuc = NO;
  DLog(@"创建表失败");
 }
 }
 if (isSuc) {
     [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:TableVERSIONS];
 [db commit];
 }else{
 [db rollback];
 }
    return isSuc;
}
+(NSArray*)getSqlStrArry{
 NSMutableArray *array = [NSMutableArray array];
// ,param1 text,param2 text,param3 text,param4 text,param5 text,param6 text,param7 text,param text,param8 text,param9 text,param10 text
 NSString *system_user = @"CREATE TABLE IF NOT EXISTS systemPushInfo (id integer PRIMARY KEY AUTOINCREMENT, headImg text ,sysUid text, uname text,name text,isDelete integer,coverImgSrc text,postId text,type integer,title text,createDate text,content text,uid text,circleId text,dataType integer,param1 text,param2 text,param3 text,param4 text,param5 text,param6 text,param7 text,param text,param8 text,param9 text,param10 text)";

    [array addObject:system_user];
 return array;
}
+ (NSString *) dataFilePath//应用程序的沙盒路径
{
 NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *document = [path objectAtIndex:0];
 return[document stringByAppendingPathComponent:@"LEXiaoZhuan.sqlite"];
}
-(FMDatabaseQueue *)queue{
 if (!_queue) {
 _queue = [FMDatabaseQueue databaseQueueWithPath:dbbasePath];
 }
 return _queue;
}
-(FMDatabase *)db{
 if (!_db) {
 _db = [FMDatabase databaseWithPath:dbbasePath];
 }
 return _db;
}
- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block{
 [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
 block(db,rollback);
 }];
}
- (BOOL)executeWithDB:(FMDatabase*)db andUpdate:(NSString*)sql, ...{
 return [db executeUpdate:sql];
}
- (BOOL)executeWithUpdate:(NSString*)sql, ...{
 if ([self.db open]) {
 BOOL issuc = [self.db executeUpdate:sql];
// [self.db close];
 return issuc;
 }
 return NO;
}
-(FMResultSet*)executeQuery:(NSString*)sql,...{
 if ([self.db open]) {
 FMResultSet *issuc = [self.db executeQuery:sql];
     
// [self.db close];
 return issuc;
 }
 return nil;
 
}
-(FMResultSet*)executeQueryDB:(FMDatabase*)db sqlString:(NSString*)sql,...{
    
        FMResultSet *issuc = [db executeQuery:sql];
        
        // [self.db close];
        return issuc;
    
}
//-(void)saveVoideo:(NSData *)dataVoido andImage:(UIImage*)image sucBlack:(void(^)(BOOL isImageSuc,BOOL isVoideoSuc, NSString*imageName,NSString*name ))sucBlock{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    BOOL isDir = NO;
//    NSString *filePath = [self getChat:@"" withType:3];
//    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
//
//        if (!(isDir && existed)) {
//            // 在Document目录下创建一个archiver目录
//            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//    }
//    NSString*name = [NSString stringWithFormat:@"chat%@.mp4",[CyrusTools getCurrentIMServerTime13]];
//    NSString*imagesize = [NSString stringWithFormat:@"_%f_%f",image.size.width,image.size.height];
//    NSString*imageName = [NSString stringWithFormat:@"chat%@%@.data",[CyrusTools getCurrentIMServerTime13],imagesize];
//    NSString *filePath2  = [NSString stringWithFormat:@"%@/%@",filePath,name]; // 保存文件的名称
//    NSString *imageFilePath  = [NSString stringWithFormat:@"%@/%@",filePath,imageName];
//    BOOL result =[dataVoido writeToFile:filePath2   atomically:YES]; // 保存成功会返回YES
//    if (result == YES) {
//        DLog(@"保存成功");
//    }
//    BOOL imageResult =[UIImagePNGRepresentation(image) writeToFile:imageFilePath   atomically:YES]; // 保存成功会返回YES
//    if (result == YES) {
//        DLog(@"保存成功");
//    }
//    sucBlock(imageResult,result,imageName,name);
//}

//-(NSString*)saveImage:(UIImage *)image {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    BOOL isDir = NO;
//    NSString *filePath = [self getChat:@"" withType:1];
//    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
//
//    if (!(isDir && existed)) {
//        // 在Document目录下创建一个archiver目录
//        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//          }
//    NSString*name = [NSString stringWithFormat:@"chat%@_%lf_%lf.png",[CyrusTools getCurrentIMServerTime13],image.size.width,image.size.height];
//    NSString *filePath2  = [NSString stringWithFormat:@"%@/%@",filePath,name]; // 保存文件的名称
//
//    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath2   atomically:YES]; // 保存成功会返回YES
//    if (result == YES) {
//        DLog(@"保存成功");
//    }
//    return name;
//}
//-(NSString*)getChat:(NSString*)name withType:(int)chatType{
//    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString* nameF = @"";
//    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:nameF];
//    if (chatType == 1) {
//        nameF = @"chatPic1";
//    }else if(chatType == 2){
//        nameF = @"chatVoice";
//    }else if (chatType == 3){
//       nameF = @"chatVoido";
//    }else if (chatType==4){
//        name= [name stringByReplacingOccurrencesOfString:@"://" withString:@""];
//        name= [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
//    }
//
//
//    if (name.length>0) {
//         NSString *filePath2  = [NSString stringWithFormat:@"%@/%@",filePath,name];
//        return filePath2;
//    }
//    return filePath;
//
//}
@end
