//
//  NSString+JSON.h
//  loveChinese
//
//  Created by 刘昊 on 16/6/3.
//  Copyright © 2016年 AYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

//数组转JSON 字符
+(NSString *)arrayToString:(NSArray *)array;
//字典转JSON 字符
+(NSString *)dicToString:(NSDictionary *)jsonDic;
//字符转字典
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
@end
