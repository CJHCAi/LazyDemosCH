//
//  CCAnimationBtn.m
//  AnimationButton
//
//  Created by sischen on 2017/11/25.
//  Copyright © 2017年 pcbdoor.com. All rights reserved.
//

#import "CCAnimationBtn.h"

@interface CCAnimationBtn ()
@property (nonatomic, strong) NSArray <CAShapeLayer *>  *lines;
@property (nonatomic, strong) CALayer  *imgLayer;
@property (nonatomic, strong) CALayer  *unChosenImgLayer;
@end

@implementation CCAnimationBtn

#pragma mark -
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.lineCount = 6;
    self.lineWidth = 11.5;
    self.lineLengthPercent = 0.75;
    self.imgSizePercent = 0.7;
    self.animationTime = 1.1;
    self.lineColor = [UIColor colorWithRed:0.9686 green:0.2863 blue:0.4471 alpha:1];
    
    self.layer.masksToBounds = YES;
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 2;
    
    [self.layer addSublayer:self.unChosenImgLayer];
}

#pragma mark -
#pragma mark - make Animations
-(void)makeChosenAnimation{
    self.userInteractionEnabled = NO;
    [CATransaction setCompletionBlock:^{
        self.userInteractionEnabled = YES;
        for (CAShapeLayer *line in self.lines) { [line removeFromSuperlayer]; }
    }];
    
    [CATransaction begin];
    [self makeAnimationWithUnChosenImageFrom:@1 To:@0];
    [self makeComingAnimationWithCenterImage];
    for (CAShapeLayer *line in self.lines) {
        [self makeAnimationWithLine:line];
    }
    [CATransaction commit];
}

-(void)makeUnchosenAnimation{
    self.userInteractionEnabled = NO;
    [CATransaction setCompletionBlock:^{
        self.userInteractionEnabled = YES;
    }];
    
    [CATransaction begin];
    [self makeAnimationWithUnChosenImageFrom:@0 To:@1];
    [self makeFadingAnimationWithCenterImage];
    [CATransaction commit];
}

-(void)makeAnimationWithUnChosenImageFrom:(id)from To:(id)to {
    //透明度动画
    CABasicAnimation *anim_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim_opacity.fillMode = kCAFillModeForwards;
    anim_opacity.removedOnCompletion = NO;
    anim_opacity.duration = self.animationTime/4.0;
    anim_opacity.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    anim_opacity.fromValue = from;
    anim_opacity.toValue   = to;
    [self.unChosenImgLayer addAnimation:anim_opacity forKey:@"opacity"];
}

-(void)makeFadingAnimationWithCenterImage {
    CABasicAnimation *anim_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim_scale.duration = self.animationTime/4.0;
    anim_scale.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
    
    anim_scale.fromValue = @1;
    anim_scale.toValue   = @0;
    [self.imgLayer addAnimation:anim_scale forKey:@"scale"];
}

-(void)makeComingAnimationWithCenterImage {
    [self.layer addSublayer:self.imgLayer];
    self.imgLayer.affineTransform = CGAffineTransformScale(self.imgLayer.affineTransform, 0.0, 0.0);
    self.imgLayer.affineTransform = CGAffineTransformRotate(self.imgLayer.affineTransform, 0.1 * M_PI);
    
    NSNumber *from  = [NSNumber numberWithFloat:0.1 * M_PI];
    NSNumber *to    = [NSNumber numberWithFloat:0.0];
    [self.imgLayer addAnimation:[self imgSpringAnimationWithKeyPath:@"transform.rotation.z" From:from To:to BeginTime:self.animationTime/3.5] forKey:@"rotation"];
    
    [self.imgLayer addAnimation:[self imgSpringAnimationWithKeyPath:@"transform.scale" From:@0.1 To:@1.0 BeginTime:self.animationTime/4.0] forKey:@"scale"];
}

-(void)makeAnimationWithLine:(CAShapeLayer *)line {
    [self.layer addSublayer: line];
    //缩放动画
    CABasicAnimation *anim_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim_scale.duration = self.animationTime/4.0;
    anim_scale.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    anim_scale.fromValue = @0.01;
    anim_scale.toValue   = @1.00;
    [line addAnimation:anim_scale forKey:@"scale"];
    
    //位移动画
    NSInteger index = [self.lines indexOfObject:line];
    CGFloat maxSize = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    double moveLength = MAX((maxSize * 0.5)/sin(2 * M_PI/self.lineCount), (maxSize * 0.5)/cos(M_PI/self.lineCount));
    double xRange = moveLength * sin((2 * M_PI/self.lineCount) *(index + 1));
    double yRange = moveLength * cos((2 * M_PI/self.lineCount) *(index + 1));
    
    CABasicAnimation *anim_trans = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    anim_trans.fillMode = kCAFillModeForwards;
    anim_trans.removedOnCompletion = NO;
    anim_trans.beginTime = CACurrentMediaTime() + self.animationTime/4.0;
    anim_trans.duration = self.animationTime/4.0;
    anim_trans.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    anim_trans.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    anim_trans.toValue   = [NSValue valueWithCGPoint:CGPointMake(xRange, -yRange)];
    [line addAnimation:anim_trans forKey:@"translation"];
}

#pragma mark -
#pragma mark - Private
-(CASpringAnimation *)imgSpringAnimationWithKeyPath:(NSString *)keypath From:(id)from To:(id)to BeginTime:(CFTimeInterval)beginTime{
    CASpringAnimation *anim_spring = [CASpringAnimation animationWithKeyPath:keypath];
    anim_spring.fillMode = kCAFillModeForwards;
    anim_spring.removedOnCompletion = NO;
    anim_spring.fromValue = from;
    anim_spring.toValue   = to;
    anim_spring.beginTime = CACurrentMediaTime() + beginTime;
    anim_spring.duration = self.animationTime/2.0;
    anim_spring.speed = 1.0/self.animationTime;
    
    anim_spring.mass = 1;
    anim_spring.damping = 8;
    anim_spring.stiffness = 180;
    anim_spring.initialVelocity = 8;
    
    return anim_spring;
}

+(CALayer *)heartLayerWithFrame:(CGRect)rect FillColor:(UIColor *)fillColor{
    CALayer *visibleLayer = [CALayer layer];
    visibleLayer.frame = rect;
    visibleLayer.backgroundColor = fillColor.CGColor;
    //注意，此心形形状是按照顶部凹角90°来绘制的，需要调整可自行修改
    // 左右边距
    CGFloat padding = 4.0;
    // 小圆半径
    CGFloat curveRadius = ((rect.size.width - 2 * padding)/2.0) / (cos(2 * M_PI/8.0) + 1.0);
    
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    // 起点(底部，圆的第一个点)
    CGPoint tipLocation = CGPointMake(rect.size.width/2, rect.size.height-padding);
    [heartPath moveToPoint:tipLocation];
    // (左圆的第二个点)
    CGPoint topLeftCurveStart = CGPointMake(padding, rect.size.height/2.8);
    // 添加二次曲线
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    // 画左圆
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x+curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:-M_PI*0.25 clockwise:YES];
    // (右圆的第二个点)
    CGPoint topRightCurveStart = CGPointMake((rect.size.width - padding) - curveRadius, topLeftCurveStart.y);
    // 画右圆
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x, topRightCurveStart.y) radius:curveRadius startAngle:-M_PI*0.75 endAngle:0 clockwise:YES];
    // 右侧控制点
    CGPoint topRightCurveEnd = CGPointMake((rect.size.width - padding), topLeftCurveStart.y);
    // 添加二次曲线
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y+curveRadius)];
    // 设置填充色
    [fillColor setFill];
    [heartPath fill];
    
    //轮廓蒙版
    CAShapeLayer *shapeMask = [CAShapeLayer layer];
    shapeMask.path = heartPath.CGPath;
    shapeMask.bounds = rect;
    shapeMask.position = visibleLayer.position;
    shapeMask.fillColor = [UIColor whiteColor].CGColor;
    shapeMask.fillRule = kCAFillRuleEvenOdd;
    
    visibleLayer.mask = shapeMask;
    return visibleLayer;
}

-(CGRect)imageLayerFrame{
    CGFloat minlength = MIN(self.frame.size.width, self.frame.size.height);
    return CGRectMake(0.5*(self.frame.size.width - minlength * self.imgSizePercent),
                              0.5*(self.frame.size.height - minlength * self.imgSizePercent),
                              minlength * self.imgSizePercent,
                              minlength * self.imgSizePercent);
}

#pragma mark -
#pragma mark - getter/setter
-(CALayer *)imgLayer{
    if (!_imgLayer) {
        _imgLayer = [self.class heartLayerWithFrame:[self imageLayerFrame] FillColor:self.lineColor];
    }
    return _imgLayer;
}

-(CALayer *)unChosenImgLayer{
    if (!_unChosenImgLayer) {
        _unChosenImgLayer = [self.class heartLayerWithFrame:[self imageLayerFrame] FillColor:[UIColor whiteColor]];
    }
    return _unChosenImgLayer;
}

-(NSArray<CAShapeLayer *> *)lines{
    if (!_lines) {
        CGRect lineFrame = CGRectMake(0, 0, self.bounds.size.width * self.lineLengthPercent, self.bounds.size.height * self.lineLengthPercent);
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i=0; i<self.lineCount; i++) {
            CAShapeLayer *lineLayer   = [CAShapeLayer layer];
            lineLayer.bounds          = self.frame;
            lineLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            lineLayer.backgroundColor = self.lineColor.CGColor;
            
            CAShapeLayer *lineMask = [CAShapeLayer layer];
            CGMutablePathRef shapePath = CGPathCreateMutable();
            CGPathMoveToPoint(shapePath, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
            CGPathAddLineToPoint(shapePath, nil, lineFrame.origin.x + lineFrame.size.width / 2 + 0.5*self.lineWidth, lineFrame.origin.y);
            CGPathAddLineToPoint(shapePath, nil, lineFrame.origin.x + lineFrame.size.width / 2 - 0.5*self.lineWidth, lineFrame.origin.y);
            CGPathAddLineToPoint(shapePath, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
            lineMask.path = shapePath;
            CGPathRelease(shapePath);
            
            lineMask.bounds = lineFrame;
            lineMask.position = self.center;
            lineMask.fillColor = [UIColor whiteColor].CGColor;
            lineMask.fillRule = kCAFillRuleEvenOdd;
            
            lineLayer.transform = CATransform3DMakeRotation((2 * M_PI / self.lineCount) * (i + 1), 0.0, 0.0, 1.0);
            lineLayer.mask = lineMask;
            
            [tmpArr addObject: lineLayer];
        }
        _lines = [NSArray<CAShapeLayer *> arrayWithArray:tmpArr];
    }
    return _lines;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self makeChosenAnimation];
    }else{
        [self makeUnchosenAnimation];
    }
}

@end
