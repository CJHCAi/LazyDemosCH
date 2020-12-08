//
//  ARSqliteTool.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARSqliteTool : NSObject

+ (void)execWithSql:(NSString *)sql;
+ (NSMutableArray *)selectWithSql:(NSString *)sql;

+ (NSMutableArray *)selectChaptersWithSql:(NSString *)sql;

@end
