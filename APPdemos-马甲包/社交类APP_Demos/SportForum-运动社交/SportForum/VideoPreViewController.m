//
//  VideoPreViewController.m
//  SportForum
//
//  Created by liyuan on 5/21/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "VideoPreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDProgressView.h"

@interface VideoPreViewController ()<UIAlertViewDelegate>
{
    UIAlertView* _alertView;
}

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *delButton;
@property (strong, nonatomic) NSURL *videoFileURL;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) SDLoopProgressView *loop;

@end

@implementation VideoPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:16 / 255.0f green:16 / 255.0f blue:16 / 255.0f alpha:1.0f];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.delButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen screenWidth] - 54, 10, 44, 44)];
    [_delButton setImage:[UIImage imageNamed:@"blog-delete"] forState:UIControlStateNormal];
    [_delButton setImage:[UIImage imageNamed:@"blog-delete"] forState:UIControlStateHighlighted];
    [_delButton addTarget:self action:@selector(pressDelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.delButton];

    if (_bIsNetwork) {
        _videoFileURL = [NSURL URLWithString:_strVideoPath];
        
        self.loop = [SDLoopProgressView progressView];
        self.loop.frame = CGRectMake(([UIScreen screenWidth] - 100) / 2, [[UIScreen mainScreen] applicationFrame].size.height / 2 - 50, 100, 100);
        self.loop.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_loop];
    }
    else
    {
        _videoFileURL = [NSURL fileURLWithPath:_strVideoPath];
    }
    
    [self initPlayLayer];
    
    self.playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [_playButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)initPlayLayer
{
    if (!_videoFileURL) {
        return;
    }
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoFileURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, [[UIScreen mainScreen] applicationFrame].size.height / 2 - [[UIScreen mainScreen] applicationFrame].size.width / 2, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.width);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_playerLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addObserverToPlayerItem:self.playerItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self removeObserverFromPlayerItem:self.playerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)pressPlayButton:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
    
    /*if(self.player.rate==0){ //说明时暂停
        [button setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [self.player play];
    }else if(self.player.rate==1){//正在播放
        [self.player pause];
        [button setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }*/
}

- (void)pressBackButton:(UIButton *)button
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)pressDelButton
{
    _alertView = [[UIAlertView alloc] initWithTitle:@"删除视频" message:@"要删除该视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    _alertView.tag = 10;
    [_alertView show];
}

#pragma mark - AlertView Logic

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            
            if ([_delegate respondsToSelector:@selector(videoPreDelete:)]) {
                [_delegate videoPreDelete:self];
            }
            
            [self pressBackButton:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"VideoPreViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _playButton.alpha = 1.0f;
    }];
}


#pragma mark - 通知
/**
 *  添加播放器通知
 
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

 *  播放完成通知
 *
 *  @param notification 通知对象
 
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
}

#pragma mark - 监控
 *  给播放器添加进度更新

-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    UIProgressView *progress=self.progress;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}
*/

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
        else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"视频加载异常，请检查网络~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        
        CMTime duration = _playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        /*NSString *strBuffer = [NSString stringWithFormat:@"%f", totalBuffer];
        NSString *strTotal = [NSString stringWithFormat:@"%f", totalDuration];
        
        NSArray *listBuffer = [strBuffer componentsSeparatedByString:@"."];
        NSArray *listTotal = [strTotal componentsSeparatedByString:@"."];

        NSInteger nBuffer = [listBuffer[0] integerValue];
        NSInteger nTotal = [listTotal[0] integerValue];*/
        
        CGFloat fProcess = totalBuffer / totalDuration;
        
        //去除小数位数不一致带来的进度问题
        if (fProcess >= 0.98) {
            self.loop.progress = 1.0;
        }
        else
        {
            self.loop.progress = fProcess;
        }
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
