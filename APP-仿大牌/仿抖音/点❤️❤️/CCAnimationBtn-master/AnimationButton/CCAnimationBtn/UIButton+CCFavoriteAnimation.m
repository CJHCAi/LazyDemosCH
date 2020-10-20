//
//  UIButton+CCFavoriteAnimation.m
//  AnimationButton
//
//  Created by sischen on 2018/10/4.
//  Copyright © 2018年 Xiaosao6. All rights reserved.
//

#import "UIButton+CCFavoriteAnimation.h"
#import <objc/runtime.h>


static void *ccAnimationPropsDict   = &ccAnimationPropsDict;
static void *ccImgLayer             = &ccImgLayer;
static void *ccLines                = &ccLines;
static void *ccUnChosenImgLayer     = &ccUnChosenImgLayer;

static NSString *lineCountKey           = @"lineCount";
static NSString *lineWidthKey           = @"lineWidth";
static NSString *lineLengthPercentKey   = @"lineLengthPercent";
static NSString *imgSizePercentKey      = @"imgSizePercent";
static NSString *animationTimeKey       = @"animationTime";
static NSString *lineColorKey           = @"lineColor";
static NSString *unchosenColorKey       = @"unchosenColor";
static NSString *isUnchosenStyleStrokeKey = @"isUnchosenStyleStroke";
static NSString *isFavoriteAnimationEnabledKey = @"isFavoriteAnimationEnabled";
static NSString *ccUnchosenStrokeWidthKey = @"ccUnchosenStrokeWidth";



@implementation UIButton (CCFavoriteAnimation)


#pragma mark -
#pragma mark - setup

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(layoutSubviews)),
                                       class_getInstanceMethod(self.class, @selector(cc_swizzled_layoutSubviews)));
    });
}

-(void)cc_swizzled_layoutSubviews {
    if (self.ccIsFavoriteAnimationEnabled) {
        [self setupUI];
    }
    [self cc_swizzled_layoutSubviews];
}

- (void)setupUI{
    self.layer.masksToBounds = YES;
    
    if (self.ccLineCount == 0) {
        self.ccLineCount = 6;
    }
    if (self.ccLineWidth == 0) {
        self.ccLineWidth = 10.0;
    }
    if (self.ccLineLengthRatio == 0) {
        self.ccLineLengthRatio = 0.4;
    }
    if (self.ccImgSizeRatio == 0) {
        self.ccImgSizeRatio  = 0.7;
    }
    if (self.ccAnimationTime == 0) {
        self.ccAnimationTime = 1.2;
    }
    if (!self.ccLineColor) {
        self.ccLineColor = [UIColor colorWithRed:0.9686 green:0.2863 blue:0.4471 alpha:1];
    }
    if (!self.ccUnchosenColor) {
        self.ccUnchosenColor = UIColor.whiteColor;
    }
    if (self.ccUnchosenStrokeWidth == 0) {
        self.ccUnchosenStrokeWidth = 5;
    }
    
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 2;
    
    if (![self.layer.sublayers containsObject:self.unChosenImgLayer]) {
        [self.layer addSublayer:self.unChosenImgLayer];
    }
}

#pragma mark -
#pragma mark - animations implement
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
    anim_opacity.duration = self.ccAnimationTime/4.0;
    anim_opacity.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    anim_opacity.fromValue = from;
    anim_opacity.toValue   = to;
    [self.unChosenImgLayer addAnimation:anim_opacity forKey:@"opacity"];
}

-(void)makeFadingAnimationWithCenterImage {
    CABasicAnimation *anim_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim_scale.duration = self.ccAnimationTime/4.0;
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
    CAAnimation *anim1 = [self imgSpringAnimationWithKeyPath:@"transform.rotation.z" From:from To:to BeginTime:self.ccAnimationTime/3.5];
    [self.imgLayer addAnimation:anim1 forKey:@"rotation"];
    
    CAAnimation *anim2 = [self imgSpringAnimationWithKeyPath:@"transform.scale" From:@0.1 To:@1.0 BeginTime:self.ccAnimationTime/4.0];
    [self.imgLayer addAnimation:anim2 forKey:@"scale"];
}

-(void)makeAnimationWithLine:(CAShapeLayer *)line {
    [self.layer addSublayer: line];
    //缩放动画
    CABasicAnimation *anim_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim_scale.duration = self.ccAnimationTime/4.0;
    anim_scale.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    anim_scale.fromValue = @0.01;
    anim_scale.toValue   = @1.00;
    [line addAnimation:anim_scale forKey:@"scale"];
    
    //位移动画
    NSInteger index = [self.lines indexOfObject:line];
    CGFloat maxSize = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    double moveLength = MAX((maxSize * 0.5)/sin(2 * M_PI/self.ccLineCount), (maxSize * 0.5)/cos(M_PI/self.ccLineCount));
    double xRange = moveLength * sin((2 * M_PI/self.ccLineCount) *(index + 1));
    double yRange = moveLength * cos((2 * M_PI/self.ccLineCount) *(index + 1));
    
    CABasicAnimation *anim_trans = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    anim_trans.fillMode = kCAFillModeForwards;
    anim_trans.removedOnCompletion = NO;
    anim_trans.beginTime = CACurrentMediaTime() + self.ccAnimationTime/4.0;
    anim_trans.duration = self.ccAnimationTime/4.0;
    anim_trans.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    anim_trans.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    anim_trans.toValue   = [NSValue valueWithCGPoint:CGPointMake(xRange, -yRange)];
    [line addAnimation:anim_trans forKey:@"translation"];
}

#pragma mark -
#pragma mark - private
-(CASpringAnimation *)imgSpringAnimationWithKeyPath:(NSString *)keypath From:(id)from To:(id)to BeginTime:(CFTimeInterval)beginTime{
    CASpringAnimation *anim_spring = [CASpringAnimation animationWithKeyPath:keypath];
    anim_spring.fillMode = kCAFillModeForwards;
    anim_spring.removedOnCompletion = NO;
    anim_spring.fromValue = from;
    anim_spring.toValue   = to;
    anim_spring.beginTime = CACurrentMediaTime() + beginTime;
    anim_spring.duration = self.ccAnimationTime/2.0;
    anim_spring.speed = 1.0/self.ccAnimationTime;
    
    anim_spring.mass = 1;
    anim_spring.damping = 8;
    anim_spring.stiffness = 180;
    anim_spring.initialVelocity = 8;
    
    return anim_spring;
}

-(CALayer *)heartLayerWithFrame:(CGRect)rect withColor:(UIColor *)color isFill:(BOOL)fill{
    CALayer *visibleLayer = [CALayer layer];
    visibleLayer.frame = rect;
    visibleLayer.backgroundColor = color.CGColor;
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
    
    //轮廓蒙版
    CAShapeLayer *shapeMask = [CAShapeLayer layer];
    
    if (fill) {
        shapeMask.bounds = rect;
        shapeMask.fillColor = [UIColor whiteColor].CGColor;
        shapeMask.fillRule = kCAFillRuleEvenOdd;
    } else {
        shapeMask.frame = rect;
        shapeMask.fillColor = [UIColor clearColor].CGColor;
        shapeMask.strokeColor = color.CGColor;
    }
    shapeMask.path = heartPath.CGPath;
    shapeMask.position = visibleLayer.position;
    
    if (fill) {
        visibleLayer.mask = shapeMask;
        return visibleLayer;
    } else {
        shapeMask.lineWidth = self.ccUnchosenStrokeWidth;
        shapeMask.lineCap = @"round";
        return shapeMask;
    }
}

-(CGRect)imageLayerFrame{
    CGFloat minlength = MIN(self.frame.size.width, self.frame.size.height);
    return CGRectMake(0.5*(self.frame.size.width - minlength * self.ccImgSizeRatio),
                      0.5*(self.frame.size.height - minlength * self.ccImgSizeRatio),
                      minlength * self.ccImgSizeRatio,
                      minlength * self.ccImgSizeRatio);
}

#pragma mark -
#pragma mark - getter/setter
-(CALayer *)imgLayer{
    CALayer *layer = objc_getAssociatedObject(self, &ccImgLayer);
    if (layer == nil){
        CALayer *newLayer = [self heartLayerWithFrame:[self imageLayerFrame] withColor:self.ccLineColor isFill:YES];
        objc_setAssociatedObject(self, &ccImgLayer, newLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newLayer;
    }
    return layer;
}

-(CALayer *)unChosenImgLayer{
    CALayer *layer = objc_getAssociatedObject(self, &ccUnChosenImgLayer);
    if (layer == nil){
        BOOL isStroke = self.ccIsUnchosenStyleStroke;
        CALayer *newLayer = [self heartLayerWithFrame:[self imageLayerFrame] withColor:self.ccUnchosenColor isFill:!isStroke];
        objc_setAssociatedObject(self, &ccUnChosenImgLayer, newLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newLayer;
    }
    return layer;
}

-(NSArray<CAShapeLayer *> *)lines{
    NSArray<CAShapeLayer *> *lines_ = objc_getAssociatedObject(self, &ccLines);
    if (lines_ == nil) {
        CGRect lineFrame = CGRectMake(0, 0, self.bounds.size.width * self.ccLineLengthRatio * 2, self.bounds.size.height * self.ccLineLengthRatio * 2);
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i=0; i<self.ccLineCount; i++) {
            CAShapeLayer *lineLayer   = [CAShapeLayer layer];
            lineLayer.bounds          = self.frame;
            lineLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            lineLayer.backgroundColor = self.ccLineColor.CGColor;
            
            CAShapeLayer *lineMask = [CAShapeLayer layer];
            CGMutablePathRef shapePath = CGPathCreateMutable();
            CGPathMoveToPoint(shapePath, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
            CGPathAddLineToPoint(shapePath, nil, lineFrame.origin.x + lineFrame.size.width / 2 + 0.5*self.ccLineWidth, lineFrame.origin.y);
            CGPathAddLineToPoint(shapePath, nil, lineFrame.origin.x + lineFrame.size.width / 2 - 0.5*self.ccLineWidth, lineFrame.origin.y);
            CGPathAddLineToPoint(shapePath, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
            lineMask.path = shapePath;
            CGPathRelease(shapePath);
            
            lineMask.bounds = lineFrame;
            lineMask.position = self.center;
            lineMask.fillColor = [UIColor whiteColor].CGColor;
            lineMask.fillRule = kCAFillRuleEvenOdd;
            
            lineLayer.transform = CATransform3DMakeRotation((2 * M_PI / self.ccLineCount) * (i + 1), 0.0, 0.0, 1.0);
            lineLayer.mask = lineMask;
            
            [tmpArr addObject: lineLayer];
        }
        NSArray<CAShapeLayer *> *newlines = [NSArray<CAShapeLayer *> arrayWithArray:tmpArr];
        objc_setAssociatedObject(self, &ccLines, newlines, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newlines;
    }
    return lines_;
}


#pragma mark -
#pragma mark - appearance setter

-(NSInteger)ccLineCount{
    NSNumber *count = [[self getPropsDict] valueForKey:lineCountKey];
    return count.integerValue;
}
-(void)setCcLineCount:(NSInteger)lineCount{
    [[self getPropsDict] setValue:@(lineCount) forKey:lineCountKey];
}

-(CGFloat)ccLineWidth{
    NSNumber *width = [[self getPropsDict] valueForKey:lineWidthKey];
    return width.doubleValue;
}
-(void)setCcLineWidth:(CGFloat)lineWidth{
    [[self getPropsDict] setValue:@(lineWidth) forKey:lineWidthKey];
}

-(CGFloat)ccLineLengthRatio{
    NSNumber *percent = [[self getPropsDict] valueForKey:lineLengthPercentKey];
    return percent.doubleValue;
}
-(void)setCcLineLengthRatio:(CGFloat)lineLengthPercent{
    [[self getPropsDict] setValue:@(lineLengthPercent) forKey:lineLengthPercentKey];
}

-(CGFloat)ccImgSizeRatio{
    NSNumber *percent = [[self getPropsDict] valueForKey:imgSizePercentKey];
    return percent.doubleValue;
}
-(void)setCcImgSizeRatio:(CGFloat)imgSizePercent{
    [[self getPropsDict] setValue:@(imgSizePercent) forKey:imgSizePercentKey];
}

-(CFTimeInterval)ccAnimationTime{
    NSNumber *time = [[self getPropsDict] valueForKey:animationTimeKey];
    return time.doubleValue;
}
-(void)setCcAnimationTime:(CFTimeInterval)animationTime{
    [[self getPropsDict] setValue:@(animationTime) forKey:animationTimeKey];
}

-(UIColor *)ccLineColor{
    UIColor *color = [[self getPropsDict] valueForKey:lineColorKey];
    return color;
}
-(void)setCcLineColor:(UIColor *)lineColor{
    [[self getPropsDict] setValue:lineColor forKey:lineColorKey];
}

-(UIColor *)ccUnchosenColor{
    UIColor *color = [[self getPropsDict] valueForKey:unchosenColorKey];
    return color;
}
-(void)setCcUnchosenColor:(UIColor *)ccUnchosenColor{
    [[self getPropsDict] setValue:ccUnchosenColor forKey:unchosenColorKey];
}

-(BOOL)ccIsUnchosenStyleStroke{
    NSNumber *value = [[self getPropsDict] valueForKey:isUnchosenStyleStrokeKey];
    return value.boolValue;
}
-(void)setCcIsUnchosenStyleStroke:(BOOL)ccIsUnchosenStyleStroke{
    [[self getPropsDict] setValue:@(ccIsUnchosenStyleStroke) forKey:isUnchosenStyleStrokeKey];
}
-(CGFloat)ccUnchosenStrokeWidth{
    NSNumber *value = [[self getPropsDict] valueForKey:ccUnchosenStrokeWidthKey];
    return value.doubleValue;
}
-(void)setCcUnchosenStrokeWidth:(CGFloat)ccUnchosenStrokeWidth{
    [[self getPropsDict] setValue:@(ccUnchosenStrokeWidth) forKey:ccUnchosenStrokeWidthKey];
}

-(NSMutableDictionary *)getPropsDict{
    NSMutableDictionary *propsDic = objc_getAssociatedObject(self, &ccAnimationPropsDict);
    if (propsDic == nil){
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:20];
        objc_setAssociatedObject(self, &ccAnimationPropsDict, newDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newDic;
    }
    return propsDic;
}

#pragma mark -
#pragma mark - public mehtod

-(BOOL)ccIsFavoriteAnimationEnabled{
    NSNumber *value = [[self getPropsDict] valueForKey:isFavoriteAnimationEnabledKey];
    return value.boolValue;
}
-(void)setCcIsFavoriteAnimationEnabled:(BOOL)ccIsFavoriteAnimationEnabled{
    [[self getPropsDict] setValue:@(ccIsFavoriteAnimationEnabled) forKey:isFavoriteAnimationEnabledKey];
}

-(BOOL)ccIsFavorite{
    NSNumber *value = [[self getPropsDict] valueForKey:@"ccIsFavorite"];
    return value.boolValue;
}
-(void)setCcIsFavorite:(BOOL)ccIsFavorite{
    [[self getPropsDict] setValue:@(ccIsFavorite) forKey:@"ccIsFavorite"];
    if(ccIsFavorite){
        [self makeChosenAnimation];
    } else {
        [self makeUnchosenAnimation];
    }
}

@end
