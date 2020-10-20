//
//  NSString+YJudgeValidateNumber.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSString+YJudgeValidateNumber.h"

@implementation NSString (YJudgeValidateNumber)
+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
