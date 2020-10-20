//
//  DFBaseStorageService.h
//  DFChatStorage
//
//  Created by Allen Zhong on 15/5/1.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFDatabaseHelper.h"



@interface DFBaseStorageService : NSObject

-(NSString *) getDatabaseName;

-(void) openSession;
-(void) closeSession;

-(BOOL) executeUpdate:(NSString *) sql  params:(NSDictionary *) params;
-(FMResultSet *) executeQuery:(NSString *) sql  params:(NSDictionary *) params;

@end
