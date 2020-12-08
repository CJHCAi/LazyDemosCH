//
//  YTSqliteTool.h
//  
//
//  Created by Mac on 16/5/3.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTSqliteTool : NSObject
// 插入。删除，修改
+ (void)execWithSql:(NSString *)sql;
+ (NSMutableArray *)selectWithSql:(NSString *)sql;

+ (NSMutableArray *)selectChaptersWithSql:(NSString *)sql;

@end
