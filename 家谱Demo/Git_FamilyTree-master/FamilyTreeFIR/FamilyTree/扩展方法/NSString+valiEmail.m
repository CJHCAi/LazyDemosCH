//
//  NSString+valiEmail.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSString+valiEmail.h"

@implementation NSString (valiEmail)
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
