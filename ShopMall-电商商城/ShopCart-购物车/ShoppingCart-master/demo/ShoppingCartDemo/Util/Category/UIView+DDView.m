//
//  UIView+Helper.m
//  DingDing
//
//  Created by Dry on 16/5/30.
//  Copyright © 2016年 Cstorm. All rights reserved.
//

#import "UIView+DDView.h"

@implementation UIView (DDView)

@dynamic origin_x;
@dynamic origin_y;
@dynamic width;
@dynamic height;
@dynamic toLeftMargin;
@dynamic toTopMargin;

#pragma mark get/set

- (CGFloat)origin_x
{
    return self.frame.origin.x;
}
- (CGFloat)origin_y
{
    return self.frame.origin.y;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)toLeftMargin
{
    return self.frame.origin.x+self.frame.size.width;
}
- (CGFloat)toTopMargin
{
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{   //重置view的宽
    if (width != self.frame.size.width) {
        CGRect newframe = self.frame;
        newframe.size.width = width;
        self.frame = newframe;
    }
}
- (void)setHeight:(CGFloat)height
{   //重置view的高
    if (height != self.frame.size.height)
    {
        CGRect newframe = self.frame;
        newframe.size.height = height;
        self.frame = newframe;
    }
}
- (void)setOrigin_x:(CGFloat)origin_x
{   //重设view的origin_x
    if (origin_x != self.frame.origin.x)
    {
        CGRect newframe = self.frame;
        newframe.origin.x = origin_x;
        self.frame = newframe;
    }
}
- (void)setOrigin_y:(CGFloat)origin_y
{   //重设view的origin_y
    if (origin_y != self.frame.origin.y)
    {
        CGRect newframe = self.frame;
        newframe.origin.y = origin_y;
        self.frame = newframe;
    }
}

@end
