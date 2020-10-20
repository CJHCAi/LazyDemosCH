//
//  ViewController.m
//  02-AVAudioPlayer
//
//  Created by qingyun on 16/6/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *meterProgress;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//播放器对象
@property(nonatomic,strong)AVAudioPlayer *player;

//声明计时器对象
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

-(NSTimer *)timer{
    if(_timer)return _timer;
    _timer=[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(UpdateProgress) userInfo:nil repeats:YES];
    return _timer;
}
//设置后台播放
-(void)setAudioSession{
 //1.获取会话对象
    AVAudioSession *session=[AVAudioSession sharedInstance];
 //2设置会话策略,后台播放策略
   [session setCategory:AVAudioSessionCategoryPlayback error:nil];
 //3.设置会话生效,策略生效
    [session setActive:YES error:nil];
}



-(AVAudioPlayer *)player{
    if (_player) {
        return _player;
    }
    //初始化对象
    _player=[[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"红颜劫" withExtension:@"mp3"] error:nil];
    //设置代理
    _player.delegate=self;
    //设置循环 1表示循环一次,0 不循环,-1无限循环
    _player.numberOfLoops=0;
    //设置速率可用
    _player.enableRate=YES;
    //设置分贝可用
    _player.meteringEnabled=YES;
    
    //调用硬件设备,准备工作
    [_player prepareToPlay];

    //调用后台播放策略
    [self setAudioSession];
    
    
    return _player;
}

//设置初始值
-(void)loadDataForView{
  //设置音量
    _volumeSlider.maximumValue=1.0;
    _volumeSlider.value=self.player.volume;
   
  //设置播放进度
    _progressSlider.maximumValue=self.player.duration;
    _progressSlider.value=self.player.currentTime;
}

-(void)UpdateMeter{
   //1.更新当前最新分贝值
    [self.player updateMeters];
   //2.获取通道1的平均分贝值
    float value=[self.player averagePowerForChannel:1];
    NSLog(@"=====%f",value);
   //3.更新当前值
    _meterProgress.progress=(value+160)/160.0;
    
}

//更新进度条,播放进度
-(void)UpdateProgress{
    //当前播放时间
    self.progressSlider.value=self.player.currentTime;
    //更新分贝值
    [self UpdateMeter];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataForView];
     //让当前控制器成为第一响应者
    [self becomeFirstResponder];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
//设置播放进度
- (IBAction)rateAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1: //low
            self.player.rate=.5;
            break;
        case 2://正常
            self.player.rate=1;
            break;
        case 3://fast
            self.player.rate=2;
            break;
        default:
            break;
    }

}

//设置播放
- (IBAction)playOrPauseAction:(UIButton *)sender {
    //判断当前播放状态
    if (self.player.isPlaying) {
        //暂停播放
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [self.player pause];
        //暂停定时器
        self.timer.fireDate=[NSDate distantFuture];
    }else{
       //播放
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [self.player play];
        //启动定时器
        self.timer.fireDate=[NSDate date];
    }
}
//设置音量
- (IBAction)changeValueVolume:(UISlider *)sender {
    self.player.volume=sender.value;
}
//设置播放时间
- (IBAction)playChangeValue:(UISlider *)sender {
    self.player.currentTime=sender.value;
}

#pragma mark 远程控制事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
   //处理远程控制事件
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            //播放
            break;
        default:
            break;
    }
    
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
