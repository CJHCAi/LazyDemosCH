//
//  HKDateTool.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDateTool.h"

@implementation HKDateTool
/*!
 *  获取当前服务器时间
 */
//+ (NSDate *)getCurrentIMServerTime {
//    // 当前系统的时间
//    NSDate *date = [NSDate date];
//    
//    // 当前系统的时间戳
//    NSTimeInterval intervalNow = [date timeIntervalSince1970];
//    
//    // 时间戳的差值
//    int diff = [[[NSUserDefaults standardUserDefaults] objectForKey:USERTIMEDIFFERENCE] intValue];
//    
//    // 时间戳的差值 + 当前时间戳 = 服务器时间的时间戳
//    int intervalServer = intervalNow + diff;
//    
//    // 真实的服务器时间
//    NSDate *servertime = [[NSDate alloc] initWithTimeIntervalSince1970:intervalServer];
//    return servertime;
//}
/*!
 *  获取当前服务器时间
 */
+ (NSString*)getCurrentIMServerTime13 {
    // 当前系统的时间
    NSDate *date = [NSDate date];
    
    
    NSString *timeSp = [NSString stringWithFormat:@"%ff", [date timeIntervalSince1970]];
    
    // 时间戳的差值 + 当前时间戳 = 服务器时间的时间戳
    return timeSp;
}
+ (int)getCurrentTime13 {
    // 当前系统的时间
    NSDate *date = [NSDate date];
    
    
    int timeSp=  [date timeIntervalSince1970];
    
    // 时间戳的差值 + 当前时间戳 = 服务器时间的时间戳
    return timeSp;
}
@end
