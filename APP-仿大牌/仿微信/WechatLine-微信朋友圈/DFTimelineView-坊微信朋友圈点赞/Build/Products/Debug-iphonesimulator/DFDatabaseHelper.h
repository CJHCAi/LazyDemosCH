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
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com