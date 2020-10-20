//
//  JRFitnessStatusView.m
//  JR
//
//  Created by Zj on 17/8/19.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRFitnessStatusView.h"

@interface JRFitnessStatusView()
@property (nonatomic, strong) UIImageView *stautsImgView;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation JRFitnessStatusView {
    CAShapeLayer *_waveLayer1; //曲线1
    CAShapeLayer *_waveLayer2; //曲线2
    CGFloat _waveWidth; //宽度
    CGFloat _maxAmplitude; //波峰值
    CGFloat _frequency; //波频率
    CGFloat _phase1; //初相
    CGFloat _phase2; //初相
}

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - private
- (void)setupSubViews{
    [JRTool shadow:self.layer];
    
    _stautsImgView = [UIImageView imageViewWithFrame:CGRectMake(JRPadding, 0, self.width - 2 * JRPadding, self.height) image:[UIImage imageNamed:@"status"]];
    _stautsImgView.layer.masksToBounds = YES;
    _stautsImgView.layer.cornerRadius = 3;
    
    [self addSubview:_stautsImgView];
    
    _waveLayer1 = [CAShapeLayer layer];
    _waveLayer1.backgroundColor = JRClearColor.CGColor;
    _waveLayer1.frame = CGRectMake(0, self.height / 5 * 4, self.width - 2 * JRPadding, self.height / 5);
    _waveLayer1.fillColor = [JRHexColor(0x68cfee) colorWithAlphaComponent:0.5].CGColor;
    _waveLayer1.masksToBounds = YES;
    
    [_stautsImgView.layer addSublayer:_waveLayer1];
    
    _waveLayer2 = [CAShapeLayer layer];
    _waveLayer2.backgroundColor = JRClearColor.CGColor;
    _waveLayer2.frame = CGRectMake(0, self.height / 3 * 2, self.width - 2 * JRPadding, self.height / 3);
    _waveLayer2.fillColor = [JRHexColor(0x68cfee) colorWithAlphaComponent:0.3].CGColor;
    _waveLayer2.masksToBounds = YES;
    
    [_stautsImgView.layer addSublayer:_waveLayer2];
    
    
    //动画参数初始化
    _waveWidth = _waveLayer1.frame.size.width;
    _maxAmplitude = _waveLayer1.frame.size.height / 2;
    _frequency = 0.5;
    _phase1 = 0;
    _phase2 = 90;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)wave{
    
    _phase1 -= 1;
    _phase2 += 2;
    
    UIBezierPath *wavePath1 = [UIBezierPath bezierPath];
    UIBezierPath *wavePath2 = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for (CGFloat x = 0; x < _waveWidth + 1; x += 1) {
        endX = x;
        CGFloat y1 = _maxAmplitude * sinf(360.0 / _waveWidth * (x * M_PI / 180) * _frequency + _phase1 * M_PI/ 180) + _maxAmplitude;
        
        CGFloat delta = (_waveWidth - x) / _waveWidth;
        CGFloat amplitude = _maxAmplitude - _maxAmplitude * delta * 0.4;
        CGFloat frequency = _frequency * 2 + delta;
        
        CGFloat y2 = amplitude * sinf(360.0 / _waveWidth * (x * M_PI / 180) * frequency + _phase2 * M_PI / 180) + amplitude * 2;
        if (x == 0) {
            [wavePath1 moveToPoint:CGPointMake(x, y1)];
            [wavePath2 moveToPoint:CGPointMake(x, y2)];
        } else {
            [wavePath1 addLineToPoint:CGPointMake(x, y1)];
            [wavePath2 addLineToPoint:CGPointMake(x, y2)];
        }
    }
    
    CGFloat endY1 = CGRectGetHeight(_waveLayer1.bounds) + 10;
    [wavePath1 addLineToPoint:CGPointMake(endX, endY1)];
    [wavePath1 addLineToPoint:CGPointMake(0, endY1)];
    
    CGFloat endY2 = CGRectGetHeight(_waveLayer2.bounds) + 10;
    [wavePath2 addLineToPoint:CGPointMake(endX, endY2)];
    [wavePath2 addLineToPoint:CGPointMake(0, endY2)];
    
    _waveLayer1.path = wavePath1.CGPath;
    _waveLayer2.path = wavePath2.CGPath;
}

@end
