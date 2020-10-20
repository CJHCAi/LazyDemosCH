//
//  DFDatabaseHelper.m
//  DFChatStorage
//
//  Created by Allen Zhong on 15/5/1.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFDatabaseHelper.h"


@implementation DFDatabaseHelper

static NSMutableDictionary *_dic;

+(FMDatabase *) sharedDatabase:(NSString *) name
{
    @synchronized(self){
        
        if (_dic == nil) {
            _dic = [NSMutableDictionary dictionary];
        }
        
        FMDatabase *db = [_dic objectForKey:name];

        if (db == nil) {
            NSString *path = [NSString stringWithFormat:@"%@/%@.db", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],name];
            db = [FMDatabase databaseWithPath:path];
            [_dic setObject:db forKey:name];
        }
    }
    return [_dic objectForKey:name];
}


@end
