//
//  HKBurstingVodeoTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingVodeoTableViewCell.h"
#import "HKluckyBurstDetailRespone.h"
#import "UIImageView+HKWeb.h"
#import "HKHelpVideoPlay.h"
#import "HKluckyBurstDetailRespone.h"
@interface HKBurstingVodeoTableViewCell()<HKHelpVideoPlayDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong)HKHelpVideoPlay *playView;
@property (weak, nonatomic) IBOutlet UIView *backVIew;

@property (nonatomic,assign) NSInteger playIndex;
@end

@implementation HKBurstingVodeoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    [self.backVIew addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backVIew).offset(10);
        make.right.bottom.equalTo(self.backVIew).offset(-10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)settingData{
    if (_playIndex <=_vodeoArray.count-1) {
        LuckyBurstDetaiAdvs*model = self.vodeoArray[_playIndex];
        NSString*title = @"最后一个视频";
        if (_vodeoArray.count-1>=_playIndex+1) {
            LuckyBurstDetaiAdvs*nextM = _vodeoArray[_playIndex+1];
            title = nextM.title;
        }
        [self.iconVIew hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:[UIImage imageNamed:@"bkms_sj"]];
        
        self.label.hidden = YES;
        self.playView.hidden = NO;
        self.playView.title = title;
    }else{
        self.iconVIew.image = [UIImage imageNamed:@"bkms_sj"];
        self.label.hidden = NO;
        self.playView.hidden = YES;
        ;
    }
  
    
}
-(void)setVodeoArray:(NSArray *)vodeoArray{
    _vodeoArray = vodeoArray;
    [self settingData];

   
}
-(void)playFinish{
    if ([self.delegate respondsToSelector:@selector(aliyunVodPlayerEventFinish:)]) {
        [self.delegate aliyunVodPlayerEventFinish:[self.vodeoArray[self.playIndex]luckyBurstAdvId]];
    }
    self.playIndex = self.playIndex+1;
}
-(void)playClick:(UIButton *)sender{
    LuckyBurstDetaiAdvs*model =self.vodeoArray[self.playIndex];
    [self.playView playWithVid:model.imgSrc];
}
-(void)setPlayIndex:(NSInteger)playIndex{
    _playIndex = playIndex;
       [self settingData];
    
}
-(HKHelpVideoPlay *)playView{
    if (!_playView) {
        _playView = [[HKHelpVideoPlay alloc]init];
        _playView.delegate = self;
        _playView.hidden = YES;
    }
    return _playView;
}
-(void)pausePlay{
    [self.playView pause];
}
-(void)releasePlayer{
    [self.playView releasePlayer];
}
@end
