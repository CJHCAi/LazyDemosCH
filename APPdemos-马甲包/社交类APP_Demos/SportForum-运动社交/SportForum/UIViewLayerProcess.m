//
//  UIViewLayerProcess.m
//  SportForum
//
//  Created by liyuan on 6/23/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "UIViewLayerProcess.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@implementation UIViewLayerProcess
{
    CAShapeLayer *_progressLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProcessLayer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProcessLayer];
    }
    return self;
}


#pragma mark - Internal methods

+ (CAShapeLayer *)LayerWithCircleCenter:(CGPoint)point
                                 radius:(CGFloat)radius
                             startAngle:(CGFloat)startAngle
                               endAngle:(CGFloat)endAngle
                              clockwise:(BOOL)clockwise
                        lineDashPattern:(NSArray *)lineDashPattern
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:clockwise];
    
    // 获取path
    layer.path = path.CGPath;
    layer.position = point;
    
    // 设置填充颜色为透明
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 获取曲线分段的方式
    if (lineDashPattern)
    {
        layer.lineDashPattern = lineDashPattern;
    }
    
    return layer;
}

-(void)initProcessLayer
{
    CGRect rect = CGRectMake(0,0,CGRectGetWidth(self.bounds) - 2 * (CGRectGetWidth(self.bounds) * 0.09), CGRectGetHeight(self.bounds) - 2 * (CGRectGetWidth(self.bounds) * 0.09));
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.bounds = rect;
    _progressLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor blueColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineJoin = kCALineJoinRound;
    _progressLayer.lineWidth = 0.116 * CGRectGetWidth(self.bounds);
    _progressLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
    _progressLayer.strokeEnd = 0.0;
    
    /*CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x5bf5ff) CGColor],(id)[UIColorFromRGB(0x66ffbc) CGColor],(id)[UIColorFromRGB(0xfdff71) CGColor],(id)[UIColorFromRGB(0xffac74) CGColor],(id)[UIColorFromRGB(0xfd80db) CGColor],(id)[UIColorFromRGB(0x62f7ff) CGColor], nil]];
    //[gradientLayer1 setLocations:@[@0.3,@0.4,@0.5,@0.6,@0.7,@0.84,@1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:gradientLayer1];*/
    
    
    CALayer *gradientLayer = [CALayer layer];

    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    [gradientLayer1 setLocations:@[@0.1,@0.15,@0.30,@0.65,@0.85]];
    //gradientLayer2.frame = CGRectMake(rect.size.width / 2, rect.size.height/2 - nRadius, nRadius, nRadius * 2);
    gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0xffac74) CGColor], (id)[UIColorFromRGB(0xffac74) CGColor],(id)[UIColorFromRGB(0xfd80db) CGColor],(id)[UIColorFromRGB(0xfd80db) CGColor],(id)[UIColorFromRGB(0x62f7ff) CGColor],nil]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x5bf5ff) CGColor],(id)[UIColorFromRGB(0x66ffbc) CGColor],(id)[UIColorFromRGB(0xfdff71) CGColor], (id)[UIColorFromRGB(0xfdff71) CGColor], (id)[UIColorFromRGB(0xffac74) CGColor], nil]];
    [gradientLayer2 setLocations:@[@0.1,@0.3,@0.55,@0.7,@0.86]];
    [gradientLayer2 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    [gradientLayer setMask:_progressLayer];
    [self.layer addSublayer:gradientLayer];
    
}

-(void)setPercent:(CGFloat)fPercent animated:(BOOL)animated
{
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1.0];
    _progressLayer.strokeEnd = fPercent;
    [CATransaction commit];
}

@end