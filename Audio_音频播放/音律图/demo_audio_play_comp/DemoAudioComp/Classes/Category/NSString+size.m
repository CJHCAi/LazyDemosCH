//
//  NSString+size.m
//  DemoMoment
//
//  Created by hs on 2018/6/11.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)

- (CGSize)textSizeWithWidth:(CGFloat)width font:(UIFont *)font {
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font
                                 };
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size;
}

@end
