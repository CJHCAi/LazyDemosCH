//
//  RecordVoiceViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/29.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "RecordVoiceViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordVoiceViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *recordAgainButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableDictionary *setting;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation RecordVoiceViewController
#pragma mark - 生命周期 Life Cilcle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.songNameTF becomeFirstResponder];
    self.songNameTF.delegate = self;
    
    self.finishButton.hidden = YES;
    self.recordAgainButton.hidden = YES;
}
//录制、完成、试听、暂停
- (IBAction)record:(id)sender {
    if ([self.recordButton.currentImage isEqual:[UIImage imageNamed:@"pause_button"]]) {
        [self.recordButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
        [self.player pause];
        return;
    }
    if ([self.recordButton.currentImage isEqual:[UIImage imageNamed:@"play_button"]]) {
        [self.recordButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateNormal];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:nil];
        self.player.delegate = self;
        [self.player play];
        if (self.timer != nil) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updatePlayerProgress) userInfo:nil repeats:YES];

        return;
    }
    if ([self.recordButton.currentImage isEqual:[UIImage imageNamed:@"recording_button"]]) {
        [self.recordButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
        self.finishButton.hidden = NO;
        self.recordAgainButton.hidden = NO;
        [self.recorder stop];
        return;

    }
    if ([self.recordButton.currentImage isEqual:[UIImage imageNamed:@"record_button"]]) {
        [self.recordButton setImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
        [self.recorder record];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        
        return;

    }
    
}
#pragma mark - 方法 Methods
//录制完成
- (IBAction)finish:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.timer invalidate];
}
//重新录制
- (IBAction)recordAgain:(id)sender {
    //准备保存路径
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];

    NSString *nameCaf = [NSString stringWithFormat:@"huyifan%@.caf",self.songNameTF.text];
    NSURL *url=[[NSURL fileURLWithPath:path]URLByAppendingPathComponent:nameCaf];
    NSLog(@"%@",url);
    self.url = url;
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    // 录音样式
    setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    // 录音采样率，8000是电话采样集，一般的录音已经够用了
    setting[AVSampleRateKey] = @(8000);
    // 设置通道为单通道
    setting[AVNumberOfChannelsKey] = @(1);
    // 设置采样点位数，分为8、16、24、32
    setting[AVLinearPCMBitDepthKey] = @(8);
    // 设置是否使用浮点数采样
    setting[AVLinearPCMIsFloatKey] = @(YES);
    // 音频质量
    setting[AVEncoderAudioQualityKey] = @(AVAudioQualityHigh);
    
    NSError *error = nil;
    self.recorder=[[AVAudioRecorder alloc]initWithURL:self.url settings:self.setting error:&error];
    self.recorder.delegate = self;
    if (error != nil) {
        NSLog(@"Init audioRecorder error: %@",error);
    }else{
        //准备就绪，等待录音，注意该方法会返回Boolean，最好做个成功判断，因为其失败的时候无任何错误信息抛出
        if ([self.recorder prepareToRecord]) {
            NSLog(@"Prepare successful");
        }
    }
    self.finishButton.hidden = YES;
    self.recordAgainButton.hidden = YES;
    [self.recordButton setImage:[UIImage imageNamed:@"record_button"] forState:UIControlStateNormal];
    if (self.timer != nil) {
        [self.timer invalidate];

    }
}
//更新progress
- (void)updateProgress{
    self.progress.progress = (float)self.recorder.currentTime / 300.0;
    int fen = (int)self.recorder.currentTime / 60;
    int miao = (int)self.recorder.currentTime % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",fen,miao];
}
- (void)updatePlayerProgress{
    self.progress.progress = (float)self.player.currentTime / (float)self.player.duration;
    int fen = (int)self.player.currentTime / 60;
    int miao = (int)self.player.currentTime % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",fen,miao];

}
#pragma mark audio delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Finsh playing");
    [self.recordButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Finish record!");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}
#pragma mark UITextField Delegate
//重写 用户触摸self.View时触发
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//完成编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确定歌曲名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定时做的事
        //准备保存路径
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
        NSString *nameCaf = [NSString stringWithFormat:@"huyifan%@.caf",self.songNameTF.text];
        NSURL *url=[[NSURL fileURLWithPath:path]URLByAppendingPathComponent:nameCaf];
        NSLog(@"%@",url);
        self.url = url;
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        // 录音样式
        setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
        // 录音采样率，8000是电话采样集，一般的录音已经够用了
        setting[AVSampleRateKey] = @(8000);
        // 设置通道为单通道
        setting[AVNumberOfChannelsKey] = @(1);
        // 设置采样点位数，分为8、16、24、32
        setting[AVLinearPCMBitDepthKey] = @(8);
        // 设置是否使用浮点数采样
        setting[AVLinearPCMIsFloatKey] = @(YES);
        // 音频质量
        setting[AVEncoderAudioQualityKey] = @(AVAudioQualityHigh);
        
        NSError *error = nil;
        self.recorder=[[AVAudioRecorder alloc]initWithURL:self.url settings:self.setting error:&error];
        self.recorder.delegate = self;
        if (error != nil) {
            NSLog(@"Init audioRecorder error: %@",error);
        }else{
            //准备就绪，等待录音，注意该方法会返回Boolean，最好做个成功判断，因为其失败的时候无任何错误信息抛出
            if ([self.recorder prepareToRecord]) {
                NSLog(@"Prepare successful");
            }
        }

    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
