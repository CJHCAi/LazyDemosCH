//
//  HKExpectVideoTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKExpectVideoTableViewCell.h"
#import "WHFullAliyunVideoView.h"
#import "UIImageView+HKWeb.h"
@interface HKExpectVideoTableViewCell()<WHFullAliyunVideoViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, strong)WHFullAliyunVideoView *playView;
@end


@implementation HKExpectVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView);
    }];
}
-(void)setPlayType:(HKPalyStaue)playType{
    _playType = playType;
    if (playType == HKPalyStaue_End||playType == HKPalyStaue_stop) {
        [self.playView stop];
        self.playBtn.hidden = NO;
    }else if (playType == HKPalyStaue_pause){
        [self.playView pause];
        self.playBtn.hidden = NO;
    }else if (playType == HKPalyStaue_play){
        [self.playView reset];
        [self.playView playWithVid:self.videoId];
    }else if(playType == HKPalyStaue_resume){
        [self.playView resume];
    }
    if ([self.delegate respondsToSelector:@selector(updatePlay:)]) {
        [self.delegate updatePlay:_playType];
    }
}
-(void)maxPlayClick:(HKPalyStaue)staue{
    self.playType = staue;
}
-(void)playVideo:(UIButton*)sender{
    self.playType = HKPalyStaue_play;
}
-(WHFullAliyunVideoView *)playView{
    if (!_playView) {
        _playView = [[WHFullAliyunVideoView alloc]init];
        _playView.delegate = self;
        _playView.type = 1;
        
//        _playView.hidden = YES;
    }
    return _playView;
}
-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    if (imageStr.length>0) {
        [self.iconView hk_sd_setImageWithURL:imageStr placeholderImage:kPlaceholderImage];
    }
    
    self.playView.vid = self.videoId;
}
@end
