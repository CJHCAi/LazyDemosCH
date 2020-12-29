//
//  RecordSendHeartViewController.m
//  SportForum
//
//  Created by liyuan on 5/27/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "RecordSendHeartViewController.h"
#import "UIViewController+SportFormu.h"
#import "LiveMonitorVC.h"
#import "ZCSHoldProgress.h"
#import "AlertManager.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordSendHeartViewController ()<ZCSHoldProgressDelegate>
{
    CALayer *_layer;
    CALayer *_layer1;
    UIView *_viewTouch;
    int _index;
    NSMutableArray *_images;
    NSArray *_imagesTime;
    
    NSTimer *_myAnimatedTimer;
    
    AVAudioPlayer *_avAudioPlayer;
    
    BOOL _bHandlePress;
}

@end

@implementation RecordSendHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"发送心跳" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;

    _images = [NSMutableArray array];
    for (int i=0; i<7; ++i) {
        NSString *imageName=[NSString stringWithFormat:@"heart-beat-%i",i + 1];
        UIImage *image=[UIImage imageNamedWithWebP:imageName];
        [_images addObject:image];
    }
    
    _imagesTime = @[@(0.2), @(0.1), @(0.1), @(0.2), @(0.1), @(0.1), @(0.2)];
    
    _layer=[[CALayer alloc]init];
    _layer.bounds=CGRectMake(85, 30, 140, 140);
    _layer.position=CGPointMake(155, 100);
    [viewBody.layer addSublayer:_layer];
    
    _layer1 = [[CALayer alloc]init];
    _layer1.bounds=CGRectMake(0, 0, 70, 70);
    _layer1.position=CGPointMake(310 + 70, -70);
    UIImage *image=_images[0];
    _layer1.contents=(id)image.CGImage;//更新图片
    _layer1.hidden = YES;
    [viewBody.layer addSublayer:_layer1];
    
    _viewTouch = [[UIView alloc]initWithFrame:CGRectMake(85, 30, 140, 140)];
    _viewTouch.backgroundColor = [UIColor clearColor];
    [viewBody addSubview:_viewTouch];
    
    LiveMonitorVC* liveMonitorVC = [[LiveMonitorVC alloc]initWithFrame:CGRectMake(0, 200, 310, 100)];
    liveMonitorVC.backgroundColor = [UIColor clearColor];
    [viewBody addSubview:liveMonitorVC];
    
    if (_nHeartRateValue > 0) {
        UILabel * lbRate = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(liveMonitorVC.frame), 290, 30)];
        lbRate.backgroundColor = [UIColor clearColor];
        lbRate.font = [UIFont boldSystemFontOfSize:16];
        lbRate.textColor = [UIColor darkGrayColor];
        lbRate.textAlignment = NSTextAlignmentCenter;
        lbRate.text = [NSString stringWithFormat:@"心率：%ld 次/分", _nHeartRateValue];
        [viewBody addSubview:lbRate];
    }
    
    UILabel * lbTips = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(liveMonitorVC.frame) + 30, CGRectGetWidth(viewBody.frame), 50)];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.font = [UIFont boldSystemFontOfSize:16];
    lbTips.textColor = [UIColor blackColor];
    lbTips.textAlignment = NSTextAlignmentCenter;
    lbTips.numberOfLines = 0;
    [viewBody addSubview:lbTips];
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"长按红心，发送你的心跳\n" attributes:attribs];
    
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@"让同一时段附近运动的Ta一起感知运动韵律！" attributes:attribs];
    
    NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strPer appendAttributedString:strPart2Value];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:10];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [strPer addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strPer length])];
    lbTips.attributedText = strPer;
    
    ZCSHoldProgress *holdProgress = [[ZCSHoldProgress alloc] initWithTarget:self action:@selector(gestureRecogizerTarget:)];
    holdProgress.displayDelay = 0;
    //holdProgress.alpha = 0.7;
    //holdProgress.color = [UIColor redColor];
    //holdProgress.borderSize = 0.5;
    //holdProgress.size = 150;
    holdProgress.rectView = CGRectMake(0, 0, 140, 140);
    holdProgress.minimumPressDuration = 1.5;
    holdProgress.allowableMovement = 10.0; // Move as much as you want
    holdProgress.delegateProcess = self;
    [_viewTouch addGestureRecognizer:holdProgress];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MobClick beginLogPageView:@"发送心跳 - RecordSendHeartViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"发送心跳 - RecordSendHeartViewController"];
    
    [_myAnimatedTimer invalidate];
    _myAnimatedTimer = nil;
    [_avAudioPlayer stop];
    
    [self startChangePngAnimated];
    [self prepAudio];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"发送心跳 - RecordSendHeartViewController"];
    [_myAnimatedTimer invalidate];
    _myAnimatedTimer = nil;
    [_avAudioPlayer stop];
}

#pragma mark - ZCSHoldProcessDelegage

- (void)videoStopTimeEventWhenTouch:(ZCSHoldProgress *)progress
{
    [_myAnimatedTimer invalidate];
    _myAnimatedTimer = nil;
    _layer.hidden = YES;
}

- (void)videoBeginTimeEventWhenLeave:(ZCSHoldProgress *)progress
{
    if (!_bHandlePress) {
        _index = 0;
        _layer.hidden = NO;
        [self startChangePngAnimated];
    }
}

-(void)startChangePngAnimated
{
    if (_index > 6) {
        _index = 0;
    }
    
    UIImage *image=_images[_index];
    _layer.contents=(id)image.CGImage;//更新图片
    
    NSTimeInterval fTime = [_imagesTime[_index++] floatValue];
    _myAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:fTime target:self selector:@selector(startChangePngAnimated) userInfo:nil repeats:NO];
}

- (void)prepAudio
{
    NSError *error;
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/Audios/%@", @"Heartbeat4.wav"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return;
    }
    
    if (_avAudioPlayer == nil) {
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]error:&error];
    }
    
    if (!_avAudioPlayer)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    _avAudioPlayer.numberOfLoops = -1;
    [_avAudioPlayer setVolume:5];
    [_avAudioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RecordSendHeartViewController dealloc called!");
}

- (void)gestureRecogizerTarget:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _bHandlePress = YES;
        UIImage *image=_images[0];
        _layer.contents=(id)image.CGImage;//更新图片
        _layer.hidden = NO;
        [self groupAnimation];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

#pragma mark 基础旋转动画
-(CABasicAnimation *)rotationAnimation{
    
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat toValue=M_PI_2*3;
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI_2*3];
    
    //    basicAnimation.duration=6.0;
    basicAnimation.autoreverses=true;
    basicAnimation.repeatCount=HUGE_VALF;
    basicAnimation.removedOnCompletion=NO;
    
    [basicAnimation setValue:[NSNumber numberWithFloat:toValue] forKey:@"KCBasicAnimationProperty_ToValue"];
    
    return basicAnimation;
}

#pragma mark 关键帧移动动画
-(CAKeyframeAnimation *)translationAnimation{
    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGPoint endPoint= CGPointMake(310 + 70, -70 );
    CGPathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 155, 100);
    CGPathAddCurveToPoint(path, NULL, 195, 60, 235, 20, endPoint.x, endPoint.y);
    
    keyframeAnimation.path=path;
    CGPathRelease(path);
    
    [keyframeAnimation setValue:[NSValue valueWithCGPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];

    return keyframeAnimation;
}

#pragma mark 创建动画组
-(void)groupAnimation{
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *basicAnimation=[self rotationAnimation];
    CAKeyframeAnimation *keyframeAnimation=[self translationAnimation];
    animationGroup.animations=@[basicAnimation,keyframeAnimation];
    
    animationGroup.delegate=self;
    animationGroup.duration = 1.0;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    animationGroup.beginTime=CACurrentMediaTime();
    
    //3.给图层添加动画
    [_layer1 addAnimation:animationGroup forKey:nil];
    
    _layer.hidden = YES;
    _layer1.hidden = NO;
}

#pragma mark - 代理方法
#pragma mark 动画完成
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CAAnimationGroup *animationGroup=(CAAnimationGroup *)anim;
    CABasicAnimation *basicAnimation=animationGroup.animations[0];
    CAKeyframeAnimation *keyframeAnimation=animationGroup.animations[1];
    CGFloat toValue=[[basicAnimation valueForKey:@"KCBasicAnimationProperty_ToValue"] floatValue];
    CGPoint endPoint=[[keyframeAnimation valueForKey:@"KCKeyframeAnimationProperty_EndPosition"] CGPointValue];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    //设置动画最终状态
    _layer1.position=endPoint;
    _layer1.transform=CATransform3DMakeRotation(toValue, 0, 0, 1);
    _layer1.hidden = YES;
    
    [CATransaction commit];
    
    [_avAudioPlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_strRecordId.length > 0) {
        
        [[SportForumAPI sharedInstance]userSendHeartByRecordId:_strRecordId FinishedBlock:^(int errorCode)
         {
         }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
