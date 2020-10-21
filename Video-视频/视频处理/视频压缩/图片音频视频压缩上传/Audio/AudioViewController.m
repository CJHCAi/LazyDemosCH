//
//  AudioViewController.m
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/22.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "AudioViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#pragma mark - 1. 导入头文件, 遵循一个协议

#import <AVFoundation/AVFoundation.h>

@interface AudioViewController ()<AVAudioRecorderDelegate>


#pragma mark - 2. 几个属性

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;// 录音机
@property (strong, nonatomic) AVPlayer *audioPlayer;// 音频播放器，用于播放录音文件
@property (strong, nonatomic) AVAudioSession *audioSession;// 音频回话类型

@property (strong, nonatomic) UIButton *startButton;// 开始录音
@property (strong, nonatomic) UIButton *pauseButton;// 暂停录音
@property (strong, nonatomic) UIButton *resumeButton;// 恢复录音
@property (strong, nonatomic) UIButton *stopButton;// 停止录音

@property (strong, nonatomic) UILabel *recordDurationLabel;// 录音时长, 只读, 注意仅仅在录音状态可用

@property (strong, nonatomic) NSTimer *timer;// 录音声波监控, 用来实时更新 audioPowerProgressView
@property (strong, nonatomic) UIProgressView *audioPowerProgressView;// 展示音频的波动

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@", NSHomeDirectory());
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.pauseButton];
    [self.view addSubview:self.resumeButton];
    [self.view addSubview:self.stopButton];
    
    [self.view addSubview:self.recordDurationLabel];
    
    [self.view addSubview:self.audioPowerProgressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.audioPlayer pause];
    
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - 4. 声波监控

- (void)timerAction {
    
    // 更新声波检测器
    [self.audioRecorder updateMeters];// 更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0];// 取得第一个通道的音频, 注意音频强度范围是 -160~0
    CGFloat progress = (power + 40.0) / 160.0;// 但不知道为什么一开始是 -40, 而不是 -160, 所以这里先按起点是 -40 计算
    NSLog(@"power===%f", power);
    NSLog(@"progress===%f", progress);
    [self.audioPowerProgressView setProgress:progress];
    
    // 更新录音时间
    self.recordDurationLabel.text = [NSString stringWithFormat:@"录音时长 : %.2fS", self.audioRecorder.currentTime];
}


#pragma mark - 5. 录音操作

- (void)startButtonAction:(UIButton *)button {
    
    if (![self.audioRecorder isRecording]) {
        
        [self.audioRecorder record];// 首次使用应用时如果调用 record 方法会询问用户是否允许使用麦克风
        self.timer.fireDate = [NSDate distantPast];// timer 有 fire 和 invalidate 两个方法, 前者是开工的意思, 后者是废掉的意思. 那么暂停和继续是怎么模拟出来的? fireDate 指的是 timer 的开始时间, [NSDate distantPast] 代表一个过去的时间, 这里意思就是说什么时候 timer 开工呢? 在一个遥远的过去开工, 所以就达到了开工/继续的效果
        
        self.navigationItem.title = @"录音中...";
    }
}

- (void)pauseButtonAction:(UIButton *)button {
    
    if ([self.audioRecorder isRecording]) {
        
        [self.audioRecorder pause];
        self.timer.fireDate = [NSDate distantFuture];// [NSDate distantFuture] 代表一个未来的时间, 这里意思就是说什么时候 timer 开工呢? 在一个遥远的未来开工, 所以就达到了暂停的效果
        
        self.navigationItem.title = @"已暂停";
    }
}
- (void)resumeButtonAction:(UIButton *)button {
    
    // 恢复录音只需要再次调用开始录音事件, AVAudioSession 会自动化帮你记录上次录音位置并追加录音
    [self startButtonAction:button];
    
    self.navigationItem.title = @"录音中...";
}

- (void)stopButtonAction:(UIButton *)button {
    
    [self.audioRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];
    self.audioPowerProgressView.progress = 0.0;
    
    self.navigationItem.title = @"录音完毕, 播放中...";
}

// 录音机录音完成后的代理方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    // 录音完毕后, 将音频回话类型设置为回放类型, 否则音频播放的声音会变小
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录音完成了!" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.audioPlayer.rate == 0) {
            
            [self.audioPlayer play];
        }
    }];
        
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 3. 懒加载

- (AVAudioRecorder *)audioRecorder {
    
    if (!_audioRecorder) {
    
        // 设置音频会话类型
        self.audioSession = [AVAudioSession sharedInstance];
        // 设置为播放和录音状态, 以便可以在录制完之后播放录音
        [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [self.audioSession setActive:YES error:nil];
        
        // 录音的存储路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *audioFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/audioFolder"];
        if (![fileManager fileExistsAtPath:audioFolder]) {
            
            [fileManager createDirectoryAtPath:audioFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSURL *audioPathUrl = [NSURL fileURLWithPath:[audioFolder stringByAppendingPathComponent:@"/myRecord.caf"]];
        
        /**
         *  音频知识阐述 : 录音之前选好响应的编码格式, 就相当于是音频压缩
            1. 录音的编码格式主流的有 PCM 编码, AAC 编码和 MP3 编码, 其中 PCM 编码格式是未经压缩源数据, 而 AAC 编码和 MP3 编码则是音频文件经过压缩之后的数据;
            2. 录音的输出格式主流的有 caf, aac, mp3, caf 可以存放任意编码格式的数据, 而 aac 和 mp3 则只可以存放与它们相对应类型的编码格式的数据;
            3. 录音数据量的大小和编码格式, 录音质量, 采样频率, 采样位数, 录音通道数以及录音时长都有关系,
               录音数据量大小 = 采样频率 * 采样位数 * 通道数 * 秒数 / 8;
            4. 需要注意的是 iPhone 录音不支持 mp3 编码, 支持 PCM 编码 和 AAC,
                那么采用高质量, 采样频率44100Hz, 采样位数8bits, 单通道进行录音, 结果是
                PCM 编码 : 2.5M / 1min
                AAC 编码 : 0.5M / 1min
                而音质没有很明显差别, 所以推荐使用 AAC 编码
        */
        
        // 录音设置信息
        NSMutableDictionary *settingsDict = [NSMutableDictionary dictionary];
        
        // 录音编码格式 : PCM 编码, 简单地说也就是 iPhone 录下来的未经压缩的源数据, 其它的编码格式(比如 AAC 编码)则已经是经过编码后的录音了
        [settingsDict setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
        
        // 录音质量
        [settingsDict setObject:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];
        
        /**
         *  录音采样频率 : 采样频率越大, 数字化后得到的声音越逼真
            8,000 Hz - 电话所用采样率, 对于人的说话已经足够
            22,050 Hz - 只能达到FM广播的声音品质
            44,100 Hz - 是理论上的CD音质界限
         */
        [settingsDict setObject:@(44100) forKey:AVSampleRateKey];
        
        // 采样位数 : 采样位数越大, 所能记录声音的变化度就越细腻. 通常有分为8bits和16bits
        [settingsDict setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        
        // 设置通道 : 是指处理的声音是单声道还是立体声. 单声道在声音处理过程中只有单数据流, 而立体声则需要左, 右声道的两个数据流. 显然, 立体声的效果要好. 这里采用单声道
        [settingsDict setObject:@(1) forKey:AVNumberOfChannelsKey];
        //...其他设置等等
        
        // 创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioPathUrl settings:settingsDict error:&error];
        _audioRecorder.meteringEnabled = YES;// 是否启动声波监控
        _audioRecorder.delegate = self;
    
        if (error) {
            
            [self.timer invalidate];
            self.timer = nil;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录音机出错了，请稍后重试!" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return nil;
        }
    }
    
    return _audioRecorder;
}

- (AVPlayer *)audioPlayer {
    
    if (!_audioPlayer) {
        
        // 文件大小
        NSData *sourceAudioData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/audioFolder/myRecord.caf"]];
        float sourceAudioSize = (float)sourceAudioData.length / 1024.0 / 1024.0;
        UILabel *sourceAudioSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.audioPowerProgressView.frame) + 40, 160, 20)];
        sourceAudioSizeLabel.backgroundColor = [UIColor purpleColor];
        sourceAudioSizeLabel.text = [NSString stringWithFormat:@"音频 : %.2fM", sourceAudioSize];
        [self.view addSubview:sourceAudioSizeLabel];
        
        // 播放音频
        NSURL *sourceAudioUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/audioFolder/myRecord.caf"]];
        _audioPlayer = [AVPlayer playerWithURL:sourceAudioUrl];
        
        // 音频知识阐述
        UILabel *audioPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sourceAudioSizeLabel.frame) + 40, kScreenWidth, 200)];
        audioPromptLabel.backgroundColor = [UIColor magentaColor];
        audioPromptLabel.numberOfLines = 0;
        audioPromptLabel.text = @"iPhone 录音不支持 mp3 编码, 支持 PCM 和 AAC编码, 那么采用高质量, 采样频率44100Hz, 采样位数8bits, 单通道进行录音, 结果是 :\nPCM 编码 : 2.5M / 1min\nAAC 编码 : 0.5M / 1min\n而音质没有很明显差别, 所以推荐使用 AAC 编码";
        [self.view addSubview:audioPromptLabel];
    }
    
    return _audioPlayer;
}

- (UIButton *)startButton {
    
    if (!_startButton) {
        
        _startButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 80 * 4) / 2.0, 100, 80, 80)];
        _startButton.backgroundColor = [UIColor redColor];
        
        [_startButton setTitle:@"开始录音" forState:(UIControlStateNormal)];
        [_startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _startButton;
}

- (UIButton *)pauseButton {
    
    if (!_pauseButton) {
        
        _pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.startButton.frame), 100, 80, 80)];
        _pauseButton.backgroundColor = [UIColor orangeColor];
        
        [_pauseButton setTitle:@"暂停录音" forState:(UIControlStateNormal)];
        [_pauseButton addTarget:self action:@selector(pauseButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _pauseButton;
}

- (UIButton *)resumeButton {
    
    if (!_resumeButton) {
        
        _resumeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pauseButton.frame), 100, 80, 80)];
        _resumeButton.backgroundColor = [UIColor yellowColor];
        
        [_resumeButton setTitle:@"恢复录音" forState:(UIControlStateNormal)];
        [_resumeButton addTarget:self action:@selector(resumeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _resumeButton;
}

- (UIButton *)stopButton {
    
    if (!_stopButton) {
        
        _stopButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.resumeButton.frame), 100, 80, 80)];
        _stopButton.backgroundColor = [UIColor greenColor];
        
        [_stopButton setTitle:@"停止录音" forState:(UIControlStateNormal)];
        [_stopButton addTarget:self action:@selector(stopButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _stopButton;
}

- (UILabel *)recordDurationLabel {
    
    if (!_recordDurationLabel) {
        
        _recordDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 160) / 2.0, CGRectGetMaxY(self.startButton.frame) + 40, 160, 20)];
        _recordDurationLabel.backgroundColor = [UIColor cyanColor];
        
        _recordDurationLabel.text = @"录音时长 : 0.00S";
    }
    
    return _recordDurationLabel;
}

- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    return _timer;
}
- (UIProgressView *)audioPowerProgressView {
    
    if (!_audioPowerProgressView) {
        
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.recordDurationLabel.frame) + 40, 160, 20)];
        promptLabel.backgroundColor = [UIColor blueColor];
        promptLabel.text = @"声波监控";
        [self.view addSubview:promptLabel];
        
        _audioPowerProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(promptLabel.frame) + 3, kScreenWidth - 40, 5)];
        _audioPowerProgressView.backgroundColor = [UIColor clearColor];
        _audioPowerProgressView.progress = 0.0;
    }
    
    return _audioPowerProgressView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
