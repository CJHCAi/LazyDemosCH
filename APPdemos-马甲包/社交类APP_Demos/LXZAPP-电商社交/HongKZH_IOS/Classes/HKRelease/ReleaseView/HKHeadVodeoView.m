//
//  HKHeadVodeoView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHeadVodeoView.h"
#import "WHFullAliyunVideoView.h"
#import "UIImageView+HKWeb.h"
@interface HKHeadVodeoView()<WHFullAliyunVideoViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong)WHFullAliyunVideoView *videoView;
@end

@implementation HKHeadVodeoView
- (instancetype)init
{
    self =[[HKHeadVodeoView alloc] initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKHeadVodeoView" owner:self options:nil].firstObject;
        self.frame = frame;
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(void)playAliyunVodPlayerEventFinish{
    if ([self.delegate respondsToSelector:@selector(playFinish)]) {
        [self.delegate playFinish];
    }
}
-(void)addVideoViewWithUrlString:(NSString*)urlString{
    [self.videoView removeFromSuperview];
    [self addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.uslString = urlString;
}

-(void)setUslString:(NSString *)uslString{
    _uslString = uslString;
    self.staue = HKPalyStaue_play;
}
-(void)setStaue:(HKPalyStaue)staue{
    _staue = staue;
    if (staue == HKPalyStaue_play|| staue == HKPalyStaue_resume) {
        if (staue == HKPalyStaue_play) {
            [self.videoView resume];
        }
        [self.videoView playWithVid:_uslString];
    }else{
        [self.videoView stop];
    }
    if ([self.delegate respondsToSelector:@selector(updatePlayHead:)]) {
        [self.delegate updatePlayHead:staue];
    }
}
-(void)setIconUrl:(NSString *)iconUrl{
    _iconUrl = iconUrl;
    [self.iconView hk_sd_setImageWithURL:iconUrl placeholderImage:kPlaceholderImage];
}

-(void)playSurplusTime:(NSInteger)surplusTime{
    if ([self.delegate respondsToSelector:@selector(surplusTime:)]) {
        [self.delegate surplusTime:surplusTime];
    }
}
-(WHFullAliyunVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[WHFullAliyunVideoView alloc]init];
        _videoView.type = 1;
        _videoView.delegate = self;
    }
    return _videoView;
}
-(void)maxPlayClick:(HKPalyStaue)staue{
    self.staue = staue;
}
@end
