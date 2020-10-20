//
//  NSString+addLineBreakOrSpace.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSString+addLineBreakOrSpace.h"

@implementation NSString (addLineBreakOrSpace)
+(NSMutableString *)addLineBreaks:(NSString *)str{
    NSMutableString *lineBreaksStr = [NSMutableString string];
    for (int i = 0; i < str.length; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i,1)];
        NSString *subStr1 = [subStr stringByAppendingString:@"\n"];
        [lineBreaksStr appendString:subStr1];
    }
    return [lineBreaksStr copy];
}

+(NSMutableString *)addSpace:(NSString *)str withNumber:(NSInteger)num{
    NSMutableString *SpaceStr = [NSMutableString string];
    for (int i = 0; i < str.length; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i,1)];
        for (int j = 0; j < num; j++) {
            subStr = [subStr stringByAppendingString:@" "];
        }
        [SpaceStr appendString:subStr];
    }
    return SpaceStr;

}
@end
