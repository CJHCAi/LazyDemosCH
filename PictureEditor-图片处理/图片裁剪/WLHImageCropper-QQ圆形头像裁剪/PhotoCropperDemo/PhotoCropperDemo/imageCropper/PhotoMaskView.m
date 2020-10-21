//
//  PhotoMaskView.m
//  incup
//
//  Created by wanglh on 15/5/21.
//  Copyright (c) 2015年 Kule Yang. All rights reserved.
//
//屏幕宽和高
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#import "PhotoMaskView.h"
//#define kCircleW  (SCREEN_WIDTH -80)     // 圆的直径
//#define kCircleH  (SCREEN_WIDTH -80)     // 圆的直径
@implementation PhotoMaskView{
    CGRect _squareRect;   // 外切正方形
    CGFloat _cropWidth;
    CGFloat _cropHeight;
}

-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)cropWidth height:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mode = PhotoMaskViewModeCircle;
        self.backgroundColor = [UIColor clearColor];
        _cropWidth = cropWidth;
        _cropHeight = height;
        self.isDark = NO;
        self.lineColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.mode == PhotoMaskViewModeCircle) {
        
     [self crop:rect];
    }else{
        [self crop2:rect];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutScrollViewWithRect:)]) {
        [self.delegate layoutScrollViewWithRect:_squareRect];
    }
}

-(void)crop2:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
   _squareRect = CGRectMake((width - _cropWidth) / 2, (height - _cropHeight) / 2, _cropWidth, _cropHeight);
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:_squareRect];
    UIBezierPath *maskBezierPath = [UIBezierPath bezierPathWithRect:rect];
    [maskBezierPath appendPath:squarePath];
    maskBezierPath.usesEvenOddFillRule = YES;
    [maskBezierPath fill];
    CGContextSetLineWidth(contextRef, 2);
    if (self.isDark) {
        CGFloat length[2] = {5,5};
        CGContextSetLineDash(contextRef, 0, length, 2);
    }
    CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
    [squarePath stroke];
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}
-(void)crop:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    _squareRect = CGRectMake((width - _cropWidth) / 2, (height - _cropWidth) / 2, _cropWidth, _cropWidth);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:_squareRect];
    UIBezierPath *maskBezierPath = [UIBezierPath bezierPathWithRect:rect];
    [maskBezierPath appendPath:circlePath];
    maskBezierPath.usesEvenOddFillRule = YES;
    [maskBezierPath fill];
    CGContextSetLineWidth(contextRef, 2);
    if (self.isDark) {
        CGFloat length[2] = {5,5};
      CGContextSetLineDash(contextRef, 0, length, 2);
    }
    CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
  
    [circlePath stroke];
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}
@end
