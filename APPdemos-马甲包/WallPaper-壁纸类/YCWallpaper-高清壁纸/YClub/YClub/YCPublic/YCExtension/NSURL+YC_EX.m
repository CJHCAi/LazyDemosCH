//
//  NSURL+YC_EX.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "NSURL+YC_EX.h"

@implementation NSURL (YC_EX)

+ (NSURL *)safeURLWithString:(NSString *)URLString
{
    if (kStringIsEmpty(URLString)) {
        return nil;
    }
    NSString *encodeStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:encodeStr];
}
@end
