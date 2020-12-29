//
//  UIAnimationFailView.m
//  SportForum
//
//  Created by liyuan on 6/17/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "UIAnimationFailView.h"
#import "NSBKeyframeAnimation.h"
#import "CAKeyframeAnimation+AHEasing.h"

typedef void(^CompleteBlock)(void);

@implementation UIAnimationFailView
{
    CALayer *m_layerSnail;
    CALayer *m_layerTips;
    NSTimer *m_myLightTimer;
    NSUInteger m_nChangeImgIndex;
    NSMutableArray *m_imagesLightArr;
    
    NSTimer *m_mySnailTimer;
    NSUInteger m_nSnailImgIndex;
    NSMutableArray *m_imagesSnailArr;
    
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
    
    //Create Snail Normal
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2 - 25, 60, 51)];
    m_imagesSnailArr = [NSMutableArray arrayWithCapacity:2];
    for (NSInteger i = 0; i < 2; i ++) {
        UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"snail-%ld", i + 1]];
        if (image)
            [m_imagesSnailArr addObject:image];
    }
    
    imgView.tag = 50000;
    [self addSubview:imgView];
    
    //Create Light Normal
    UIImageView *imgViewLight = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 355)];
    m_imagesLightArr = [NSMutableArray arrayWithCapacity:15];
    
    for (NSInteger i = 0; i < 15; i ++) {
        UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"lighting-%ld", i + 1]];
        if (image)
            [m_imagesLightArr addObject:image];
    }
    
    imgViewLight.alpha = 0.0;
    imgViewLight.tag = 50001;
    [self addSubview:imgViewLight];
    
    //Create Fail Snail Layer
    m_layerSnail = [[CALayer alloc]init];
    m_layerSnail.bounds = CGRectMake(0, 0, 60, 51);
    m_layerSnail.position=CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    m_layerSnail.contents=(id)[UIImage imageNamedWithWebP:@"snail-fail"].CGImage;
    m_layerSnail.hidden = YES;
    [self.layer addSublayer:m_layerSnail];
    
    //Create Fail Tips
    m_layerTips = [[CALayer alloc]init];
    m_layerTips.bounds = CGRectMake(0, 0, 129, 42);
    m_layerTips.position=CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) + 21);
    m_layerTips.contents=(id)[UIImage imageNamedWithWebP:@"闯关失败"].CGImage;
    [self.layer addSublayer:m_layerTips];
    
    //Create Reuslt View
    UIView *viewResult = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) / 2 - 30, CGRectGetWidth(self.frame), 93)];
    viewResult.backgroundColor = [UIColor clearColor];
    viewResult.tag = 50002;
    viewResult.hidden = YES;
    [self addSubview:viewResult];
    
    CALayer* layerSnail = [[CALayer alloc]init];
    layerSnail.bounds = CGRectMake(0, 0, 60, 51);
    layerSnail.position=CGPointMake(CGRectGetWidth(viewResult.frame) / 2, 25);
    layerSnail.contents=(id)[UIImage imageNamedWithWebP:@"snail-fail"].CGImage;
    [viewResult.layer addSublayer:layerSnail];
    
    CALayer* layerTips = [[CALayer alloc]init];
    layerTips.bounds = CGRectMake(0, 0, 129, 42);
    layerTips.position=CGPointMake(CGRectGetWidth(viewResult.frame) / 2, 72);
    layerTips.contents=(id)[UIImage imageNamedWithWebP:@"闯关失败"].CGImage;
    [viewResult.layer addSublayer:layerTips];
    
    //背景全局变黑，时间起始位置为第0毫秒，时间结束位置在第4500毫秒。起始变黑过程250毫秒，颜色值#000000，不透明度opacity：60%
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }completion:nil];
    
    //在时间轴第4250~4500毫秒的位置，不透明度从60%变为0%
    [UIView animateWithDuration:0.25 delay:4.25 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^(void)
     {
         self.backgroundColor = [UIColor clearColor];
     }completion:nil];
    
    //Snail Animal Begin
    [UIView animateWithDuration:1.5 delay:0.25 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^(void)
     {
         imgView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 30, CGRectGetHeight(self.frame) / 2 - 25, 60, 51);
         [self startSnailAnimated];
         
     }completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.75 target:self selector:@selector(stopSnailAnimated) userInfo:nil repeats:NO];
    
    //Start Light Begin
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLightAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.25 target:self selector:@selector(stopLightAnimated) userInfo:nil repeats:NO];
    
    //Fail Snail Animal Path Begin
    [NSTimer scheduledTimerWithTimeInterval:3.75 target:self selector:@selector(groupAnimation) userInfo:nil repeats:NO];
    
    //All Animal Stop
    [NSTimer scheduledTimerWithTimeInterval:4.75 target:self selector:@selector(stopAllAnimated) userInfo:nil repeats:NO];
    
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
        
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void)
         {
             lbSkip.alpha = 0.0;
         }completion:nil];
        
        UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDismiss:)];
        //swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
        [viewBgFront addGestureRecognizer:swipeGestureToRight];
        
        UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDismiss:)];
        swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [viewBgFront addGestureRecognizer:swipeGestureToLeft];
    }
}

-(void)stopSnailAnimated
{
    UIImageView *imgView = (UIImageView*)[self viewWithTag:50000];
    imgView.alpha = 0.0;
    
    [m_mySnailTimer invalidate];
    m_mySnailTimer = nil;
    
    m_layerSnail.hidden = NO;
    
    [self translationTipsAnimation];
}

-(void)startSnailAnimated
{
    m_nSnailImgIndex = 0;
    m_mySnailTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(setNextSnailImage) userInfo:nil repeats:YES];
}

-(void)setNextSnailImage
{
    UIImageView *imgView = (UIImageView*)[self viewWithTag:50000];
    
    if (imgView != nil) {
        imgView.alpha = 1.0;
        imgView.image = m_imagesSnailArr[m_nSnailImgIndex++ % m_imagesSnailArr.count];
    }
}

-(void)startLightAnimated
{
    m_nChangeImgIndex = 0;
    m_myLightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
    [[CommonUtility sharedInstance]playAudioFromName:@"missionfailed.wav"];
}

-(void)setNextImage
{
    UIImageView *imgViewLight = (UIImageView*)[self viewWithTag:50001];
    
    if (imgViewLight != nil) {
        imgViewLight.alpha = 1.0;
        imgViewLight.image = m_imagesLightArr[m_nChangeImgIndex++ % m_imagesLightArr.count];
    }
}

-(void)stopLightAnimated
{
    [m_myLightTimer invalidate];
    m_myLightTimer = nil;
    
    UIImageView *imgViewLight = (UIImageView*)[self viewWithTag:50001];
    imgViewLight.alpha = 0.0;
}

-(void)stopAllAnimated
{
    m_layerSnail.hidden = YES;
    m_layerTips.hidden = YES;
    
    if (m_completeBlock != nil) {
        m_completeBlock();
    }
}

-(void)dealloc
{
    NSLog(@"Dealloc");
}

#pragma mark 基础旋转动画
-(CABasicAnimation *)rotationAnimation{
    
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
-(CAKeyframeAnimation *)translationAnimation{
    UIView *viewResult = (UIImageView*)[self viewWithTag:50002];
    
    [CATransaction begin];
    //[CATransaction setValue:[NSNumber numberWithFloat:1.0] forKey:kCATransactionAnimationDuration];
    
    CAKeyframeAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"position"
                                                                  function:ExponentialEaseOut
                                                                 fromPoint:viewResult.layer.position
                                                                   toPoint:CGPointMake(CGRectGetWidth(self.frame) + 40, CGRectGetHeight(self.frame) / 4 - 20)];
    //[viewResult.layer addAnimation:chase forKey:@"position"];
    
    //[CATransaction commit];
    
    return chase;
    
    /*NSBKeyframeAnimationFunction c = NSBKeyframeAnimationFunctionEaseOutExpo;
     
     float startValue = viewResult.layer.position.x,
     endValue = CGRectGetWidth(m_viewAnimationFail.frame) + 90;
     
     NSBKeyframeAnimation *animation = [NSBKeyframeAnimation animationWithKeyPath:@"position.x"
     duration:1.0
     startValue:startValue
     endValue:endValue
     function:c];
     animation.completionBlock = ^(BOOL finished) {
     if (finished)
     {
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
     viewResult.hidden = YES;
     });
     }
     };
     
     [viewResult.layer setValue:[NSNumber numberWithFloat:(endValue)] forKeyPath:@"position.x"];
     //[viewResult.layer addAnimation:animation forKey:@"position.x"];
     
     //return animation;
     
     
     CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
     
     CGPoint endPoint= CGPointMake(CGRectGetWidth(m_viewAnimationFail.frame) + 190, CGRectGetHeight(m_viewAnimationFail.frame) / 4 - 20);
     CGPathRef path=CGPathCreateMutable();
     CGPathMoveToPoint(path, NULL, viewResult.layer.position.x, viewResult.layer.position.y);
     CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
     
     keyframeAnimation.path=[animation animationPath].CGPath;
     CGPathRelease(path);
     
     [keyframeAnimation setValue:[NSValue valueWithCGPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
     
     return keyframeAnimation;*/
}

#pragma mark 创建动画组
-(void)groupAnimation{
    UIView *viewResult = (UIImageView*)[self viewWithTag:50002];
    viewResult.hidden = NO;
    
    m_layerSnail.hidden = YES;
    m_layerTips.hidden = YES;
    
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *basicAnimation=[self rotationAnimation];
    CAKeyframeAnimation *keyframeAnimation=[self translationAnimation];
    animationGroup.animations=@[basicAnimation,keyframeAnimation];
    animationGroup.duration=1.1;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    animationGroup.beginTime=CACurrentMediaTime();
    
    //3.给图层添加动画
    [viewResult.layer addAnimation:animationGroup forKey:nil];
}

-(void)translationTipsAnimation{
    NSBKeyframeAnimationFunction c = NSBKeyframeAnimationFunctionEaseOutExpo;
    
    float startValue = m_layerTips.position.y,
    endValue = CGRectGetHeight(self.frame) / 2 + 51;
    
    NSBKeyframeAnimation *animation = [NSBKeyframeAnimation animationWithKeyPath:@"position.y"
                                                                        duration:0.75
                                                                      startValue:startValue
                                                                        endValue:endValue
                                                                        function:c];
    animation.completionBlock = ^(BOOL finished) {
        if (finished)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                m_layerTips.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 51);
            });
        }
    };
    
    [m_layerTips setValue:[NSNumber numberWithFloat:(endValue)] forKeyPath:@"position.y"];
    [m_layerTips addAnimation:animation forKey:@"position.y"];
    
    
    
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
 
 #pragma mark - 代理方法
 #pragma mark 动画完成
 -(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
 [CATransaction begin];
 [CATransaction setDisableActions:YES];
 
 //设置动画最终状态
 m_layerTips.position = CGPointMake(CGRectGetWidth(m_viewAnimationFail.frame) / 2, CGRectGetHeight(m_viewAnimationFail.frame) / 2 + 60);
 
 [CATransaction commit];
 }
 */

@end
