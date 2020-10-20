//
//  XMGLuckyBGView.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLuckyBGView.h"

@implementation XMGLuckyBGView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
  UIImage *image =  [UIImage imageNamed:@"luck_entry_background"];
    
    [image drawInRect:rect];
    
}


@end
