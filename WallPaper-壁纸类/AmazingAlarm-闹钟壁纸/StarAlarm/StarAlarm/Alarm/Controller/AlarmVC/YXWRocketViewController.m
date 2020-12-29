//
//  YXWRocketViewController.m
//  StarAlarm
//
//  Created by dllo on 16/4/6.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWRocketViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "XFZ_LocalTime.h"

@interface YXWRocketViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *rocket;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIImageView *fireImageView;
@property (nonatomic, strong) UIImageView *tsImageView;
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UIImageView *wenduJi;
@property (nonatomic, strong) TAlertView *alertView;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *shockTimer;

@end

@implementation YXWRocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatBackImageView];
    [self localTime];
    [self creatNav];
    [self creatView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getPath];
    [self fireRedy];
}

- (void)creatNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

#pragma mark - 导航左侧返回按钮
-(void)leftButtonAction:(UIBarButtonItem *)barItem {
    [self.player pause];
    [self removeTimer];
    [self removeShockTimer];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)localTime {
    XFZ_LocalTime *localTime = [[XFZ_LocalTime alloc] init];
    localTime.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.1, self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.2);
    [self.backImageView addSubview:localTime];
}

- (void)getPath {
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Alien Metron"
                                                          ofType:@"mp3"];
    NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL
                                                         error:nil];
    self.player.numberOfLoops = NSIntegerMax;
    [self.player prepareToPlay];
    [self.player play];
    [self setUpShockTimer];
}



- (void)creatBackImageView {
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.backImageView setImage:[UIImage imageNamed:@"task_bg_04"]];
    [self.view addSubview:self.backImageView];
}

- (void)creatView {
    
    self.tsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2,self.view.frame.size.width /4 - 25 , 20, 20)];
    [self.tsImageView setImage:[[UIImage imageNamed:@"tishi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.view addSubview:self.tsImageView];
    //文字
    self.wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 , self.view.frame.size.width / 4, self.view.frame.size.width / 2 - 30, 60)];
    self.wayLabel.numberOfLines = 5;
    self.wayLabel.font = [UIFont systemFontOfSize:14];
    self.wayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.wayLabel.textColor = [UIColor whiteColor];
    self.wayLabel.text = @"用力摇晃手机燃料达到最满, 飞向未知宇宙, 浩瀚无垠！";
    [self.view addSubview:self.wayLabel];

    
    self.rocket = [[UIImageView alloc] initWithFrame:CGRectMake(30, 200 * myScale, 150 * myScale, 400 * myScale)];
    [self.rocket setImage:[UIImage imageNamed:@"task_space_shuttle"]];
    [self.backImageView addSubview:self.rocket];
    
    self.fireImageView = [[UIImageView alloc] init];
    [self.backImageView addSubview:self.fireImageView];
    [self.fireImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rocket.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(self.rocket.frame.size.width - 30, 90));
        make.top.equalTo(self.rocket.mas_bottom).offset(0);
    }];
    [self.fireImageView setImage:[UIImage imageNamed:@"task_space_shuttle_fire"]];
    
    self.wenduJi = [[UIImageView alloc] init];
    [self.backImageView addSubview:self.wenduJi];
    [self.wenduJi setImage:[UIImage imageNamed:@"wendu"]];
    [self.wenduJi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rocket.mas_right).offset(80);
        make.size.mas_equalTo(CGSizeMake(40, self.rocket.bounds.size.height - 120));
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
    
    self.addView = [[UIView alloc] initWithFrame:CGRectMake(10, self.rocket.bounds.size.height - (120 + 40 * myScale), 20, 0)];
    self.addView.backgroundColor = [UIColor colorWithRed:0.8024 green:0.1404 blue:0.178 alpha:1.0];
    [self.wenduJi addSubview:self.addView];
}

- (void)setUpTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)setUpShockTimer {
    
    self.shockTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(shockAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.shockTimer forMode:NSRunLoopCommonModes];
}

- (void)removeShockTimer {
    if (self.shockTimer == nil) return;
    [_shockTimer invalidate];
    _shockTimer = nil;
}

- (void)shockAction {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)fireRedy {
    [UIView animateWithDuration:2.0 animations:^{
       
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelay:1.0];
        [UIView setAnimationRepeatCount:NSIntegerMax];
        self.fireImageView.alpha = 0.4;

    }];
}

- (void)timerAction {

    CGFloat hight = self.addView.frame.origin.y;
    CGFloat hig = self.addView.frame.size.height;
    [UIView animateWithDuration:2.0 animations:^{
        self.addView.frame = CGRectMake(10, hight + 10, 20, hig - 10);
        [UIView setAnimationRepeatAutoreverses:YES];
    }];
    if (hight >= 600 || hig < 20) {
        [self removeTimer];
    }
}

// 摇一摇开始
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self removeTimer];
    CGFloat hight = self.addView.frame.origin.y;
    CGFloat hig = self.addView.frame.size.height;
    [UIView animateWithDuration:1.0 animations:^{
        self.addView.frame = CGRectMake(10, hight - 20, 20, hig + 20);
        [UIView setAnimationRepeatAutoreverses:YES];
    }];
    if (hig >= _wenduJi.frame.size.height * 0.65) {
        [UIView animateWithDuration:2.0 animations:^{
            self.rocket.frame = CGRectMake(30, -700, 150, 400);
            [UIView setAnimationRepeatAutoreverses:YES];
        } completion:^(BOOL finished) {
            
            [self.player pause];
            NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Alarm Close"
                                                                  ofType:@"mp3"];
            NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            [self.player play];
            [self removeTimer];
            [self removeShockTimer];
            if (!_alertView) {
                self.alertView = [[TAlertView alloc] initWithTitle:@"" message:@"大兄弟，看来的手臂还是很有力的嘛" buttons:@[@"起床"] andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
                [self.alertView show];
            }
        }];
;
    }
}
// 摇一摇结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self setUpTimer];
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
