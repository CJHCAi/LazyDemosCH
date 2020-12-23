//
//  savehistoryData.h
//  Calculator1
//
//  Created by ruru on 16/6/21.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface savehistoryData : NSObject

@property (strong, nonatomic) NSString *test;
@property (strong,nonatomic)FMDatabase *db;


+(void)historyAdd:(NSString *)curretTime beforeNum:(NSString *)beforeNub operationType:(NSString *)operationType CurrentNub:(NSString *)currentNub result:(NSString *)resultdate;
+(NSMutableArray *)seachHistoryData;
+(void)deleteAllHistory;
+(void)deleteSelectHistory:(NSString *)IDStr;
@end
