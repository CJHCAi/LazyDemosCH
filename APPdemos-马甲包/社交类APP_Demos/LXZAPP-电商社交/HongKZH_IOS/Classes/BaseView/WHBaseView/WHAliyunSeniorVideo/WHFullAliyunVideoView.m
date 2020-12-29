//
//  WHFullAliyunVideoView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "WHFullAliyunVideoView.h"
#import "UIImageView+HKWeb.h"
#import "UIImage+YY.h"
@interface WHFullAliyunVideoView()
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;
@property (weak, nonatomic) IBOutlet UIView *playToolView;
@property (weak, nonatomic) IBOutlet UILabel *meroL;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolH;
@property (weak, nonatomic) IBOutlet UIView *downToolView;
@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UIView *shopView;
@property (weak, nonatomic) IBOutlet UIButton *playMaxBtn;
@property(nonatomic, assign) BOOL isShowTool;
@end

@implementation WHFullAliyunVideoView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"WHFullAliyunVideoView" owner:self options:nil].lastObject;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.playView = self.iconView;
        UIImage *image = [[UIImage createImageWithColor:[UIColor colorWithRed:238.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] size:CGSizeMake(10, 10)]zsyy_imageByRoundCornerRadius:5];
        [self.videoSlider  setThumbImage:image forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolShowOrHide)];
        [self.iconView addGestureRecognizer:tap];
        self.isShowTool = NO;
        self.playMaxBtn.hidden = NO;
        self.meroL.userInteractionEnabled =YES;
        UITapGestureRecognizer *tal =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ml)];
        [self.meroL addGestureRecognizer:tal];
    }

    return self;
}
- (IBAction)playMaxClick:(id)sender {
    if (self.staue == HKPalyStaue_pause) {
        [self resume];
    }else if(self.staue == HKPalyStaue_play||self.staue == HKPalyStaue_resume){
        [self pause];
    }else{
        [self playWithVid:self.vid];
    }
    if ([self.delegate respondsToSelector:@selector(maxPlayClick:)]) {
        if ([self.delegate respondsToSelector:@selector(maxPlayClick:)]) {
            [self.delegate maxPlayClick:self.staue];
        }
    }
}

-(void)ml {
    if (self.delegate && [self.delegate respondsToSelector:@selector(more)]) {
        [self.delegate more];
    }
}
-(void)showTool{
    [UIView animateWithDuration:0.1 animations:^{
        self.playMaxBtn.hidden = NO;
        self.playToolView.hidden = NO;
    }completion:^(BOOL finished) {
        self->_isShowTool = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                self.playToolView.hidden = YES;
                self.playMaxBtn.hidden = YES;
            }completion:^(BOOL finished) {
                self->_isShowTool = NO;
            }];
        });
    }];
    
}
-(void)setStaue:(HKPalyStaue)staue{
    [super setStaue:staue];
    if (staue==HKPalyStaue_play||staue == HKPalyStaue_resume) {
        self.playBtn.selected = NO;
        self.playMaxBtn.selected = YES;
        if (!self.isShowTool) {
            self.playMaxBtn.hidden = YES;
        }else{
            self.playMaxBtn.hidden = NO;
        }
    }else{
        self.playBtn.selected = YES;
        self.playMaxBtn.selected = NO;
    }
    
}
-(void)timerRun{
    NSTimeInterval currentPlayTime = self.aliPlayer.currentTime;
    NSTimeInterval totloTime = self.aliPlayer.duration;
    self.videoSlider.value = currentPlayTime/totloTime;
    self.playIngTime.text = [self getTime:currentPlayTime];
    if ([self.delegate respondsToSelector:@selector(playSurplusTime:)]) {
        [self.delegate playSurplusTime:totloTime-currentPlayTime];
    }
}
-(void)playBtnClick{
    if (self.staue == HKPalyStaue_play||self.staue == HKPalyStaue_resume) {
        [self pause];
    }else if (self.staue == HKPalyStaue_pause){
        [self resume];
    }else{
        [self playWithVid:self.dataM.data.imgSrc];
    }
}
-(void)setDataM:(GetMediaAdvAdvByIdRespone *)dataM{
    _dataM = dataM;
    self.znum.text = dataM.data.praiseCount;
    self.commitNum.text = dataM.data.commentCount;
    self.save.text= dataM.data.collectionCount;
    self.titleL.text = dataM.data.title;
    [self.iconView hk_sd_setImageWithURL:dataM.data.coverImgSrc placeholderImage:kPlaceholderImage];
    if (_dataM.data.praiseState.integerValue == 1) {
        self.praiseIcon.image = [UIImage imageNamed:@"vertical_praiseH"];
    }else{
         self.praiseIcon.image = [UIImage imageNamed:@"vertical_praise"];
    }
    if (dataM.data.collectionState.integerValue == 1) {
        self.saveIcon.image = [UIImage imageNamed:@"vertical_collectionH"];
    }else{
        self.saveIcon.image = [UIImage imageNamed:@"vertical_collection"];
    }
    if ([[VersionAuditStaueTool sharedVersionAuditStaueTool]isAuditAdopt]) {
        self.rewardView.hidden = NO;
    }else{
        self.rewardView.hidden = YES;
    }
    if (dataM.data.products.count>0) {
        self.shopView.hidden = NO;
    }else{
        self.shopView.hidden = YES;
    }
}
-(void)setModel:(SelfMediaModelList *)model{
    _model = model;
    if (self.dataM) {
        [self setDataM:_dataM];
        return;
    }
    self.znum.text = model.praiseCount;
    self.commitNum.text = model.rewardCount;
    self.titleL.text = model.title;
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
}
-(void)setIsShowTool:(BOOL)isShowTool{
    _isShowTool = isShowTool;
    if (isShowTool) {
        [self showTool];
    }else{
        self.playToolView.hidden = YES;
        self.playMaxBtn.hidden = YES;
    }
}
-(void)toolShowOrHide{
    self.isShowTool = !self.isShowTool;
}
- (IBAction)clickToolView:(UIButton*)sender {
    
    if ([self.delegate respondsToSelector:@selector(toolClick:)]) {
        [self.delegate toolClick:sender];
    }
}
-(void)setType:(int)type{
    _type = type;
    if (type == 1) {
        self.downToolView.hidden = YES;
        self.toolH.constant = 0;
        [self.aliPlayer setDisplayMode:AliyunVodPlayerDisplayModeFit];
    }else{
        self.downToolView.hidden = NO;
        self.toolH.constant = 75;
        [self.aliPlayer setDisplayMode:AliyunVodPlayerDisplayModeFitWithCropping];
    }
    
}
-(void)AliyunVodPlayerEventPrepareDone{
     self.totleTime.text = [self getTime:self.aliPlayer.duration];
    [super AliyunVodPlayerEventPrepareDone];

   
}
-(void)AliyunVodPlayerEventFinish{
    [super AliyunVodPlayerEventFinish];
    if ([self.delegate respondsToSelector:@selector(playAliyunVodPlayerEventFinish)]) {
        [self.delegate playAliyunVodPlayerEventFinish];
    }
}
-(void)setSuperView:(UIView *)superView{
    _superView = superView;
    [self viewTransparentView];
    [self removeFromSuperview];
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}
- (IBAction)progressChange:(UISlider *)sender {
    NSTimeInterval currentPlayTime = self.aliPlayer.currentTime;
    NSTimeInterval totloTime = self.aliPlayer.duration;
    if (sender.value < currentPlayTime/totloTime) {
        [self.aliPlayer seekToTime:totloTime*sender.value];
    }
    
}
@end
