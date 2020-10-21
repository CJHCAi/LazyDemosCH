//
//  FrameMaskingLayer.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/26.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "FrameMaskingLayer.h"


@interface FrameMaskingLayer()
@property (strong, nonatomic) UIBezierPath *removePath;
@end

@implementation FrameMaskingLayer
- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *pathOne = [UIBezierPath bezierPathWithRect:self.bounds];
    if (self.removePath != nil) {
       [pathOne appendPath:[_removePath bezierPathByReversingPath]];
    }
    CGContextAddPath(ctx, pathOne.CGPath);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
    CGContextFillPath(ctx);
}


- (void)addRemovePath:(UIBezierPath *)removePath {
    self.removePath = removePath;
    [self setNeedsDisplay];
}

@end
