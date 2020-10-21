//
//  NSString+Size.m
//  CustomTabbar
//
//  Created by CDchen on 2017/9/4.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)
- (CGSize)stringSizeWithContentSize:(CGSize)contentSize font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [self boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}
@end
