//
//  SFUIScrollView.m
//  SportForum
//
//  Created by liyuan on 12/22/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "SFUIScrollView.h"

@implementation SFUIScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* result = [super hitTest:point withEvent:event];
    
    if ([result isKindOfClass:[UITableView class]] || [result.superview isKindOfClass:[UITableViewCell class]])
    {
        self.scrollEnabled = NO;
    }
    else
    {
        self.scrollEnabled = YES;
    }
    
    return result;
}

@end
