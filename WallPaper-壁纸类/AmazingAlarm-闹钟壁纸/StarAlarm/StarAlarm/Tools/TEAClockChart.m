//
//  TEAClockChart.m
//  Xhacker
//
//  Created by Xhacker on 2013-07-27.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "TEAClockChart.h"
#import "TEATimeRange.h"

@implementation TEAClockChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self loadDefaults];
    }
    return self;
}

- (void)loadDefaults
{
    self.opaque = NO;
    
    _fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _strokeColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"x : %f, y: %f", rect.size.width, rect.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2;
    NSLog(@"radius: %f", radius);
    CGFloat originX = CGRectGetWidth(rect) / 2;
    CGFloat originY = CGRectGetHeight(rect) / 2;
        

    [self.data enumerateObjectsUsingBlock:^(TEATimeRange *timeRange, NSUInteger idx, BOOL *stop) {

    }];
    
    // draw ring
    CGContextSetLineWidth(context, 2);
    [self.strokeColor setStroke];
//    CGFloat margin = 0.1;
    
    CGContextAddArc(context, self.center.x, self.center.y, rect.size.width / 2 - 10, 0, M_PI * 2, 1);

    
     [self.fillColor setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw scales
    CGContextSetLineWidth(context, 1);
    for (NSInteger i = 0; i < 12; i += 1) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, originX, originY);
        CGContextRotateCTM(context, i * M_PI / 6);
        CGContextMoveToPoint(context, 0, radius);
        CGFloat lengthFactor = i % 6 == 0 ? 0.08 : 0.04;
        CGContextAddLineToPoint(context, 0, radius - radius * lengthFactor);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
   
    
}

#pragma mark Setters

- (void)setData:(NSArray *)data
{
    _data = data;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

@end
