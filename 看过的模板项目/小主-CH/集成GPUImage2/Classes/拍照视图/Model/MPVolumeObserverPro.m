//
//  MPVolumeObserverPro.m
//  CameraDemo
//
//  Created by apple on 2017/4/7.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "MPVolumeObserverPro.h"

@interface MPVolumeObserverPro()

{
    MPVolumeView   *_volumeView;
    float           launchVolume;
    BOOL            _isObservingVolumeButtons;
    BOOL            _suspended;
    int             Isfirst;
    NSString       *strNowVolume;
    NSTimer        *timer;
    NSInteger       secondsElapsed;
    BOOL            isVideoStar;
    BOOL            isVideoEnd;
    float           fVolume;
}

@end
@implementation MPVolumeObserverPro

+(MPVolumeObserverPro*) sharedInstance;
{
    static MPVolumeObserverPro *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MPVolumeObserverPro alloc] init];
    });
    
    return instance;
}

-(id)init
{
    self = [super init];
    if( self ){
        _isObservingVolumeButtons = NO;
        _suspended = NO;
        Isfirst = 0;
        secondsElapsed = 0;
        CGRect frame = CGRectMake(0, -100, 0, 0);
        _volumeView = [[MPVolumeView alloc] initWithFrame:frame];
        [[UIApplication sharedApplication].windows[0] addSubview:_volumeView];
        
    }
    return self;
}


#pragma mark--开始音量的监测
-(void)startObserveVolumeChangeEvents
{
    _suspended = NO;
    isVideoStar = YES;
    isVideoEnd = NO;
    fVolume = [AVAudioSession sharedInstance].outputVolume;
    DLog(@"开加入音量键监听");
    if(_isObservingVolumeButtons)
    {
        return;
    }
    
    
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    
    _isObservingVolumeButtons = YES;
    strNowVolume = [[ NSString stringWithFormat:@"%f",[AVAudioSession sharedInstance].outputVolume ] substringToIndex:4];
    strNowVolume = [strNowVolume  isEqualToString: @"0.00"] ? @"0.05" : strNowVolume;
    strNowVolume = [strNowVolume  isEqualToString: @"1.00"] ? @"0.95" : strNowVolume;
    if ([strNowVolume  isEqual: @"0.05"] || [strNowVolume isEqualToString:@"0.95"])
    {
        //设置音量
        [self setVolume:[strNowVolume floatValue]];
    }
    
    if (!_suspended)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(suspendObserveVolumeChangeEvents:)
                                                     name:UIApplicationWillResignActiveNotification     // -> Inactive
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeObserveVolumeButtonEvents:)
                                                     name:UIApplicationDidBecomeActiveNotification      // <- Active
                                                   object:nil];
        
        //音量改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:)
                                                     name:@"SystemVolumeDidChange" object:nil];
    }

}


/**音量改变的通知*/
-(void) volumeChangeNotification:(NSNotification *) no
{
    static id sender = nil;
    if (sender == nil && no.object) {
        sender = no.object;
    }
    
    NSString * NowChangeVolume = [[ NSString stringWithFormat:@"%f",[[no.userInfo objectForKey:@"AudioVolume"] floatValue] ] substringToIndex:4];
    if (no.object != sender || [NowChangeVolume isEqualToString: strNowVolume]) {
        return;
    }
    
    DLog(@"设置音量");
    [self setVolume:[strNowVolume floatValue]];
    
    if(timer)
    {
        if(secondsElapsed == 1)
        {
            if (isVideoStar)
            {
#pragma mark--播放视频
                if ([self.delegate respondsToSelector:@selector(volumeButtonStarVideoClick:)]) {
                    [self.delegate volumeButtonStarVideoClick:self];
                }
                isVideoStar = NO;
                isVideoEnd = YES;
            }
        }
        secondsElapsed ++;
        [timer invalidate];
        timer=nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                    target:self
                                                  selector:@selector(onTimeFire)
                                                  userInfo:nil
                                                   repeats:NO];
}
/**判断是 播放视频 还是 拍照*/
-(void)onTimeFire
{
    [timer invalidate];
    timer = nil;
    
    if (secondsElapsed > 2)
    {
        if (isVideoEnd) {
            
            secondsElapsed = 0;
#pragma mark--结束播放视频
            DLog(@"结束播放视频");
            if ([self.delegate respondsToSelector:@selector(volumeButtonEndVideoClick:)]) {
                [self.delegate volumeButtonEndVideoClick:self];
                isVideoEnd = NO;
                isVideoStar = YES;
            }
        }
    }
    else
    {
        double delayInSeconds = 0.55;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    #pragma mark--拍照
            if (isVideoStar)
            {
                if ([self.delegate respondsToSelector:@selector(volumeButtonCameraClick:)]) {
                    [self.delegate volumeButtonCameraClick:self];
                }
            }

        });
    }
}



/**app退到后台的通知*/
- (void)suspendObserveVolumeChangeEvents:(NSNotification *)notification
{
    if(_isObservingVolumeButtons)
    {
        _suspended = YES;
        // Call first!
        [self stopObserveVolumeChangeEvents];
        Isfirst = 0;
    }
}
/**app回到前台的通知*/
- (void)resumeObserveVolumeButtonEvents:(NSNotification *)notification
{
    if(_suspended)
    {
        [self startObserveVolumeChangeEvents];
        Isfirst = 0;
        _suspended = NO; // Call last!
    }
}

#pragma mark--停止音量键的监听
-(void)stopObserveVolumeChangeEvents
{
    
    if(!_isObservingVolumeButtons){
        return;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SystemVolumeDidChange" object:nil];
    
    Isfirst = 0;
    [timer invalidate];
    timer=nil;
    secondsElapsed = 0;
    _isObservingVolumeButtons = NO;
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    
}


/**设置音量*/
- (void)setVolume:(float)newVolume
{
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:newVolume animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)dealloc
{
    _suspended = NO;
    Isfirst = 0;
}



@end
