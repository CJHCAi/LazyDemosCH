//
//  NSString+getLineSpaceStr.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/22.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSString+getLineSpaceStr.h"

@implementation NSString (getLineSpaceStr)
+(NSMutableAttributedString *)getLineSpaceStr:(NSString *)str{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return attributedString;
}
@end
