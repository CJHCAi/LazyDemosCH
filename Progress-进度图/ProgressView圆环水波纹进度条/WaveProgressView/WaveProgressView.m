//
//  WaveProgressView.m
//  ProgressView
//
//  Created by zhao on 16/9/13.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  波浪式的进度条

#import "WaveProgressView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface WaveProgressView ()

@property (nonatomic, strong) CAShapeLayer *firstShapeLayer;
@property (nonatomic, strong) CAShapeLayer *secondShapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat offsetX;

@end

@implementation WaveProgressView

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

- (void)initData
{
    self.progressWidth = 3.0;
    self.progressBackgroundColor = RGBA(223, 223, 248, 1);
    self.percent = 0.0;
    
    // 实际画出的波纹是矩形，设置超出圆形部分减掉，所以显示波纹的形状是圆形
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = MIN(WIDTH/2, HEIGHT/2);
    self.layer.borderWidth = self.progressWidth;
    self.layer.borderColor = self.progressBackgroundColor.CGColor;
    
    self.labelbackgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:15];
    
    self.firstWaveColor = RGBA(134, 216, 210, 0.5);
    self.secondWaveColor = RGBA(134, 216, 210, 1);
    self.isShowWave = YES;
    self.waveSpeed = 0.3/M_PI;
    self.waveAmplitude = 4;
    self.waveCycle = 1;
    
    self.offsetX = 0.0f;
}

- (void)layoutSubviews
{
    [super addSubview:self.centerLabel];
    self.centerLabel.backgroundColor = self.labelbackgroundColor;
    self.centerLabel.textColor = self.textColor;
    self.centerLabel.font = self.textFont;
    // 注意顺序
    [self.layer addSublayer:self.firstShapeLayer];
    [self.layer addSublayer:self.secondShapeLayer];
    [self addSubview:self.centerLabel];
}

#pragma mark -- 进度条

- (void)setPercent:(float)percent
{
    if(percent < 0) return;
    
    _percent = percent;
    [self startWaveAnimation];
}

/**
 *  开始动画
 */
- (void)startWaveAnimation
{
    if(!self.displayLink){
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawProgress:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/**
 *  画进度条 有波纹
 */
- (void)drawProgress:(CADisplayLink *)link
{
    if(!self.isShowWave){ // 没有波纹的进度条
        [self showNoWaveProgress];
        return;
    }
    
    self.offsetX += self.waveSpeed;
    // 第一条波纹
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y =  HEIGHT - self.progressWidth - self.percent * (HEIGHT - self.progressWidth*2);
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= WIDTH ; x++)
    {
        if(self.percent > 1){// >1则不需要波纹
            CGPathAddLineToPoint(path, nil, WIDTH, y);
            break;
        }
        // 正弦波浪公式 坐标转换将x装换为对应的弧度值:(self.waveCycle * x / WIDTH) * M_PI*2; 平移:self.offsetX
        y = self.waveAmplitude * sin((self.waveCycle * x / WIDTH) * M_PI*2 + self.offsetX) + y;
        CGPathAddLineToPoint(path, nil, x, y);
        // 每次重置y值 不要累加
        y =  HEIGHT - self.progressWidth - self.percent * (HEIGHT - self.progressWidth*2);
    }
      
    CGPathAddLineToPoint(path, nil, WIDTH, HEIGHT - self.progressWidth);
    CGPathAddLineToPoint(path, nil, 0, HEIGHT - self.progressWidth);
    CGPathCloseSubpath(path);
    
    self.firstShapeLayer.path = path;
    CGPathRelease(path);
    
    // 第二条波纹
    CGMutablePathRef secondPath = CGPathCreateMutable();
    CGPathMoveToPoint(secondPath, nil, 0, y);
    for (float x = 0.0f; x <= WIDTH ; x++)
    {
        if(self.percent > 1){// >1则不需要波纹
            CGPathAddLineToPoint(secondPath, nil, WIDTH, y);
            break;
        }
        // 余弦波浪公式
        y = self.waveAmplitude * cos((self.waveCycle * x / WIDTH) * M_PI*2 + self.offsetX) + y;
        CGPathAddLineToPoint(secondPath, nil, x, y);
        // 每次重置y值 不要累加
        y =  HEIGHT - self.progressWidth - self.percent * (HEIGHT - self.progressWidth*2);
    }
    
    CGPathAddLineToPoint(secondPath, nil, WIDTH, HEIGHT - self.progressWidth);
    CGPathAddLineToPoint(secondPath, nil, 0, HEIGHT - self.progressWidth);
    CGPathCloseSubpath(secondPath);
    
    self.secondShapeLayer.path = secondPath;
    CGPathRelease(secondPath);
}

/**
 *  不需要显示波纹的进度条
 */
- (void)showNoWaveProgress
{
    // 第一条波纹
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y =  HEIGHT - self.percent * (HEIGHT - self.progressWidth*2) - self.progressWidth;;
    CGPathMoveToPoint(path, nil, 0, y);
    CGPathAddLineToPoint(path, nil, WIDTH, y);
    CGPathAddLineToPoint(path, nil, WIDTH, HEIGHT - self.progressWidth);
    CGPathAddLineToPoint(path, nil, 0, HEIGHT - self.progressWidth);
    CGPathCloseSubpath(path);
    
    self.firstShapeLayer.path = path;
    CGPathRelease(path);
}

/** 结束动画*/
- (void)endWaveAnimation
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}


- (void)dealloc{
    [self endWaveAnimation];
}

#pragma mark -- getter

- (CAShapeLayer *)firstShapeLayer
{
    if(!_firstShapeLayer)
    {
        _firstShapeLayer = [CAShapeLayer layer];
        _firstShapeLayer.frame = self.bounds;
        _firstShapeLayer.fillColor = self.firstWaveColor.CGColor;
    }
    return _firstShapeLayer;
}

- (CAShapeLayer *)secondShapeLayer
{
    if(!_secondShapeLayer)
    {
        _secondShapeLayer = [CAShapeLayer layer];
        _secondShapeLayer.frame = self.bounds;
        _secondShapeLayer.fillColor = self.secondWaveColor.CGColor;
    }
    return _secondShapeLayer;
}

- (UILabel *)centerLabel
{
    if(!_centerLabel)
    {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, (HEIGHT-self.progressWidth)/2)];
        _centerLabel.center = CGPointMake(WIDTH/2, (HEIGHT-self.progressWidth)/2);
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}

@end
