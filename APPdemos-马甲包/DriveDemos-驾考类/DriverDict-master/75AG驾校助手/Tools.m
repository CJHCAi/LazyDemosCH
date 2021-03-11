//
//  Tools.m
//  75AG驾校助手
//
//  Created by again on 16/4/8.
//  Copyright © 2016年 again. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+ (NSArray *)getAnswerWithString:(NSString *)str
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *arr = [str componentsSeparatedByString:@"<BR>"];
    [array addObject:arr[0]];
    for (int i = 0; i < 4; i++) {
        [array addObject:[arr[i + 1] substringFromIndex:2]];
    }
    return array;
}
+ (CGSize)getSizeWithString:(NSString *)str with:(UIFont *)font withSize:(CGSize)size
{
    CGSize newSize = [str sizeWithFont:font constrainedToSize:size];
    return newSize;
}
@end
