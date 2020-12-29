//
//  DatabaseToll.h
//  HandsUp
//
//  Created by wanghui on 2018/4/18.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseToll : NSObject
SISingletonH(DatabaseToll)
+(BOOL)setUpDatabase;
@property (nonatomic, strong) FMDatabaseQueue *queue  ;
@property (nonatomic, strong)FMDatabase *db ;
- (BOOL)executeWithDB:(FMDatabase*)db andUpdate:(NSString*)sql, ...;
- (BOOL)executeWithUpdate:(NSString*)sql, ...;
- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block ;
-(FMResultSet*)executeQuery:(NSString*)sql,...;
-(FMResultSet*)executeQueryDB:(FMDatabase*)db sqlString:(NSString*)sql,...;
//-(NSString*)saveImage:(UIImage *)image;
//-(NSString*)saveVoide:(NSData *)dataVoide;
//-(void)saveVoideo:(NSData *)dataVoido andImage:(UIImage*)image sucBlack:(void(^)(BOOL isImageSuc,BOOL isVoideoSuc, NSString*imageName,NSString*name ))sucBlock ;
//-(NSString*)getChat:(NSString*)name withType:(int)chatType;
@end
