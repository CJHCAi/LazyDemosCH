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
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com