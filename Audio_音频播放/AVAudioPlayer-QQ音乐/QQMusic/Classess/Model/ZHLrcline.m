//
//  ZHLrcline.m
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import "ZHLrcline.h"

@implementation ZHLrcline

- (instancetype)initWithLrcString:(NSString *)lrcString
{
    if (self = [super init]) {
        // [01:47.46]宁愿用这一生等你发现
        self.text = [[lrcString componentsSeparatedByString:@"]"] lastObject];
        // [01:47.46
        NSString *timeString = [[[lrcString componentsSeparatedByString:@"]"] firstObject] substringFromIndex:1];
        self.time = [self timeWithString:timeString];
    }
    return self;
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 01:47.46
    NSInteger min = [[[timeString componentsSeparatedByString:@":"] firstObject] integerValue];
    // 47.46
    NSInteger second = [[[[[timeString componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] firstObject] integerValue];
    NSInteger haomiao = [[[[[timeString componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] lastObject] integerValue];
    
    return min * 60 + second + haomiao * 0.01;
}

+ (instancetype)lrclineWithLrcString:(NSString *)lrcString
{
    return [[self alloc] initWithLrcString:lrcString];
}
@end
