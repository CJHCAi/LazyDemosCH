//
//  HKVideoPlayCoverView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoPlayCoverView.h"
#import "AliyunPlayerViewSlider.h"


static NSString * const ALYPVBottomViewDefaultTime          = @"00:00";                //默认时间样式

@interface HKVideoPlayCoverView ()

@property (nonatomic, strong) UIButton *playButton;                 //播放按钮
@property (nonatomic, strong) UILabel *leftTimeLabel;               //左侧时间
@property (nonatomic, strong) UILabel *rightTimeLabel;              //右侧时间

@property (nonatomic, strong) AliyunPlayerViewSlider *playSlider;  //进度条

@property (nonatomic,strong) UIButton *tagButton;   //标签按钮
@property (nonatomic, strong) UILabel *tagLabel;    //标签


@property (nonatomic,strong) UIButton *imageCoverButton;  //封面按钮
@property (nonatomic,strong) UILabel *imageCoverLabel;  //封面按钮

@property (nonatomic,strong) UIButton *finishButton;    //完成Button

@end

@implementation HKVideoPlayCoverView

-(void)dealloc {
    DLog(@"%s",__func__);
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                   frame:CGRectZero
                                                   taget:self
                                                  action:@selector(playButtonClicked:)
                                              supperView:self];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"paiszant"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"zmtks"] forState:UIControlStateSelected];
    }
    return _playButton;
}

- (void)playButtonClicked:(UIButton *)button{
    [button setSelected:!button.isSelected];
    if (self.delegate) {
        [self.delegate HKVideoPlayCoverView:self playButtonClick:button];
    }
}

- (UILabel *)leftTimeLabel{
    if (!_leftTimeLabel) {
        _leftTimeLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:[UIColor whiteColor]
                                              textAlignment:NSTextAlignmentLeft
                                                       font:PingFangSCMedium12
                                                       text:ALYPVBottomViewDefaultTime
                                                 supperView:self];
    }
    return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel{
    if (!_rightTimeLabel) {
        _rightTimeLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:[UIColor whiteColor]
                                              textAlignment:NSTextAlignmentLeft
                                                       font:PingFangSCMedium12
                                                       text:ALYPVBottomViewDefaultTime
                                                 supperView:self];
    }
    return _rightTimeLabel;
}

- (AliyunPlayerViewSlider *)playSlider{
    if (!_playSlider) {
        _playSlider = [[AliyunPlayerViewSlider alloc] init];
        _playSlider.value = 0.0;
        //thumb左侧条的颜色
        _playSlider.minimumTrackTintColor = UICOLOR_HEX(0xffffff);
        _playSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        //thumb图片
        [_playSlider setThumbImage:[UIImage imageNamed:@"zmtjdt"] forState:UIControlStateNormal];
        //手指落下
        [_playSlider addTarget:self action:@selector(progressSliderDownAction:) forControlEvents:UIControlEventTouchDown];
        //手指抬起
        [_playSlider addTarget:self action:@selector(progressSliderUpAction:) forControlEvents:UIControlEventTouchUpInside];
        //value发生变化
        [_playSlider addTarget:self action:@selector(updateProgressSliderAction:) forControlEvents:UIControlEventValueChanged];
        
        [_playSlider addTarget:self action:@selector(cancelProgressSliderAction:) forControlEvents:UIControlEventTouchCancel];
        //手指在外面抬起
        [_playSlider addTarget:self action:@selector(updateProgressUpOUtsideSliderAction:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_playSlider];
    }
    return _playSlider;
}

- (UIButton *)tagButton {
    if (!_tagButton) {
        _tagButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                  frame:CGRectZero
                                                  taget:self
                                                 action:@selector(tagButtonClick:)
                                             supperView:self];
        [_tagButton setImage:[UIImage imageNamed:@"psspbq1"] forState:UIControlStateNormal];
    }
    return _tagButton;
}

- (void)tagButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:tagButtonClick:)]) {
        [self.delegate HKVideoPlayCoverView:self tagButtonClick:sender];
    }
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                             textColor:[UIColor whiteColor]
                                         textAlignment:NSTextAlignmentLeft
                                                  font:PingFangSCRegular11
                                                  text:@"标签" supperView:self];
    }
    return _tagLabel;
}

- (UIButton *)imageCoverButton {
    if (!_imageCoverButton) {
        _imageCoverButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                         frame:CGRectZero
                                                         taget:self
                                                        action:@selector(imageCoverButtonClick:)
                                                    supperView:self];
       // _imageCoverButton.backgroundColor = [UIColor whiteColor];
        _imageCoverButton.layer.cornerRadius = 3;
        _imageCoverButton.layer.masksToBounds = YES;
    }
    return _imageCoverButton;
}

- (void)imageCoverButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:coverImageViewClick:)]) {
        [self.delegate HKVideoPlayCoverView:self coverImageViewClick:sender];
    }
}

- (UILabel *)imageCoverLabel {
    if (!_imageCoverLabel) {
        _imageCoverLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                    textColor:[UIColor whiteColor]
                                                textAlignment:NSTextAlignmentLeft
                                                         font:PingFangSCRegular11
                                                         text:@"封面"
                                                   supperView:self];
    }
    return _imageCoverLabel;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                     frame:CGRectZero
                                                     taget:self
                                                    action:@selector(finishButtonClick:)
                                                supperView:self];
        [_finishButton setImage:[UIImage imageNamed:@"sures21d"] forState:UIControlStateNormal];
    }
    return _finishButton;
}

- (void)finishButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:finishButtonClick:)]) {
        [self.delegate HKVideoPlayCoverView:self finishButtonClick:sender];
    }
}

#pragma mark set方法

- (void)setCoverImage:(UIImage *)image {
    [self.imageCoverButton setImage:image forState:UIControlStateNormal];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self.playSlider setValue:progress animated:YES];
}

#pragma mark 更新进度条

- (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long) seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long) (seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", (long) seconds % 60];
    //format of time
    NSString *format_time = nil;
    if (seconds / 3600 <= 0) {
        format_time = [NSString stringWithFormat:@"%@:%@", str_minute, str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    }
    return format_time;
}

- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime{
    NSString *curTimeStr = [self timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [self timeformatFromSeconds:roundf(durationTime)];
    self.rightTimeLabel.text = totalTimeStr;
    self.leftTimeLabel.text = curTimeStr;
    
    [self.playSlider setValue:currentTime/durationTime animated:YES];
}

#pragma mark 初始化

- (instancetype)initWithDelegate:(id<HKVideoPlayCoverViewDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}


#pragma mark 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(5);
        make.centerY.equalTo(self.playButton);
    }];
    
    [self.rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self.leftTimeLabel);
    }];

    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTimeLabel.mas_right).offset(9);
        make.centerY.equalTo(self.leftTimeLabel);
        make.right.equalTo(self.rightTimeLabel.mas_left).offset(-9);
        make.height.mas_equalTo(4);
    }];

    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.width.height.mas_equalTo(26);
        make.bottom.equalTo(self).offset(-60);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagButton.mas_bottom).offset(13);
        make.centerX.equalTo(self.tagButton);
    }];
    
    [self.imageCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagButton.mas_right).offset(139);
        make.centerY.equalTo(self.tagButton);
        make.width.height.mas_equalTo(26);
    }];
    
    [self.imageCoverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageCoverButton);
        make.top.equalTo(self.tagLabel);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tagButton);
        make.right.equalTo(self).offset(-31);
        make.width.height.mas_equalTo(44);
    }];
}

#pragma mark - slider action
- (void)progressSliderDownAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:dragProgressSliderValue:event:)]) {
        [self.delegate HKVideoPlayCoverView:self dragProgressSliderValue:sender.value event:UIControlEventTouchDown];
    }
}

- (void)updateProgressSliderAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:dragProgressSliderValue:event:)]) {
        [self.delegate HKVideoPlayCoverView:self dragProgressSliderValue:sender.value event:UIControlEventValueChanged];
    }
}

- (void)progressSliderUpAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:dragProgressSliderValue:event:)]) {
        [self.delegate HKVideoPlayCoverView:self dragProgressSliderValue:sender.value event:UIControlEventTouchUpInside];
    }
}

- (void)updateProgressUpOUtsideSliderAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:dragProgressSliderValue:event:)]) {
        [self.delegate HKVideoPlayCoverView:self dragProgressSliderValue:sender.value event:UIControlEventTouchUpOutside];
    }
}

- (void)cancelProgressSliderAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:dragProgressSliderValue:event:)]) {
        [self.delegate HKVideoPlayCoverView:self dragProgressSliderValue:sender.value event:UIControlEventTouchCancel];
    }
}


- (void)aliyunPlayerViewSlider:(AliyunPlayerViewSlider *)slider clickedSlider:(float)sliderValue{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HKVideoPlayCoverView:dragProgressSliderValue:event:)]) {
        [self.delegate HKVideoPlayCoverView:self dragProgressSliderValue:sliderValue event:UIControlEventTouchDownRepeat]; //实际是点击事件
    }
}


@end
