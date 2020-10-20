//
//  UIView+extend.m
//  Pods-s_ios_categories_Example
//
//  Created by hs on 2018/3/20.
//

#import "UIView+extend.h"

@implementation UIView (extend)

- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
