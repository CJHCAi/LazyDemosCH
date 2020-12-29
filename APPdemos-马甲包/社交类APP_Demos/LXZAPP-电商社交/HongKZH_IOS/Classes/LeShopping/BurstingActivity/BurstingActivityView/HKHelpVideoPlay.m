//
//  HKHelpVideoPlay.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHelpVideoPlay.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerVideo.h>
@interface HKHelpVideoPlay()
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation HKHelpVideoPlay
- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKHelpVideoPlay" owner:self options:nil].lastObject;
    if (self) {
        self.timeBtn.layer.cornerRadius = 5;
        self.timeBtn.layer.masksToBounds = YES;
        [self.timeBtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3]];
        self.downView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        self.playView = self.iconView;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)AliyunVodPlayerEventFinish{
    if ([self.delegate respondsToSelector:@selector(playFinish)]) {
        [self.delegate playFinish];
    }
    [self reset];
    self.staue = HKPalyStaue_Success;
    self.playBtn.hidden = NO;
}
-(void)timerRun{
    NSInteger currentTime = self.aliPlayer.currentTime;
    NSInteger durationTime = self.aliPlayer.duration;
    if (durationTime - currentTime >0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%lds",durationTime - currentTime];
    }else{
//        [self stop];
       
    }
}
-(void)reset{
    [super reset];
    self.playView = self.iconView;
}
- (IBAction)playBtnClick:(UIButton*)sender {
    if (self.staue == HKPalyStaue_pause) {
        [self  resume];
    }else{
    if ([self.delegate respondsToSelector:@selector(playClick:)]) {
        [self.delegate playClick:sender];
    }
    }
    sender.hidden = YES;
}
-(void)resume{
    [super resume];
    self.playBtn.hidden = YES;
}
-(void)pause{
    if (self.staue == HKPalyStaue_play) {
        [super pause];
        self.playBtn.hidden = NO;
    }
    
}
-(void)dealloc{
    if (self.staue == HKPalyStaue_play||self.staue == HKPalyStaue_resume) {
        [self releasePlayer];
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.nextLabel.text = title;
}


@end
