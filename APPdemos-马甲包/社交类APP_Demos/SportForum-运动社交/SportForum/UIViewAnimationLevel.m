//
//  UIViewAnimationLevel.m
//  SportForum
//
//  Created by liyuan on 6/17/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "UIViewAnimationLevel.h"
#import "NSBKeyframeAnimation.h"
#import "CAKeyframeAnimation+AHEasing.h"

typedef void(^CompleteBlock)(void);

@implementation UIViewAnimationLevel
{
    CALayer *m_layerPeople;
    CALayer *m_layerTips;
    CALayer *m_layerStar[18];
    CALayer *m_layerColor[18];
    
    NSTimer *m_myLightTimer;
    NSUInteger m_nChangeImgIndex;
    NSMutableArray *m_imagesLightArr;
    
    NSTimer *m_myPeopleTimer;
    NSUInteger m_nPeopleImgIndex;
    NSMutableArray *m_imagesPeopleArr;
    
    CompleteBlock m_completeBlock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)swipeDismiss:(UISwipeGestureRecognizer *)gesture{
    //    NSLog(@"swip:%i",gesture.state);
    //    if (gesture.state==UIGestureRecognizerStateEnded) {
    
    //direction记录的轻扫的方向
    if (gesture.direction==UISwipeGestureRecognizerDirectionRight || gesture.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (m_completeBlock != nil) {
            m_completeBlock();
        }
    }
}

-(void)animationStartWithCompleteBlock:(void(^)(void))finishedBlock
{
    if (finishedBlock != nil) {
        m_completeBlock = finishedBlock;
    }
    
    //Create Controls
    
    //Create People Normal
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2 - 65, 130, 130)];
    m_imagesPeopleArr = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i ++) {
        UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"runner-%ld", i + 1]];
        if (image)
            [m_imagesPeopleArr addObject:image];
    }
    
    imgView.tag = 50000;
    [self addSubview:imgView];
    
    //Create Ball Normal
    UIImageView *imgViewBall = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 100, CGRectGetHeight(self.frame) / 2 - 100, 200, 200)];
    m_imagesLightArr = [NSMutableArray arrayWithCapacity:12];
    
    for (NSInteger i = 0; i < 12; i ++) {
        UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"ball-%ld", i + 1]];
        if (image)
            [m_imagesLightArr addObject:image];
    }
    
    imgViewBall.tag = 50001;
    imgViewBall.alpha = 0.0;
    [self addSubview:imgViewBall];
    
    //Create RainBow
    UIImageView *imgViewRainBow = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 400, CGRectGetHeight(self.frame) / 2 - 400, 800, 800)];
    [imgViewRainBow setImage:[UIImage imageNamedWithWebP:@"rainbow"]];
    imgViewRainBow.alpha = 0.0;
    imgViewRainBow.tag = 50002;
    [self addSubview:imgViewRainBow];
    
    //Create Success Tips
    m_layerTips = [[CALayer alloc]init];
    m_layerTips.bounds = CGRectMake(0, 0, 129, 42);
    m_layerTips.position=CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) + 21);
    m_layerTips.contents=(id)[UIImage imageNamedWithWebP:@"升级成功"].CGImage;
    [self.layer addSublayer:m_layerTips];
    
    for (NSInteger i = 0; i < 9; i++) {
        m_layerStar[i] = [[CALayer alloc]init];
        m_layerStar[i].bounds = CGRectMake(0, 0, 40, 40);
        m_layerStar[i].position=CGPointMake([self getRandomNumber:20 to:self.frame.size.width - 20], -20);
        m_layerStar[i].contents=(id)[UIImage imageNamedWithWebP:[NSString stringWithFormat:@"star-%ld", i + 1]].CGImage;
        [self.layer addSublayer:m_layerStar[i]];
        
        m_layerColor[i] = [[CALayer alloc]init];
        m_layerColor[i].bounds = CGRectMake(0, 0, 35, 35);
        m_layerColor[i].position=CGPointMake([self getRandomNumber:18 to:self.frame.size.width - 17], -18);
        m_layerColor[i].contents=(id)[UIImage imageNamedWithWebP:[NSString stringWithFormat:@"color-%ld", i + 1]].CGImage;
        [self.layer addSublayer:m_layerColor[i]];
    }
    
    for (NSInteger i = 0; i < 9; i++) {
        m_layerStar[i + 9] = [[CALayer alloc]init];
        m_layerStar[i + 9].bounds = CGRectMake(0, 0, 20, 20);
        m_layerStar[i + 9].position=CGPointMake([self getRandomNumber:10 to:self.frame.size.width - 10], -10);
        m_layerStar[i + 9].contents=(id)[UIImage imageNamedWithWebP:[NSString stringWithFormat:@"star-%ld", i + 10]].CGImage;
        [self.layer addSublayer:m_layerStar[i + 9]];
        
        m_layerColor[i + 9] = [[CALayer alloc]init];
        m_layerColor[i + 9].bounds = CGRectMake(0, 0, 20, 20);
        m_layerColor[i + 9].position=CGPointMake([self getRandomNumber:10 to:self.frame.size.width - 10], -10);
        m_layerColor[i + 9].contents=(id)[UIImage imageNamedWithWebP:[NSString stringWithFormat:@"color-%ld", i + 10]].CGImage;
        [self.layer addSublayer:m_layerColor[i + 9]];
    }
    
    //背景全局变黑，时间起始位置为第0毫秒，时间结束位置在第11500毫秒。起始变黑过程250毫秒，颜色值#000000，不透明度opacity：60%
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^(void)
     {
         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
     }completion:nil];
    
    //在时间轴第11250~11500毫秒的位置，不透明度从60%变为0%
    [UIView animateWithDuration:0.25 delay:11.25 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^(void)
     {
         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
     }completion:nil];
    
    //People Animal Begin
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(handleTranslationPeoples:) userInfo:@{@"TranslationTo" : @(self.frame.size.width / 2), @"IsStart" : @(YES)} repeats:NO];
    
    //People Animal End
    [NSTimer scheduledTimerWithTimeInterval:10.25 target:self selector:@selector(handleTranslationPeoples:) userInfo:@{@"TranslationTo" : @(-65), @"IsStart" : @(NO)} repeats:NO];
    
    //Ball Animal Begin
    //[NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(groupBallScale) userInfo:nil repeats:NO];
    //[NSTimer scheduledTimerWithTimeInterval:5.25 target:self selector:@selector(handleBallScaleEnd) userInfo:nil repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(handleBallScale:) userInfo:@{@"ScaleFrom" : @(0.6), @"ScaleTo" : @(1.4), @"Alpha" : @(1.0), @"IsStart" : @(YES)} repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(handleBallScale:) userInfo:@{@"ScaleFrom" : @(1.4), @"ScaleTo" : @(0.8), @"Alpha" : @(1.0), @"IsStart" : @(NO)} repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:3.25 target:self selector:@selector(handleBallScale:) userInfo:@{@"ScaleFrom" : @(0.8), @"ScaleTo" : @(1.3), @"Alpha" : @(1.0), @"IsStart" : @(NO)} repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:4.25 target:self selector:@selector(handleBallScale:) userInfo:@{@"ScaleFrom" : @(1.3), @"ScaleTo" : @(0.8), @"Alpha" : @(1.0), @"IsStart" : @(NO)} repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:5.25 target:self selector:@selector(handleBallScale:) userInfo:@{@"ScaleFrom" : @(0.8), @"ScaleTo" : @(6.0), @"Alpha" : @(0.0), @"IsStart" : @(NO)} repeats:NO];
    
    //RainBow Animal Begin
    [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(handleRainbowRotation:) userInfo:@{@"RotationFrom" : @(0), @"RotationTo" : @(-M_PI), @"Alpha" : @(1.0)} repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:7.5 target:self selector:@selector(handleRainbowRotation:) userInfo:@{@"RotationFrom" : @(-M_PI), @"RotationTo" : @(-2 * M_PI), @"Alpha" : @(0.0)} repeats:NO];
    
    //Tips Animal Begin
    [NSTimer scheduledTimerWithTimeInterval:8.5 target:self selector:@selector(translationTipsAnimation) userInfo:nil repeats:NO];
    
    //Tips Animal End
    [NSTimer scheduledTimerWithTimeInterval:10.75 target:self selector:@selector(groupTipsAnimation) userInfo:nil repeats:NO];
    
    //Star Light Begin
    [NSTimer scheduledTimerWithTimeInterval:7.75 target:self selector:@selector(startStarAnimated) userInfo:nil repeats:NO];
    
    //All Animal Stop
    [NSTimer scheduledTimerWithTimeInterval:11.75 target:self selector:@selector(stopAllAnimated) userInfo:nil repeats:NO];
    
    BOOL bAnimationPoped = [[[ApplicationContext sharedInstance] getObjectByKey:@"AnimationPoped"]boolValue];

    if (!bAnimationPoped) {
        [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"AnimationPoped"];
    
        //Add GestureRecognizer
        UIView *viewBgFront = [[UIView alloc]initWithFrame:self.frame];
        viewBgFront.backgroundColor = [UIColor clearColor];
        [self addSubview:viewBgFront];
        [self bringSubviewToFront:viewBgFront];
        
        UILabel *lbSkip = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 200) / 2, self.frame.size.height - 50, 200, 30)];
        lbSkip.backgroundColor = [UIColor clearColor];
        lbSkip.text = @"滑动跳过动画";
        lbSkip.textColor = [UIColor whiteColor];
        lbSkip.textAlignment = NSTextAlignmentCenter;
        [lbSkip setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        [viewBgFront addSubview:lbSkip];
        
        [UIView animateWithDuration:3 animations:^(void)
         {
             lbSkip.alpha = 0.0;
         }];
        
        UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDismiss:)];
        //swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
        [viewBgFront addGestureRecognizer:swipeGestureToRight];
        
        UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDismiss:)];
        swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [viewBgFront addGestureRecognizer:swipeGestureToLeft];
    }
}

-(void)startPeopleAnimated
{
    m_nPeopleImgIndex = 0;
    m_myPeopleTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setNextPeopleImage) userInfo:nil repeats:YES];
}

-(void)setNextPeopleImage
{
    UIImageView *imgView = (UIImageView*)[self viewWithTag:50000];
    
    if (imgView != nil) {
        imgView.image = m_imagesPeopleArr[m_nPeopleImgIndex++ % m_imagesPeopleArr.count];
    }
}

-(void)startLightAnimated
{
    m_nChangeImgIndex = 0;
    m_myLightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
}

-(void)setNextImage
{
    UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    
    if (imgViewBall != nil) {
        imgViewBall.image = m_imagesLightArr[m_nChangeImgIndex++ % m_imagesLightArr.count];
    }
}

-(void)handleTranslationPeoples:(NSTimer *)timer
{
    BOOL bStart = [timer.userInfo[@"IsStart"]boolValue];
    
    if (bStart) {
        [self startPeopleAnimated];
    }
    
    CGFloat fToTranslation = [timer.userInfo[@"TranslationTo"]floatValue];
    [self translationPeoplesAnimation:1.0 endValue:fToTranslation];
}

/*-(void)groupBallScale
{
    UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *basicAnimation1=[self scaleAnimationFromValue1:0.6 ToValue:1.4];
    CABasicAnimation *basicAnimation2=[self scaleAnimationFromValue1:1.4 ToValue:0.8];
    CABasicAnimation *basicAnimation3=[self scaleAnimationFromValue1:0.8 ToValue:1.3];
    CABasicAnimation *basicAnimation4=[self scaleAnimationFromValue1:1.3 ToValue:0.8];
    CABasicAnimation *basicAnimation5=[self scaleAnimationFromValue1:0.8 ToValue:6.0];
    animationGroup.animations=@[basicAnimation1,basicAnimation2,basicAnimation3,basicAnimation4,basicAnimation5];
    animationGroup.beginTime=CACurrentMediaTime();
    
    animationGroup.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    //3.给图层添加动画
    [imgViewBall.layer addAnimation:animationGroup forKey:nil];
    
    [UIView animateWithDuration:1 animations:^(void)
     {
         imgViewBall.alpha = 1.0;
         [self startLightAnimated];
     }];
}*/

-(void)handleBallScaleEnd
{
    UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
     {
         imgViewBall.alpha = 0.0;
         [m_myLightTimer invalidate];
         m_myLightTimer = nil;
     } completion:nil];
}

-(void)handleBallScale:(NSTimer *)timer
{
    CGFloat fFromScale = [timer.userInfo[@"ScaleFrom"]floatValue];
    CGFloat fToScale = [timer.userInfo[@"ScaleTo"]floatValue];
    
    [self scaleAnimationFromValue:fFromScale ToValue:fToScale];

    UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    CGFloat fAlpha = [timer.userInfo[@"Alpha"]floatValue];
    BOOL bStart = [timer.userInfo[@"IsStart"]boolValue];
    
    if (bStart) {
        [[CommonUtility sharedInstance]playAudioFromName:@"levelup.wav"];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
         {
             imgViewBall.alpha = 1.0;
             [self startLightAnimated];
         }completion:nil];
    }
    
    if (fAlpha == 0.0) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
         {
             imgViewBall.alpha = 0.0;
             [m_myLightTimer invalidate];
             m_myLightTimer = nil;
         }completion:nil];
    }
}

-(void)handleRainbowRotation:(NSTimer *)timer
{
    CGFloat fFromRotation = [timer.userInfo[@"RotationFrom"]floatValue];
    CGFloat fToRotation = [timer.userInfo[@"RotationTo"]floatValue];
    
    [self rotationAnimationFromValue:fFromRotation ToValue:fToRotation];
    
    UIImageView *imgViewRainBow = (UIImageView*)[self viewWithTag:50002];
    CGFloat fAlpha = [timer.userInfo[@"Alpha"]floatValue];
    
    if (fAlpha > 0.0) {
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
         {
             imgViewRainBow.alpha = 1.0;
         }completion:nil];
    }
    else
    {
        [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
         {
             imgViewRainBow.alpha = 0.0;
         }completion:nil];
    }
}

-(void)startStarAnimated
{
    for (NSInteger i = 0; i < 18; i++) {
        [NSTimer scheduledTimerWithTimeInterval:i * 0.1 target:self selector:@selector(groupAnimation:) userInfo:@{@"Layer" : m_layerStar[i]} repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:i * 0.1 target:self selector:@selector(addColorAnimation:) userInfo:@{@"Layer" : m_layerColor[i]} repeats:NO];
    }
}

-(void)addColorAnimation:(NSTimer *)timer
{
    CALayer *layer = (CALayer *)timer.userInfo[@"Layer"];
    
    CABasicAnimation* caBasicAnimation = [self translationAnimation];
    caBasicAnimation.duration = 1.75;
    [layer addAnimation:caBasicAnimation forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.55 target:self selector:@selector(hideLayer:) userInfo:@{@"Layer" : layer} repeats:NO];
}

-(void)hideLayer:(NSTimer *)timer
{
    CALayer *layer = (CALayer *)timer.userInfo[@"Layer"];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^(void)
     {
         layer.hidden = YES;
     }completion:nil];
}

-(void)stopAllAnimated
{
    UIImageView *imgView = (UIImageView*)[self viewWithTag:50000];
    imgView.hidden = YES;

    UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    imgViewBall.hidden = YES;
    
    UIImageView *imgViewRainBow = (UIImageView*)[self viewWithTag:50002];
    imgViewRainBow.hidden = YES;
    
    [m_myPeopleTimer invalidate];
    m_myPeopleTimer = nil;
    
    m_layerTips.hidden = YES;
    
    if (m_completeBlock != nil) {
        m_completeBlock();
    }
}

-(void)dealloc
{
    NSLog(@"Dealloc");
}

#pragma mark Peple Start
-(void)translationPeoplesAnimation:(NSTimeInterval)duration
                          endValue:(double)endValue
{
    UIImageView *imgView = (UIImageView*)[self viewWithTag:50000];
    NSBKeyframeAnimationFunction c = NSBKeyframeAnimationFunctionEaseOutExpo;
    
    float startValue = imgView.layer.position.x;
    
    NSBKeyframeAnimation *animation = [NSBKeyframeAnimation animationWithKeyPath:@"position.x"
                                                                        duration:duration
                                                                      startValue:startValue
                                                                        endValue:endValue
                                                                        function:c];
    animation.completionBlock = ^(BOOL finished) {
        if (finished)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                imgView.layer.position = CGPointMake(endValue, imgView.layer.position.y);
            });
        }
    };
    
    [imgView.layer setValue:[NSNumber numberWithFloat:(endValue)] forKeyPath:@"position.x"];
    [imgView.layer addAnimation:animation forKey:@"position.x"];
}

#pragma mark Ball Scale Start
-(void)scaleAnimationFromValue:(float)fValue ToValue:(float)fToValue
{
    UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration=1;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode=kCAFillModeForwards;
    theAnimation.fromValue = [NSNumber numberWithFloat:fValue];
    theAnimation.toValue = [NSNumber numberWithFloat:fToValue];
    theAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [imgViewBall.layer addAnimation:theAnimation forKey:@"animateTransform"];
}

-(CABasicAnimation*)scaleAnimationFromValue1:(float)fValue ToValue:(float)fToValue
{
    //UIImageView *imgViewBall = (UIImageView*)[self viewWithTag:50001];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration=1;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:fValue];
    theAnimation.toValue = [NSNumber numberWithFloat:fToValue];
    //[imgViewBall.layer addAnimation:theAnimation forKey:@"animateTransform"];
    return theAnimation;
}

#pragma mark Rainbow Rotation
-(void)rotationAnimationFromValue:(float)fValue ToValue:(float)fToValue
{
    UIImageView *imgViewRainBow = (UIImageView*)[self viewWithTag:50002];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation.duration=2;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode=kCAFillModeForwards;
    theAnimation.fromValue = [NSNumber numberWithFloat:fValue];
    theAnimation.toValue = [NSNumber numberWithFloat:fToValue];
    [imgViewRainBow.layer addAnimation:theAnimation forKey:@"animateTransform"];
}

#pragma mark Star
-(CABasicAnimation *)rotationAnimation{
    
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat toValue=M_PI;
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI];
    
    basicAnimation.autoreverses=true;
    basicAnimation.repeatCount=HUGE_VALF;
    basicAnimation.removedOnCompletion=NO;
    basicAnimation.fillMode=kCAFillModeForwards;
    [basicAnimation setValue:[NSNumber numberWithFloat:toValue] forKey:@"KCBasicAnimationProperty_ToValue"];
    //basicAnimation.timingFunction =
    //[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    return basicAnimation;
}

#pragma mark Star 关键帧移动动画
-(CABasicAnimation *)translationAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue = [NSNumber numberWithFloat:self.frame.size.height / 2 + 65];
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark Star 创建动画组
-(void)groupAnimation:(NSTimer *)timer
{
    CALayer *layer = (CALayer *)timer.userInfo[@"Layer"];
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *basicAnimation=[self rotationAnimation];
    CABasicAnimation *caBasicAnimation=[self translationAnimation];
    animationGroup.animations=@[basicAnimation,caBasicAnimation];
    animationGroup.duration=1.75;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    animationGroup.beginTime=CACurrentMediaTime();
    
    //3.给图层添加动画
    [layer addAnimation:animationGroup forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.55 target:self selector:@selector(hideLayer:) userInfo:@{@"Layer" : layer} repeats:NO];
}

#pragma mark Tips 基础旋转动画
-(CABasicAnimation *)rotationTipsAnimation{
    
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat toValue=M_PI_2;
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI_2];
    
    //    basicAnimation.duration=6.0;
    basicAnimation.autoreverses=true;
    basicAnimation.repeatCount=HUGE_VALF;
    basicAnimation.removedOnCompletion=NO;
    basicAnimation.fillMode=kCAFillModeForwards;
    [basicAnimation setValue:[NSNumber numberWithFloat:toValue] forKey:@"KCBasicAnimationProperty_ToValue"];
    //basicAnimation.timingFunction =
    //[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    return basicAnimation;
}

#pragma mark 关键帧移动动画
-(CAKeyframeAnimation *)translationAnimationTips{
    CAKeyframeAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"position"
                                                                  function:ExponentialEaseOut
                                                                 fromPoint:m_layerTips.position
                                                                   toPoint:CGPointMake(CGRectGetWidth(self.frame) + 30, CGRectGetHeight(self.frame) / 4)];
    return chase;
}

#pragma mark Tips 创建动画组
-(void)groupTipsAnimation{
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *basicAnimation=[self rotationTipsAnimation];
    CAKeyframeAnimation *keyframeAnimation=[self translationAnimationTips];
    animationGroup.animations=@[basicAnimation,keyframeAnimation];
    animationGroup.duration=1.1;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    animationGroup.beginTime=CACurrentMediaTime();
    
    //3.给图层添加动画
    [m_layerTips addAnimation:animationGroup forKey:nil];
}

-(void)translationTipsAnimation{
    NSBKeyframeAnimationFunction c = NSBKeyframeAnimationFunctionEaseOutExpo;
    
    float startValue = m_layerTips.position.y,
    endValue = CGRectGetHeight(self.frame) / 2 + 80;
    
    NSBKeyframeAnimation *animation = [NSBKeyframeAnimation animationWithKeyPath:@"position.y"
                                                                        duration:0.75
                                                                      startValue:startValue
                                                                        endValue:endValue
                                                                        function:c];
    animation.completionBlock = ^(BOOL finished) {
        if (finished)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                m_layerTips.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 80);
            });
        }
    };
    
    [m_layerTips setValue:[NSNumber numberWithFloat:(endValue)] forKeyPath:@"position.y"];
    [m_layerTips addAnimation:animation forKey:@"position.y"];
    
    /*CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //2.设置关键帧,这里有四个关键帧
    NSValue *key1=[NSValue valueWithCGPoint:m_layerTips.position];//对于关键帧动画初始值不能省略
    NSValue *key2=[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 80)];
    NSValue *key3=[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 100)];
    NSArray *values=@[key1,key2,key3];
    keyframeAnimation.values=values;
    //设置其他属性
    keyframeAnimation.duration=0.75;
    keyframeAnimation.beginTime=CACurrentMediaTime();
    keyframeAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    //3.添加动画到图层，添加动画后就会执行动画
    [m_layerTips addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
    [UIView animateWithDuration:0.75 animations:^(void)
     {
         m_layerTips.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 100);
     }];*/
    /*
     //1.创建关键帧动画并设置动画属性
     CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
     
     //2.设置关键帧,这里有四个关键帧
     NSValue *key1=[NSValue valueWithCGPoint:m_layerTips.position];//对于关键帧动画初始值不能省略
     NSValue *key2=[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(m_viewAnimationFail.frame) / 2, CGRectGetHeight(m_viewAnimationFail.frame) / 2 + 60)];
     NSArray *values=@[key1,key2];
     keyframeAnimation.values=values;
     //设置其他属性
     keyframeAnimation.duration=0.75;
     keyframeAnimation.beginTime=CACurrentMediaTime();
     keyframeAnimation.delegate = self;
     
     //3.添加动画到图层，添加动画后就会执行动画
     [m_layerTips addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];*/
}

/*-(CAKeyframeAnimation *)translationTipsOutAnimation{
 CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
 
 CGPoint endPoint= CGPointMake(CGRectGetWidth(m_viewAnimationFail.frame) + 129, CGRectGetHeight(m_viewAnimationFail.frame) / 4 + 30);
 CGPathRef path=CGPathCreateMutable();
 CGPathMoveToPoint(path, NULL, CGRectGetWidth(m_viewAnimationFail.frame) / 2, CGRectGetHeight(m_viewAnimationFail.frame) / 2 + 60);
 CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
 
 keyframeAnimation.path=path;
 CGPathRelease(path);
 
 [keyframeAnimation setValue:[NSValue valueWithCGPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
 
 return keyframeAnimation;
 }
 
 
 */

@end
