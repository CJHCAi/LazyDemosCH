//
//  UILabel+CCPLabel.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/26.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "UILabel+CCPLabel.h"

@implementation UILabel (CCPLabel)

- (CGFloat)widthBy:(CGFloat)h {
    UIFont *font = self.font;
    NSDictionary *attri = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(1000, h) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attri context:nil];
    return rect.size.width;
}

@end
