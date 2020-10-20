//
//  IgnoreHeaderTouchTableView.m
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/9.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "IgnoreHeaderTouchTableView.h"

@implementation IgnoreHeaderTouchTableView

//忽略tab的头部点击事件
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

@end
