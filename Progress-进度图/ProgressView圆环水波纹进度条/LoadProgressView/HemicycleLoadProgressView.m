//
//  hemicycleLoadProgressView.m
//  ProgressView
//
//  Created by zhao on 16/10/24.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "HemicycleLoadProgressView.h"

#define LOAD_WIDTH self.frame.size.width
#define LOAD_HEIGHT self.frame.size.height

@interface HemicycleLoadProgressView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation HemicycleLoadProgressView

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
    self.backgroundColor = [UIColor whiteColor];
    
    self.animationDuration = 1.0;
    self.progressWidth = 2.0;
    self.progressColor = [UIColor redColor];
    self.progressBackgroundColor = [UIColor grayColor];
    self.clockwise = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupLoadProgress];
}

#pragma mark -- 进度条

- (void)drawRect:(CGRect)rect
{
    // 画背景圆
    UIBezierPath *path =[UIBezierPath bezierPathWithArcCenter:CGPointMake(LOAD_WIDTH/2, LOAD_HEIGHT/2) radius:(LOAD_WIDTH - self.progressWidth)/2.0 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [self.progressBackgroundColor setStroke];
    path.lineWidth = self.progressWidth;
    [path stroke];
}

- (void)setupLoadProgress
{
    [self.layer removeAllAnimations];
    // 添加动画效果
    CABasicAnimation *rotationAn = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAn.duration = self.animationDuration;
    rotationAn.fromValue = @0.0;
    rotationAn.toValue = @(2 * M_PI);
    rotationAn.repeatCount = MAXFLOAT;
    rotationAn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAn forKey:@"rotation"];
    
    // 画弧度 YES逆时针 NO顺时针
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(LOAD_WIDTH/2, LOAD_HEIGHT/2) radius:(LOAD_WIDTH - self.progressWidth)/2.0 startAngle:-M_PI_4 endAngle:M_PI_4 clockwise:self.clockwise];
    self.shapeLayer.path = path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark -- 进入前台或活跃状态

// 当程序重新进入前台或活跃状态，动画仍然会执行
- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLoadProgress) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLoadProgress) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- getter

- (CAShapeLayer *)shapeLayer
{
    if(!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = self.progressWidth;
        _shapeLayer.strokeColor = self.progressColor.CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shapeLayer;
}

@end
