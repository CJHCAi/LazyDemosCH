//
//  NSString+SXTStringHelpe.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "NSString+SXTStringHelpe.h"

@implementation NSString (SXTStringHelpe)

+ (CGFloat)returnLabelTextHeight:(NSString *)text
                            width:(CGFloat)width
                        fontSize:(UIFont *)font{
    CGSize textSize = CGSizeMake(width, MAXFLOAT);
    CGFloat height = [text boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}

@end
