//
//  UILabel+stringFrame.m
//  计算文本的文字的宽高
//
//  Created by AS150701001 on 16/4/20.
//  Copyright © 2016年 lele. All rights reserved.
//

#import "UILabel+stringFrame.h"

@implementation UILabel (stringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    self.numberOfLines=0;
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end
