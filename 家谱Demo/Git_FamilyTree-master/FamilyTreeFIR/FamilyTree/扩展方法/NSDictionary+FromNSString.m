//
//  NSDictionary+FromNSString.m
//  测试接口
//
//  Created by 姚珉 on 16/5/25.
//  Copyright © 2016年 yaomin. All rights reserved.
//

#import "NSDictionary+FromNSString.h"

@implementation NSDictionary (FromNSString)
+(NSDictionary *)DicWithString:(NSString *)str{
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dic;
}
@end

