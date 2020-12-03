//
//  ColorProgressView.m
//  ProgressView
//
//  Created by zhao on 16/9/18.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "ColorProgressView.h"

#define COLOR_WIDTH self.frame.size.width
#define COLOR_HEIGHT self.frame.size.height

@implementation ColorProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

- (instancetype)init
{
    if([super init])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
        [self initData];
    }
    return self;
}

/** 初始化数据*/
- (void)initData
{
    if(COLOR_HEIGHT != COLOR_WIDTH){
        NSLog(@"宽和高不一样,裁剪出来的不是圆");
        return;
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = COLOR_WIDTH/2;
    
    self.progressWidth = 6.0;
    self.upColors = @[(id)[UIColor blueColor].CGColor, (id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor];
    self.downColors = @[(id)[UIColor greenColor].CGColor, (id)[UIColor cyanColor].CGColor, (id)[UIColor purpleColor].CGColor];
    self.centerCircleColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupMultipleColor];
}


/**
 *  将view分成上下两部分，并赋给多种颜色
 */
- (void)setupMultipleColor
{
    // 上半部分
    CAGradientLayer *upLayer = [CAGradientLayer layer];
    upLayer.frame = CGRectMake(0, 0, COLOR_WIDTH, COLOR_HEIGHT/2);
    // 颜色渐变方向
    upLayer.startPoint = CGPointMake(0, 0.5);
    upLayer.endPoint = CGPointMake(1, 0.5);
    // 颜色
    upLayer.colors = self.upColors;
    [self.layer addSublayer:upLayer];
    
    // 下半部分
    CAGradientLayer *downLayer = [CAGradientLayer layer];
    downLayer.frame = CGRectMake(0, COLOR_HEIGHT/2, COLOR_WIDTH, COLOR_HEIGHT/2);
    // 颜色渐变方向
    downLayer.startPoint = CGPointMake(0, 0.5);
    downLayer.endPoint = CGPointMake(1, 0.5);
    downLayer.colors = self.downColors;
    [self.layer addSublayer:downLayer];
    
    // 中心圆 白色
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(COLOR_WIDTH/2, COLOR_HEIGHT/2) radius:(COLOR_WIDTH-self.progressWidth*2)/2 startAngle:0 endAngle:M_PI*2 clockwise:0];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineWidth = self.progressWidth;
    circleLayer.fillColor = self.centerCircleColor.CGColor;
    circleLayer.path = path.CGPath;
    [self.layer addSublayer:circleLayer];
}

#pragma mark -- 转换坐标

// 这里要注意 有时拖拽按钮不在圆上，但是只要算出拖拽点与圆心的连线和水平方向的夹角的余弦值，再乘上半径，就是我们想要的值
- (CGPoint)getColorBtnCenterWithDragBtnPoint:(CGPoint)btnPoint centerOfCircle:(CGPoint)centerOfCircle
{
    CGFloat radius = (COLOR_WIDTH - self.progressWidth)/2; //半径
    
    // 拖拽点(实际)坐标到圆心的距离的平方 勾股定理
    CGFloat squareDis = (centerOfCircle.x - btnPoint.x)*(centerOfCircle.x - btnPoint.x) + (centerOfCircle.y -btnPoint.y)*(centerOfCircle.y -btnPoint.y);
    // 拖拽点坐标到圆心的距离
    CGFloat distance = fabs(sqrt(squareDis));
    
    // 拖拽点与圆心的连线 与水平方向夹角的余弦值
    CGFloat cosX = fabs(centerOfCircle.x - btnPoint.x)/distance;
    
    // 拖拽点(虚拟)在圆上到圆心的X值, y值
    CGFloat centerX = cosX * radius;
    CGFloat centerY = sqrt(radius*radius - centerX*centerX);
    
    // 算出在父视图上的实际X值、Y值
    if(btnPoint.x > centerOfCircle.x){ // 拖拽点在圆心右边
        centerX = centerOfCircle.x + centerX;
    }
    else{ // 拖拽点在圆心左边
        centerX = centerOfCircle.x - centerX;
    }
    
    if(btnPoint.y > centerOfCircle.y) { // 拖拽点在圆心下边
        centerY = centerOfCircle.y + centerY;
    }
    else{// 拖拽点在圆心上边
        centerY = centerOfCircle.y - centerY;
    }
    return CGPointMake(centerX, centerY);
}

#pragma mark -- 根据坐标返回颜色

- (UIColor *)colorWithCirclePoint:(CGPoint)circlePoint
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -circlePoint.x, -circlePoint.y);
    //NSLog(@"%f, %f",  circlePoint.x, circlePoint.y);
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"%@", [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0]);
    return [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
}

@end
