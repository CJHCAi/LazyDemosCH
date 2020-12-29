//
//  YXWCalmCosmosViewController.m
//  StarAlarm
//
//  Created by dllo on 16/4/6.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWCalmCosmosViewController.h"
#import "WQPlaySound.h"
#import "XFZ_LocalTime.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface YXWCalmCosmosViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *flayImageView;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIImageView *drewImageView;
//点进去的文字叙述
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UIImageView *tsImageView;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation YXWCalmCosmosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [self creatBackImageView];
    [self creatView];
    [self getPaht];
    [self localTime];
}

- (void)creatNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - 导航左侧返回按钮
-(void)leftButtonAction:(UIBarButtonItem *)barItem {
    [self.player pause];
    [self removeTimer];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)localTime {
    XFZ_LocalTime *localTime = [[XFZ_LocalTime alloc] init];
    localTime.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.1, self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.2);
    [self.backImageView addSubview:localTime];
}


- (void)getPaht {
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Alien Metron"
                                                          ofType:@"mp3"];
    NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL
                                                         error:nil];
    self.player.numberOfLoops = NSIntegerMax;
    [self.player prepareToPlay];
    [self.player play];
    [self setUpTimer];
}


- (void)setUpTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)timerAction {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


- (void)creatBackImageView {
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.backImageView setImage:[UIImage imageNamed:@"task_bg_01"]];
    self.backImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.backImageView];
}

- (void)creatView {
    
    self.flayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.flayImageView.userInteractionEnabled = YES;
    self.flayImageView.center = self.view.center;
    [self.flayImageView setImage:[UIImage imageNamed:@"task_01_planet"]];
    self.flayImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backImageView addSubview:self.flayImageView];
    [self imareRound];
    //提示小图标
    self.tsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2,self.view.frame.size.width /4 - 25 , 20, 20)];
    [self.tsImageView setImage:[[UIImage imageNamed:@"tishi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.view addSubview:self.tsImageView];
    //文字
    self.wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 , self.view.frame.size.width / 4, self.view.frame.size.width / 2 - 30, 60)];
    self.wayLabel.numberOfLines = 5;
    self.wayLabel.font = [UIFont systemFontOfSize:14];
    self.wayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.wayLabel.textColor = [UIColor whiteColor];
    self.wayLabel.text = @"这是一颗美丽的星球，点击关闭一切都平静了";
    [self.view addSubview:self.wayLabel];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clickButton.frame = CGRectMake(0, 0, 200, 200);
    [self.clickButton addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.flayImageView addSubview:self.clickButton];
    
    self.drewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 170, 50, 50)];
    [self.drewImageView setImage:[UIImage imageNamed:@"task_01_spaceman_layer0"]];
    [self.backImageView addSubview:self.drewImageView];
    [self imageMove];
}

- (void)imageMove {
    [UIView animateWithDuration:2.0 animations:^{
        
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationRepeatCount:CGFLOAT_MAX];
        [UIView setAnimationRepeatAutoreverses:YES];
        self.drewImageView.frame = CGRectMake(250, 210, 50, 50);
    }];
}

- (void)clickButtonAction {
//    动画效果，让图片边转圈边消失，在动画执行完后执行后续block方法
    [UIView animateWithDuration:1.0 animations:^{
        self.flayImageView.frame = CGRectMake(0, 0, 0, 0);
        self.flayImageView.center = self.view.center;
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:5];
        [UIView setAnimationDuration:0.1];
        self.flayImageView.transform = CGAffineTransformRotate(self.flayImageView.transform, M_PI*3);
        
    } completion:^(BOOL finished) {
        [self.flayImageView removeFromSuperview
         ];
        [UIView animateWithDuration:2.0 animations:^{
            self.drewImageView.frame = CGRectMake(250, 2000, 50, 50);
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationDuration:1.0];
        }];
        [self.player pause];
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Alarm Close"
                                                              ofType:@"mp3"];
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        [self.player play];
        
        [self removeTimer];
        [[[TAlertView alloc] initWithTitle:@"" message:@"整个世界都安静了" buttons:@[@"起床"] andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }] show];
        
    }];
}

- (void)imareRound {
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 10.0;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = NSIntegerMax;

    [self.flayImageView.layer addAnimation:animation forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
