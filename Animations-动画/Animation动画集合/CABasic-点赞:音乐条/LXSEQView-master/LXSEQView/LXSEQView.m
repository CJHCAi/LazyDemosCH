//
//  LXSEQView.m
//  LXSEQViewDemo
//
//  Created by 李新星 on 15/12/16.
//  Copyright © 2015年 xx-li. All rights reserved.
//

#import "LXSEQView.h"

@interface LXSEQView () {
    BOOL _isAnimatoning;
    NSArray *_animationLayers;
}

@end

@implementation LXSEQView

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {

    self.backgroundColor = [UIColor clearColor];
    self.pillarWidth = 2;
    self.pillarColor = [UIColor redColor];
    _isAnimatoning = NO;
    
    //添加4个柱状Layer
    NSMutableArray *animationLayers = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i ++) {
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = self.pillarColor.CGColor;
        [self.layer addSublayer:layer];
        
        [animationLayers addObject:layer];
    }
    _animationLayers = [NSArray arrayWithArray:animationLayers];    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //bounds改变后需要重设Layer的Frame和动画的Path
    for (CAShapeLayer *layer in _animationLayers) {
        layer.frame = self.bounds;
    }
    [self updateAnimationPath];
}

#pragma mark - Update Path
- (void) updateAnimationPath {
    
    CGFloat height = CGRectGetHeight(self.frame);
    NSArray * pillarHeighs = @[@(height * 0.8),@(height),@(height*0.7),@(height*0.9)];
    NSInteger pillarNumber = pillarHeighs.count;
    NSInteger pillarWidth = self.pillarWidth;
    NSInteger margin = (CGRectGetWidth(self.frame) - pillarNumber * pillarWidth) / (pillarNumber - 1);
    
    for (int i = 0; i < _animationLayers.count; i ++) {
        CAShapeLayer *layer = _animationLayers[i];
        CGFloat pillarHeight = [pillarHeighs[i] floatValue];
        CGFloat x = pillarWidth + (pillarWidth + margin) * i;
        CGPoint startPoint = CGPointMake(x, CGRectGetHeight(self.frame));
        CGPoint toPoint = CGPointMake(x, height - pillarHeight);
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:toPoint];
        
        layer.path = path.CGPath;
    }
    
    if (_isAnimatoning) {
        [self startAnimation];
    }
}


#pragma mark - Setter and getter
- (void)setPillarWidth:(CGFloat)pillarWidth {
    if (_pillarWidth == pillarWidth) {
        return;
    }
    _pillarWidth = pillarWidth;
    for (CAShapeLayer * layer in _animationLayers) {
        layer.lineWidth = self.pillarWidth;
    }
}


- (void)setPillarColor:(UIColor *)pillarColor {
    if (_pillarColor == pillarColor) {
        return;
    }
    _pillarColor = pillarColor;
    for (CAShapeLayer * layer in _animationLayers) {
        layer.strokeColor = self.pillarColor.CGColor;
    }
}

#pragma mark - Public method
- (void) startAnimation {
    
    _isAnimatoning = YES;
    
    //先移除所有动画
    for (CAShapeLayer * layer in _animationLayers) {
        [layer removeAllAnimations];
    }
    
    /*通过这些数值来调整动画效果*/
    //每个Layer动画时切换的高度值（0~1）
    NSArray * values = @[
                         @[@1.0, @0.5, @0.1, @0.4, @0.7, @0.9, @1.0],
                         @[@1.0, @0.8, @0.5, @0.1, @0.5, @0.7, @1.0],
                         @[@1.0, @0.7, @0.4, @0.4, @0.7, @0.9, @1.0],
                         @[@1.0, @0.6, @0.3, @0.1, @0.6, @0.8, @1.0]
                         ];
    //每个Layer的动画时长
    NSArray * dutions = @[@(0.9),@(1.0),@(0.9),@(1.0)];

    int i = 0;
    for (CAShapeLayer * layer in _animationLayers) {
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        animation.values = values[i];
        animation.duration = [dutions[i] floatValue];
        animation.repeatCount = HUGE_VAL;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:animation forKey:@"ESSEQAnimation"];
        i ++;
    }
}

- (void) stopAnimation {
    _isAnimatoning = NO;
    
    //先移除所有动画
    for (CAShapeLayer * layer in _animationLayers) {
        [layer removeAllAnimations];
    }
}

@end
