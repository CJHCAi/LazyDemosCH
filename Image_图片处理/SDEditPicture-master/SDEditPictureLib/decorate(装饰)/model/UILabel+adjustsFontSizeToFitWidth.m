//
//  UILabel+adjustsFontSizeToFitWidth.m
//  NestHouse
//
//  Created by shansander on 2017/5/24.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "UILabel+adjustsFontSizeToFitWidth.h"
@implementation UILabel (adjustsFontSizeToFitWidth)

- (NSInteger)getFontSize
{
    NSInteger min_font_size = 10;
    
    NSInteger max_font_size = 20;
    NSInteger current_font_size = min_font_size;
    
    for (NSInteger i  = min_font_size; i < max_font_size; i ++) {
        
        UIFont * font = [UIFont systemFontOfSize:i];
        
        CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:font}];
        
        if (size.width < self.frame.size.width) {
            current_font_size = i;
        }else{
            break;
        }
    }
    
    return current_font_size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
