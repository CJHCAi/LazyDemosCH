//
//  HK_Header.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_Header.h"

@implementation HK_Header
+(NSMutableDictionary*)request_Header
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"ios" forKey:@"platform"];
    [dict setObject:@"944442222" forKey:@"channel"];
    [dict setObject:@"2.0.0" forKey:@"version"];
    return dict;
}
@end
