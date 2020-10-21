//
//  CaptureVideoButton.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "CaptureVideoButton.h"

const CGFloat encircleRatio = 1/12.0f;
const CGFloat animationDuration = 0.3f;

@interface CaptureVideoButton()
@property (strong, nonatomic) CAShapeLayer *spotShapeLayer;

@property (assign, nonatomic) CGRect spotRect;
@property (assign, nonatomic) CGRect blockRect;
@property (assign, nonatomic) CGFloat encircleWidth;
@property (assign, nonatomic) CGRect encircleRect;

@property (strong, nonatomic) UIBezierPath *encirclePath;
@property (strong, nonatomic) UIBezierPath *spotPath;
@property (strong, nonatomic) UIBezierPath *blockPath;
@end



@implementation CaptureVideoButton

- (CAShapeLayer *)spotShapeLayer {
    if (_spotShapeLayer == nil) {
        _spotShapeLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_spotShapeLayer];
    }
    return _spotShapeLayer;
}

- (UIBezierPath *)encirclePath {
    if (_encirclePath == nil) {
        _encirclePath = [UIBezierPath bezierPathWithOvalInRect:_encircleRect];
        _encirclePath.lineWidth = _encircleWidth;
    }
    return _encirclePath;
}

- (UIBezierPath *)spotPath {
    if (_spotPath == nil) {
        _spotPath = [UIBezierPath bezierPathWithOvalInRect:_spotRect];
    }
    return _spotPath;
}

- (UIBezierPath *)blockPath {
    if (_blockPath == nil) {
        CGFloat cornerRadius = _spotRect.size.height * 0.1;
        _blockPath = [UIBezierPath bezierPathWithRoundedRect:_blockRect cornerRadius:cornerRadius];
    }
    return _blockPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //外围圈圈
    self.encircleWidth = self.bounds.size.height * encircleRatio;
    self.encircleRect = CGRectInset(self.bounds, _encircleWidth/2, _encircleWidth/2);
    //圆点
    self.spotRect = CGRectInset(self.bounds, _encircleWidth * 1.3, _encircleWidth * 1.3);
    //方块
    self.blockRect = CGRectInset(_spotRect, _spotRect.size.height * 0.3, _spotRect.size.height * 0.3);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //外围
    [[UIColor whiteColor] setStroke];
    [self.encirclePath stroke];
    
    //内部
    self.spotShapeLayer.path = self.spotPath.CGPath;
    [self.spotShapeLayer setFillColor:[UIColor redColor].CGColor];
}

- (void)beginCaptureAnimation {
    CABasicAnimation *beginAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    beginAnim.fromValue = (__bridge id _Nullable)(_spotShapeLayer.path);
    beginAnim.toValue = (__bridge id _Nullable)(self.blockPath.CGPath);
    beginAnim.duration = animationDuration;
    
    [_spotShapeLayer addAnimation:beginAnim forKey:@"beginAnim"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _spotShapeLayer.path = self.blockPath.CGPath;
    [CATransaction commit];
}

- (void)endCaptureAnimation {
    CABasicAnimation *endAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    endAnim.fromValue = (__bridge id _Nullable)(_spotShapeLayer.path);
    endAnim.toValue = (__bridge id _Nullable)(self.spotPath.CGPath);
    endAnim.duration = animationDuration;
    [_spotShapeLayer addAnimation:endAnim forKey:@"endAnim"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _spotShapeLayer.path = self.spotPath.CGPath;
    [CATransaction commit];
    
}



@end
