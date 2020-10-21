//
//  OverlayView.m
//  ImageCropper
//
//  Created by Zhuochenming on 16/1/8.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import "OverlayView.h"

static CGFloat const SIZE = 30.0;

@implementation OverlayView

- (NSMutableArray *)rectArray {
    if (_rectArray == nil) {
        _rectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _rectArray;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 绘制
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(contextRef, YES);
    
    // Fill black
    CGContextSetFillColorWithColor(contextRef, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    CGContextAddRect(contextRef, CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    CGContextFillPath(contextRef);
    
    //透明区域
    for (int i = 0; i < self.rectArray.count; i++) {
        CGRect storeRect = self.clearRect;
        self.clearRect = CGRectFromString(self.rectArray[i]);
        [self createClearRectWithContextRef:contextRef];
        self.clearRect = storeRect;
    }
    
    [self panToTopRectWithContextRef:contextRef];
}

- (CGRect)edgeRect {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      CGRectGetWidth(self.clearRect) + SIZE,
                      CGRectGetHeight(self.clearRect) + SIZE);
}

- (CGRect)topLeftCorner {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)topRightCorner {
    return CGRectMake(CGRectGetMaxX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomLeftCorner {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMaxY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomRightCorner {
    return CGRectMake(CGRectGetMaxX(self.clearRect) - SIZE / 2,
                      CGRectGetMaxY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)topEdgeRect {
    return CGRectMake(CGRectGetMinX(self.edgeRect) + SIZE,
                      CGRectGetMinY(self.edgeRect),
                      CGRectGetWidth(self.edgeRect) - SIZE * 2, SIZE);
}

- (CGRect)rightEdgeRect {
    return CGRectMake(CGRectGetMaxX(self.edgeRect) - SIZE,
                      CGRectGetMinY(self.edgeRect) + SIZE,
                      SIZE, CGRectGetHeight(self.edgeRect) - SIZE * 2);
}

- (CGRect)bottomEdgeRect {
    return CGRectMake(CGRectGetMinX(self.edgeRect) + SIZE,
                      CGRectGetMaxY(self.edgeRect) - SIZE,
                      CGRectGetWidth(self.edgeRect) - SIZE * 2, SIZE);
}

- (CGRect)leftEdgeRect {
    return CGRectMake(CGRectGetMinX(self.edgeRect),
                      CGRectGetMinY(self.edgeRect) + SIZE,
                      SIZE, CGRectGetHeight(self.edgeRect) - SIZE * 2);
}

- (BOOL)isEdgeContainsPoint:(CGPoint)point {
    return CGRectContainsPoint(self.topEdgeRect, point)
    || CGRectContainsPoint(self.rightEdgeRect, point)
    || CGRectContainsPoint(self.bottomEdgeRect, point)
    || CGRectContainsPoint(self.leftEdgeRect, point);
}

- (BOOL)isCornerContainsPoint:(CGPoint)point {
    return CGRectContainsPoint(self.topLeftCorner, point)
    || CGRectContainsPoint(self.topRightCorner, point)
    || CGRectContainsPoint(self.bottomLeftCorner, point)
    || CGRectContainsPoint(self.bottomRightCorner, point);
}

- (BOOL)isInRectPoint:(CGPoint)point {
    CGFloat x = self.clearRect.origin.x + 10;
    CGFloat xw = x + self.clearRect.size.width - 30;
    
    CGFloat y = self.clearRect.origin.y + 10;
    CGFloat yh = y + self.clearRect.size.height - 30;

    if (point.x > x && point.x < xw && point.y > y && point.y < yh) {
        return YES;
    }
    return NO;
}

#pragma mark - 拐角
- (void)createCornerWithContextRef:(CGContextRef)contextRef {
    CGContextSetFillColorWithColor(contextRef, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
    
    CGContextSaveGState(contextRef);
    CGContextSetShouldAntialias(contextRef, NO);
    
    CGFloat margin = SIZE / 4;
    
    // Clear outside
    CGRect clip = CGRectOffset(self.clearRect, -margin * 0.4f, -margin * 0.4f);
    clip.size.width += margin * 0.8f, clip.size.height += margin * 0.8f;
    CGContextClipToRect(contextRef, clip);
    
    CGContextAddRect(contextRef, self.topLeftCorner);
    CGContextAddRect(contextRef, self.topRightCorner);
    CGContextAddRect(contextRef, self.bottomLeftCorner);
    CGContextAddRect(contextRef, self.bottomRightCorner);
    CGContextFillPath(contextRef);
    
    // Clear inside
    margin = SIZE / 8;
    clip = CGRectOffset(self.clearRect, margin, margin);
    clip.size.width -= margin * 2, clip.size.height -= margin * 2;
    CGContextClearRect(contextRef, clip);
    CGContextRestoreGState(contextRef);
}

#pragma - 网格
- (void)createGridWithContextRef:(CGContextRef)contextRef {
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(contextRef, 0.5);
    CGContextAddRect(contextRef, self.clearRect);
    
    CGPoint from, to;
    //垂直线
    for (int i = 1; i < 3; i++) {
        from = CGPointMake(self.clearRect.origin.x + self.clearRect.size.width / 3.0f * i, self.clearRect.origin.y);
        to = CGPointMake(from.x, CGRectGetMaxY(self.clearRect));
        CGContextMoveToPoint(contextRef, from.x, from.y);
        CGContextAddLineToPoint(contextRef, to.x, to.y);
    }
    
    //水平线
    for (int i = 1; i < 3; i++) {
        from = CGPointMake(self.clearRect.origin.x, self.clearRect.origin.y + self.clearRect.size.height / 3.0f * i);
        to = CGPointMake(CGRectGetMaxX(self.clearRect), from.y);
        CGContextMoveToPoint(contextRef, from.x, from.y);
        CGContextAddLineToPoint(contextRef, to.x, to.y);
    }
}

#pragma mark - 透明区域
- (void)createClearRectWithContextRef:(CGContextRef)contextRef {
    CGContextClearRect(contextRef, self.clearRect);
    CGContextFillPath(contextRef);
    [self createCornerWithContextRef:contextRef];
    [self createGridWithContextRef:contextRef];
    CGContextStrokePath(contextRef);
}

#pragma mark - 焦点透明区域
- (void)panToTopRectWithContextRef:(CGContextRef)contextRef {
    CGRect storeRect = self.clearRect;
    self.clearRect = CGRectFromString(self.rectArray[_whichRect]);
    [self createClearRectWithContextRef:contextRef];
    self.clearRect = storeRect;
}

@end
