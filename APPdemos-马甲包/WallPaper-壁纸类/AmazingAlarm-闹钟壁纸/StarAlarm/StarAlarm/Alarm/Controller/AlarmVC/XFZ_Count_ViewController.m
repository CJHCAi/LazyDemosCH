//
//  XFZ_Count_ViewController.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/9.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "XFZ_Count_ViewController.h"
#import "XFZ_LocalTime.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface XFZ_Count_ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *lebelOne;
@property (nonatomic, strong) UILabel *lebelTwo;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *flayImageView;
@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation XFZ_Count_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self imageView];
    [self localTime];
    [self setButton];
    [self labeladd];
    [self getPaht];
    [self creatView];
    [self creatNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [self imareRound];
}

- (void)creatNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

#pragma mark - 导航左侧返回按钮
-(void)leftButtonAction:(UIBarButtonItem *)barItem {
    [self.player pause];
    [self removeTimer];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)creatView {
    self.flayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.flayImageView.userInteractionEnabled = YES;
    self.flayImageView.center = self.view.center;
    [self.flayImageView setImage:[UIImage imageNamed:@"task_02_planet"]];
    self.flayImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backImageView addSubview:self.flayImageView];
    [self imareRound];
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

//添加点击的Button
- (void) setButton {
    
    for (int i = 0; i < 10; i++) {
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.button.backgroundColor = [UIColor colorWithWhite:0.502 alpha:0.500];
        if (i < 5) {
            self.button.frame = CGRectMake(self.view.bounds.size.width * 0.2 * i + 20, self.view.bounds.size.height - 120, 35, 20);
            [self.view addSubview:self.button];
            self.button.titleLabel.text = [NSString stringWithFormat:@"%d", i];
            [self.button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            self.button.frame = CGRectMake(self.view.bounds.size.width * 0.2 * (i - 5) + 20, self.view.bounds.size.height - 80, 35, 20);
            [self.view addSubview:self.button];
            [self.button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            self.button.titleLabel.text = [NSString stringWithFormat:@"%d", i];
            [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        }

    }
}

//加法的label

- (void) labeladd {
    
    self.lebelOne = [[UILabel alloc] init];
    _lebelOne.frame = CGRectMake(self.view.bounds.size.width * 0.3, self.view.bounds.size.height * 0.3, 70, 20);
    self.lebelOne.font = [UIFont systemFontOfSize:20];
    _lebelOne.text = [NSString stringWithFormat:@"%u",arc4random()%50];
    [self.backImageView addSubview:_lebelOne];
    
    self.lebelTwo = [[UILabel alloc] init];
    _lebelTwo.frame = CGRectMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.3, 70, 20);
    self.lebelTwo.font = [UIFont systemFontOfSize:20];
    self.lebelTwo.text = [NSString stringWithFormat:@"%u",arc4random()%50];
    [self.backImageView addSubview:_lebelTwo];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.3, 70, 20);
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"+";
    [self.backImageView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.3, 70, 20);
    label1.font = [UIFont systemFontOfSize:20];
    label1.text = @"=";
    [self.backImageView addSubview:label1];
    
    _addLabel = [[UILabel alloc] init];
    self.addLabel.frame = CGRectMake(self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.3, 50, 20);
    _addLabel.font = [UIFont systemFontOfSize:20];
    _addLabel.backgroundColor = [UIColor colorWithWhite:0.600 alpha:0.600];
    self.addLabel.text = @"?";
    self.addLabel.textAlignment = NSTextAlignmentCenter;
    self.addLabel.textColor = [UIColor colorWithRed:0.172 green:1.000 blue:0.873 alpha:1.000];
    
    [self.backImageView addSubview:self.addLabel];
    
    UILabel *shuoming = [[UILabel alloc] init];
    shuoming.frame = CGRectMake(self.view.bounds.size.width * 0.48, self.view.bounds.size.height * 0.15, 200, 50);
    shuoming.text = @"提示:快速计算出星球的质量，让它停止疯狂的旋转";
    shuoming.textColor = [UIColor colorWithRed:0.9896 green:0.961 blue:1.0 alpha:1.0];
    shuoming.numberOfLines = 2;
    [self.backImageView addSubview:shuoming];
    
}

- (void)changeAddLabel {
    
    if (![self.addLabel.text isEqualToString:@"?"]) {
        if (self.addLabel.text.length == 1) {
            self.addLabel.textColor = [UIColor whiteColor];
        }
        if (self.addLabel.text.length == 2) {
            if (!(self.lebelOne.text.intValue + self.lebelTwo.text.intValue == self.addLabel.text.intValue)) {
                self.addLabel.textColor = [UIColor colorWithRed:0.172 green:1.000 blue:0.873 alpha:1.000];
                self.addLabel.text = @"?";
            } else {
                [self.player pause];
                NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Alarm Close"
                                                                      ofType:@"mp3"];
                NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
                [self.player play];
                
                [self removeTimer];
                
                [[[TAlertView alloc] initWithTitle:@"" message:@"整个世界都安静了" buttons:@[@"起床"] andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }] show];
            }
        }
    }
    
}

- (void)buttonAction:(UIButton *)sender {
    
    if ([self.addLabel.text isEqualToString:@"?"]) {
        self.addLabel.text = sender.titleLabel.text;
    } else {
        NSMutableString *str = [NSMutableString stringWithString:self.addLabel.text];
        [str insertString:sender.titleLabel.text atIndex:str.length];
        self.addLabel.text = str;
    }
    [self changeAddLabel];
    
    
    
};


//添加背景图片
- (void)imageView {
    
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.backImageView setImage:[UIImage imageNamed:@"task_bg_04"]];
    self.backImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.backImageView];
    
}

//添加本地时间
- (void) localTime {
    XFZ_LocalTime *localTime = [[XFZ_LocalTime alloc] init];
    localTime.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.1, self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.2);
    [self.backImageView addSubview:localTime];
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
