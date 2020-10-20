//
//  MusicCell.m
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "MusicCell.h"
#import "MusicModel.h"
#import "PlayerView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HeartAnimation.h"
#import "CommentActionSheet.h"
#import "CCAnimationBtn.h"
@interface MusicCell()<PlayerViewDelegate>
@property(nonatomic,strong)PlayerView *playerView;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UILabel *atLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *musicNameLabel;
@property(nonatomic,strong)UIButton * backBtn;
@property(nonatomic,strong)UIButton * commentBtn;
@property(nonatomic,strong)CCAnimationBtn * likeButton;
@end

@implementation MusicCell
#pragma mark - 📓public method
-(void)setModel:(CardModel *)model
{
    [super setModel:model];
    self.bgImageView.hidden = NO;
    MusicModel *musicModel = (MusicModel*)model;
    self.playerView.url = musicModel.video.play_addr.url_list.firstObject;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.video.cover.url_list.firstObject]];
    self.atLabel.text = [NSString stringWithFormat:@"@%@", musicModel.author.nickname];
    self.contentLabel.text = musicModel.desc;
    self.musicNameLabel.text = musicModel.music.title;
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.music.cover_large.url_list.firstObject]];
}

-(void)play
{
    [self.playerView refreshPlay];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.z";
    animation.duration = 3;
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = MAXFLOAT;
    [self.musicImageView.layer addAnimation:animation forKey:nil];
}

-(void)pause
{
    [self.playerView pause];
}

#pragma mark - 📒life cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //点心动画
        [self seupHeartAnimation];
        
        [self playerView];
        [self bgImageView];
        [self musicNameLabel];
        [self contentLabel];
        [self atLabel];
        [self backBtn];
        [self musicImageView];
        [self commentBtn];
        [self likeButton];
        
    }
    return self;
}


-(void)seupHeartAnimation{
    UIView * tagView=[[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:tagView];
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired=2;
    [self addGestureRecognizer:tap];
}

-(void)handleTap:(UITapGestureRecognizer *)tap{
    [[HeartAnimation sharedManager] createHeartWithTap:tap];
}

#pragma mark - PlayerViewDelegate
-(void)playerView:(PlayerView *)playerView loadStatus:(PlayerLoadStatus)loadStatus
{
    
}

-(void)playerView:(PlayerView *)playerView currentTime:(NSTimeInterval)currentTime
{
    if (currentTime > 2) {
        self.bgImageView.hidden = YES;
        
    }
}

-(void)playerViewDidFinish:(PlayerView *)playerView
{
    [self play];
}


#pragma mark - 📙getter and setter
-(PlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[PlayerView alloc] init];
        [self addSubview:_playerView];
        [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _playerView.delegate = self;
    }
    return _playerView;
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _bgImageView;
}

-(UILabel *)musicNameLabel
{
    if (!_musicNameLabel) {
        _musicNameLabel = [UILabel new];
        _musicNameLabel.font = [UIFont systemFontOfSize:15];
        _musicNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_musicNameLabel];
        [_musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.bottom.equalTo(self).offset(-60);
        }];
    }
    return _musicNameLabel;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.preferredMaxLayoutWidth = 150;
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.bottom.equalTo(self.musicNameLabel.mas_top).offset(-10);
            make.width.mas_equalTo(150);
        }];
    }
    return _contentLabel;
}

-(UILabel *)atLabel
{
    if (!_atLabel) {
        _atLabel = [UILabel new];
        _atLabel.font = [UIFont systemFontOfSize:15];
        _atLabel.textColor = [UIColor whiteColor];
        [self addSubview:_atLabel];
        [_atLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.bottom.equalTo(self.contentLabel.mas_top).offset(-10);
        }];
    }
    return _atLabel;
}

-(UIImageView *)musicImageView
{
    if (!_musicImageView) {
        _musicImageView = [UIImageView new];
        _musicImageView.layer.cornerRadius = 22.5;
        _musicImageView.layer.masksToBounds = YES;
        _musicImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _musicImageView.layer.borderWidth = 1;
        [self addSubview:_musicImageView];
        [_musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self.musicNameLabel);
            make.width.height.mas_equalTo(45);
        }];
    }
    return _musicImageView;
}
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_musicImageView.mas_top).mas_equalTo(-20);
            make.centerX.mas_equalTo(_musicImageView.mas_centerX);
        }];
    }
    return _commentBtn;
}
-(CCAnimationBtn *)likeButton{
    if (!_likeButton) {
        _likeButton=[[CCAnimationBtn alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_commentBtn.mas_top).mas_equalTo(-20);
            make.centerX.mas_equalTo(_commentBtn.mas_centerX);
            make.width.height.mas_equalTo(60);
        }];
    }
    return _likeButton;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"topbar_back_white"] forState:UIControlStateNormal];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(10);
        }];
        
    }
    return _backBtn;
}



#pragma mark-各种点击事件
-(void)goBack{
    if ([self.deledate respondsToSelector:@selector(MusicCellGoBack:)]) {
        [self.deledate MusicCellGoBack:self];
    }
}
-(void)commentBtnClicked{
    if ([_deledate respondsToSelector:@selector(MusicCellCommentBtnClicked)]) {
        [_deledate MusicCellCommentBtnClicked];
    }
}
-(void)likeButtonClicked:(CCAnimationBtn *)btn{
    btn.selected=!btn.selected;
}
@end
