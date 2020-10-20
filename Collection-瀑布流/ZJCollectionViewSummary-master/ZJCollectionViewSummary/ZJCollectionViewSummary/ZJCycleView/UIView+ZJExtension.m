//
//  UIView+ZJExtension.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/13.
//  Copyright © 2018年 James. All rights reserved.
//

#import "UIView+ZJExtension.h"

@implementation UIView (ZJExtension)

- (CGFloat)zj_height
{
    return self.frame.size.height;
}

- (void)setZj_height:(CGFloat)zj_height
{
    CGRect temp = self.frame;
    temp.size.height = zj_height;
    self.frame = temp;
}

- (CGFloat)zj_width
{
    return self.frame.size.width;
}

- (void)setZj_width:(CGFloat)zj_width
{
    CGRect temp = self.frame;
    temp.size.width = zj_width;
    self.frame = temp;
}


- (CGFloat)zj_y
{
    return self.frame.origin.y;
}

- (void)setZj_y:(CGFloat)zj_y
{
    CGRect temp = self.frame;
    temp.origin.y = zj_y;
    self.frame = temp;
}

- (CGFloat)zj_x
{
    return self.frame.origin.x;
}

- (void)setZj_x:(CGFloat)zj_x
{
    CGRect temp = self.frame;
    temp.origin.x = zj_x;
    self.frame = temp;
}

@end
