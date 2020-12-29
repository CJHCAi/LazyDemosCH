//
//  UIView+FrameGeometry.m
//  XiYou_IOS
//
//  Created by regan on 15/11/19.
//  Copyright © 2015年 regan. All rights reserved.
//

#import "UIView+FrameGeometry.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}
@end

@implementation UIView (Uitls)

- (void)setBorderWidth:(CGFloat)with
{
    self.layer.borderWidth = with;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
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

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setX:(CGFloat)x
{
    self.frame = (CGRect){
        .origin = {.x = x, .y = self.y},
        .size   = {.width = self.width, .height = self.height}
    };
}

- (void)setY:(CGFloat)y
{
    self.frame = (CGRect){
        .origin = {.x = self.x, .y = y},
        .size   = {.width = self.width, .height = self.height}
    };
}

- (void)setWidth:(CGFloat)width
{
    self.frame = (CGRect){
        .origin = {.x = self.x, .y = self.y},
        .size   = {.width = width, .height = self.height}
    };
}

- (void)setHeight:(CGFloat)height
{
    self.frame = (CGRect){
        .origin = {.x = self.x, .y = self.y},
        .size   = {.width = self.width, .height = height}
    };
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = (CGRect){
        .origin = {.x = origin.x, .y = origin.y},
        .size   = {.width = self.width, .height = self.height}
    };
}

- (void)setSize:(CGSize)size
{
    self.frame = (CGRect){
        .origin = {.x = self.x, .y = self.y},
        .size   = {.width = size.width, .height = size.height}
    };
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

@end

@implementation UIView(FindFirstResponder)

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}

@end