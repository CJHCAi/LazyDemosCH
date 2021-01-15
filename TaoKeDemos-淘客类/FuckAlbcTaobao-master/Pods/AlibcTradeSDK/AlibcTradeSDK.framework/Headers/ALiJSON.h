/*
 * ALiJSON.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface ALiJSON : NSObject

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz;
+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData;
+ (NSArray *)jsonDataToArray:(NSData *)jsonData;
+ (NSData *)objectToJsonData:(id)object;


+ (id)jsonStringToObject:(NSString *)jsonString class:(Class)clazz;
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;
+ (NSArray *)jsonStringToArray:(NSString *)jsonString;
+ (NSString *)objectToJsonString:(id)object;

+ (id)dictionaryToClass:(NSDictionary *)dictionary class:(Class)clazz;
+ (id)asJsonableObject:(id)object;

/**
 * 修复直接将 JSON 字符串作为 js 使用时，\u2028 和 \u2029 导致 JS 报错的问题。
 *
 * 一份额外的列表，尚未决定是否全部替换 [\u0000-\u001f\u007f-\u009f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]
 */
+ (NSString *)fixJSON2JSBug:(NSString *)json;
@end
