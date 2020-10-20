//
//  PlayerView.m
//  仿抖音
//
//  Created by ireliad on 2018/3/19.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerView()
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayerItem *playerItem;
///用来判断当前视频是否准备好播放。
@property(nonatomic,assign)BOOL isReadToPlay;
@end

@implementation PlayerView

#pragma mark - 📓public method
-(void)play{
    [self.player play];
}

-(void)pause{
    [self.player pause];
}

-(void)refreshPlay{
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [self removeStatusObserver];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    [self addStatusObserver];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
}

#pragma mark - 📒life cycle
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self player];
        [self playerLayer];
    }
    return self;
}

-(instancetype)initWithUrl:(NSString *)url
{
    self = [self init];
    if (self) {
        [self setUrl:url];
    }
    return self;
}

-(void)layoutSubviews{
    self.playerLayer.frame = self.bounds;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        PlayerLoadStatus loadStatus = PlayerLoadStatusError;
        switch (status) {
            case AVPlayerItemStatusFailed:
                self.isReadToPlay = NO;
                loadStatus = PlayerLoadStatusError;
                break;
            case AVPlayerItemStatusReadyToPlay:
                self.isReadToPlay = YES;
                loadStatus = PlayerLoadStatusAlready;
                break;
            case AVPlayerItemStatusUnknown:
                self.isReadToPlay = NO;
                loadStatus = PlayerLoadStatusUnknown;
                break;
            default:
                break;
        }
        if ([self.delegate respondsToSelector:@selector(playerView:loadStatus:)]) {
            [self.delegate playerView:self loadStatus:loadStatus];
        }
        return;
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array=self.playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        //        NSLog(@"共缓冲：%.2f",totalBuffer);
        if ([self.delegate respondsToSelector:@selector(playerView:currentTime:)]) {
            [self.delegate playerView:self currentTime:totalBuffer];
        }
    }
}

#pragma mark - 📕delegate

-(void)addStatusObserver
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeStatusObserver
{
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
}

#pragma mark - 📙getter and setter
-(AVPlayer *)player
{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
//        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//            float current=CMTimeGetSeconds(time);
////            float total=CMTimeGetSeconds([self.playerItem duration]);
//            NSLog(@"当前已经播放%.2fs.",current);
//        }];
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current=CMTimeGetSeconds(time);
            float total=CMTimeGetSeconds([weakSelf.playerItem duration]);
            if (current == total) {
                if ([weakSelf.delegate respondsToSelector:@selector(playerViewDidFinish:)]) {
                    [weakSelf.delegate playerViewDidFinish:weakSelf];
                }
            }
        }];
    }
    return _player;
}

-(AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [self.layer addSublayer:_playerLayer];
    }
    return _playerLayer;
}

-(void)dealloc{
    [self removeStatusObserver];
}
@end
