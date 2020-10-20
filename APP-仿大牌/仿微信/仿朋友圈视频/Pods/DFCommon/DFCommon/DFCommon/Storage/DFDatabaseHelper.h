//
//  DFDatabaseHelper.h
//  DFChatStorage
//
//  Created by Allen Zhong on 15/5/1.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@interface DFDatabaseHelper : NSObject

+(FMDatabase *) sharedDatabase:(NSString *) name;

@end
