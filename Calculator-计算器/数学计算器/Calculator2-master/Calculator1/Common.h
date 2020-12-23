//
//  Common.h
//  Calculator1
//
//  Created by ruru on 16/4/26.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface Common : NSObject


+(void)configSet:(NSString *)key value:(id)value;//声明存数据函数
+(id)configGet:(NSString *)key;//声明读取数据函数
+(id)configGetClcikMusic:(NSString *)key;
+(void)configMusicOnSet:(BOOL)on;
+(BOOL)configMusicOnGet;
+(id)configGetTheme:(NSString *)key;
+(void)writeImage:(UIImage *)image toFileAtPath:(NSString *)aPath;




@end
