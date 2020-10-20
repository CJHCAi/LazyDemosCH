//
//  NSMutableDictionary+JSON.m
//  DFCommon
//
//  Created by Allen Zhong on 15/4/12.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "NSDictionary+JSON.h"


@implementation NSDictionary (JSON)

+(NSString*) dic2jsonString:(NSDictionary *) dic
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+(NSData *) string2nsdata:(NSString *) string
{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData *) dic2jsonData:(NSDictionary *) dic
{
    return [self string2nsdata:[self dic2jsonString:dic]];
}


+(NSDictionary *)jsonString2Dic:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSDictionary *)jsonData2Dic:(NSData *)data
{
    return [self jsonString2Dic:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}
@end
