//
//  UILabel+AdjustFont.m
//  XMNSizeTextExample
//
//  Created by shscce on 15/11/26.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "UILabel+AdjustFont.h"

@implementation UILabel (AdjustFont)


- (void)adjustFont
{
    for (int i = 100; i>=16; i -- )
    {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:i];
        
        CGRect rectSize = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        if (rectSize.size.width <= self.frame.size.width) {
            self.font = [UIFont fontWithName:self.font.fontName size:i];
            break;
        }
    }
}

@end
