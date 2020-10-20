//
//  JKDataBase.h
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface JKDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

/** 单例，用来获取FMDatabaseQueue */
+ (JKDBHelper *)shareInstance;

/** 切换数据库 */
- (BOOL)updateDBPath;

/** 获取数据库路径 */
+ (NSString *)dbPath;

@end
