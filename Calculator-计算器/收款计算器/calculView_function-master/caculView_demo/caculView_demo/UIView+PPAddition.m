//
//  UIView+PPAddition.m
//  amezMall_New
//
//  Created by Liao PanPan on 2017/4/5.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import "UIView+PPAddition.h"

@implementation UIView (PPAddition)


- (CGFloat)PP_left {
    return self.frame.origin.x;
}

- (void)setPP_left:(CGFloat)PP_left {
    CGRect frame = self.frame;
    frame.origin.x = PP_left;
    self.frame = frame;
}

- (CGFloat)PP_top {
    return self.frame.origin.y;
}

- (void)setPP_top:(CGFloat)PP_top{
    CGRect frame = self.frame;
    frame.origin.y = PP_top;
    self.frame = frame;
}

- (CGFloat)PP_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPP_right:(CGFloat)PP_right {
    CGRect frame = self.frame;
    frame.origin.x = PP_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)PP_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPP_bottom:(CGFloat)PP_bottom{
    CGRect frame = self.frame;
    frame.origin.y = PP_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)PP_width {
    return self.frame.size.width;
}

- (void)setPP_width:(CGFloat)PP_width {
    CGRect frame = self.frame;
    frame.size.width = PP_width;
    self.frame = frame;
}

- (CGFloat)PP_height {
    return self.frame.size.height;
}

- (void)setPP_height:(CGFloat)PP_height {
    CGRect frame = self.frame;
    frame.size.height = PP_height;
    self.frame = frame;
}

- (CGFloat)PP_centerX {
    return self.center.x;
}

- (void)setPP_centerX:(CGFloat)PP_centerX {
    self.center = CGPointMake(PP_centerX, self.center.y);
}

- (CGFloat)PP_centerY {
    return self.center.y;
}

- (void)setPP_centerY:(CGFloat)PP_centerY {
    self.center = CGPointMake(self.center.x, PP_centerY);
}

- (CGPoint)PP_origin {
    return self.frame.origin;
}

- (void)setPP_origin:(CGPoint)PP_origin {
    CGRect frame = self.frame;
    frame.origin = PP_origin;
    self.frame = frame;
}

- (CGSize)PP_size {
    return self.frame.size;
}

- (void)setPP_size:(CGSize)PP_size {
    CGRect frame = self.frame;
    frame.size = PP_size;
    self.frame = frame;
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

