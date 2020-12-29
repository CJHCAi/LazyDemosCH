//
//  YXWSmileViewController.m
//  StarAlarm
//
//  Created by dllo on 16/4/6.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWSmileViewController.h"
#import "DSFacialGesturesDetector.h"
#import "RoundProgressView.h"
#import "XFZ_LocalTime.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface YXWSmileViewController ()<DSFacialDetectorDelegate,RoundProgressViewDelegate>

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *smallImageView;
//点进去的文字叙述
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UIImageView *tsImageView;


@property (nonatomic, strong) UIView *cameraPreview;
@property (nonatomic, strong) RoundProgressView *smileProgressView, *leftBlinkProgressView, *rightBlinkProgressView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) DSFacialGesturesDetector *facialGesturesDetector;
@property (nonatomic, strong) UIView *detectedGestureWrapperView;
@property (nonatomic, strong) UILabel *detectedGestureLabel;

@property (nonatomic, strong) NSTimer *shockTimer;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) TAlertView *alertView;
@property (nonatomic, assign) BOOL isOver;

@end


@implementation YXWSmileViewController

const float kTimeToDissmissDetectedGestureLabel = 2.6f;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatBackImageView];
    [self creatNav];
    [self localTime];
    [self setCameraPreview];
    [self setUpTimer];
    [self getPaht];
    _isOver = 0;
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
}

-(void) setCameraPreview {
    self.facialGesturesDetector = [DSFacialGesturesDetector new];
    self.facialGesturesDetector.delegate = self;
    self.cameraPreview =  [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 36 , self.view.frame.size.height /2 -60, self.view.frame.size.width / 3 - 3 , self.view.frame.size.height / 8.5)];
    [self.cameraPreview.layer setCornerRadius:22];
    self.cameraPreview.layer.masksToBounds = YES;
    [self.backImageView addSubview:self.cameraPreview];
    self.facialGesturesDetector.cameraPreviewView = self.cameraPreview;
    
    NSError *error;
    [self.facialGesturesDetector startDetection:&error];
    if (error)
    {
        [self showError:error];
    }
    
    self.smileProgressView = [[RoundProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 -30, self.view.frame.size.height - 60, 60, 60)];
    [self.backImageView addSubview:self.smileProgressView];
    
}

- (void)localTime {
    XFZ_LocalTime *localTime = [[XFZ_LocalTime alloc] init];
    localTime.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.1, self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.2);
    [self.backImageView addSubview:localTime];
}

- (void)creatNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

#pragma mark - Private
-(void)showError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:
      [NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
       message:[error localizedDescription] delegate:nil
       cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}
#pragma mark Facial Detector Delegate

-(void)didRegisterFacialGesutreOfType:(GestureType)facialGestureType withLastImage:(UIImage *)lastImage
{
    self.detectedGestureLabel.text = [NSString stringWithFormat:@"Ok you %@", [DSFacialGesture gestureTypeToString:facialGestureType]];
    self.detectedGestureWrapperView.hidden = NO;
    [self startTimerDetecetedLabelDismisallTimer];
}
-(void)didUpdateProgress:(float)progress forType:(GestureType)facialGestureType
{
    RoundProgressView *progressView = [self getCorrectProgressBasedOnType:facialGestureType];
    progressView.delegate = self;
    progressView.progress = progress;
    
    [self.backImageView addSubview:progressView];
    if (facialGestureType == GestureTypeSmile) {
        NSLog(@"bb");
    }
}

- (void)stopAction {
    [self removeTimer];
    if (!_isOver) {
        [self.player pause];
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Alarm Close"
                                                              ofType:@"mp3"];
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        [self.player play];
        _isOver = YES;
    }
    if (!_alertView) {
        self.alertView = [[TAlertView alloc] initWithTitle:@"" message:@"整个世界都安静了" buttons:@[@"起床"] andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
        }];
        [self.alertView show];
    }
    
}


- (void)setUpTimer {
    self.shockTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_shockTimer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_shockTimer == nil) return;
    [_shockTimer invalidate];
    _shockTimer = nil;
}

- (void)timerAction {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


-(void)startTimerDetecetedLabelDismisallTimer
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeToDissmissDetectedGestureLabel target:self selector:@selector(dismissDetectedLabel) userInfo:nil repeats:NO];
}
-(void)dismissDetectedLabel
{
    [UIView animateWithDuration:0.5 animations:^(){
        self.detectedGestureWrapperView.alpha = 0;
    } completion:^(BOOL finisehd){
        self.detectedGestureWrapperView.hidden = YES;
        self.detectedGestureWrapperView.alpha = 1;
    }];
    
}
-(RoundProgressView *)getCorrectProgressBasedOnType:(GestureType)gestureType
{
    if (gestureType == GestureTypeLeftBlink)
        return self.leftBlinkProgressView;
    
    if (gestureType == GestureTypeRightBlink)
        return self.rightBlinkProgressView;

    if (gestureType == GestureTypeSmile)
        return self.smileProgressView;
    return nil;
}




#pragma mark - 导航左侧返回按钮
-(void)leftButtonAction:(UIBarButtonItem *)barItem {
    [self.player pause];
    [self removeTimer];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -创建试图
- (void)creatBackImageView {
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.backImageView setImage:[UIImage imageNamed:@"wall4"]];
    [self.view addSubview:self.backImageView];
    
    self.smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width /6, self.view.frame.size.height / 3, self.view.frame.size.width / 2 + 100, self.view.frame.size.height / 2)];
    self.smallImageView.image = [UIImage imageNamed:@"yuhangyuan"];
    [self.backImageView  addSubview:self.smallImageView];
    
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
    self.wayLabel.text = self.alarmModel.way;
    NSLog(@"%@",self.alarmModel.way);
    [self.view addSubview:self.wayLabel];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
