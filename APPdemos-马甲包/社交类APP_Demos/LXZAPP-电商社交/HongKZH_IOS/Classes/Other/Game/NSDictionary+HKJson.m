//
//  NSDictionary+HKJson.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NSDictionary+HKJson.h"

@implementation NSDictionary (HKJson)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
