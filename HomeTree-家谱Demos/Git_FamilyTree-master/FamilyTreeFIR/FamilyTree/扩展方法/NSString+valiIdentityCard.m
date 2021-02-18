//
//  NSString+valiIdentityCard.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSString+valiIdentityCard.h"

@implementation NSString (valiIdentityCard)
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
@end
