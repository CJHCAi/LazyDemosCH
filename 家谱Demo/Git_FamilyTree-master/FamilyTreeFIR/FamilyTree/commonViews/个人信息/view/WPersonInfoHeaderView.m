//
//  WPersonInfoHeaderView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WPersonInfoHeaderView.h"

@implementation WPersonInfoHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self addSubview:self.headImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.eduLabel];
    [self addSubview:self.sexImage];
    [self addSubview:self.intertsLabel];
    [self addSubview:self.jobLabel];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.focusBtn];
    [self addSubview:self.timeLabel];
}
#pragma mark *** getters ***
-(UIImageView *)headImage{
    if (!_headImage) {
        
        UIImageView *baImageView = [[UIImageView alloc] initWithFrame:AdaptationFrame(46, 30, 150, 150)];
        baImageView.image = MImage(@"gr_tx_bg");
        [self addSubview:baImageView];
        
        _headImage = [[UIImageView alloc] initWithFrame:AdaptationFrame(51, 35, 140, 140)];
        _headImage.layer.cornerRadius = 70*AdaptationWidth();
        _headImage.clipsToBounds = true;
    }
    return _headImage;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.headImage)/AdaptationWidth()+30, 50, 165, 50)];
        _nameLabel.text = @"无";
        _nameLabel.font = WFont(38);
        _nameLabel.textAlignment = 0;
    }
    return _nameLabel;
}
-(UIImageView *)sexImage{
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc] initWithFrame:AdaptationFrame(CGRectXW(self.nameLabel)/AdaptationWidth(), 55, 50, 30)];
        _sexImage.image = MImage(@"gr_girl");
        _sexImage.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _sexImage;
}
-(UILabel *)eduLabel{
    if (!_eduLabel) {
        _eduLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.headImage)/AdaptationWidth()+30, CGRectYH(self.nameLabel)/AdaptationWidth(), 165, 45)];
        _eduLabel.font = WFont(30);
        _eduLabel.textAlignment = 0;
        _eduLabel.text = @"学历：无";
    }
    return _eduLabel;
}
-(UILabel *)jobLabel{
    if (!_jobLabel) {
        _jobLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.eduLabel)/AdaptationWidth(), CGRectYH(self.nameLabel)/AdaptationWidth(), 165, 45)];
        _jobLabel.font = self.eduLabel.font;
        _jobLabel.textAlignment = 0;
        _jobLabel.text = @"职业：无";
    }
    return _jobLabel;
}
-(UILabel *)intertsLabel{
    if (!_intertsLabel) {
        _intertsLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.headImage)/AdaptationWidth()+30, CGRectYH(self.jobLabel)/AdaptationWidth(), 300, 45)];
        _intertsLabel.font = self.jobLabel.font;
        _intertsLabel.text = @"爱好：无";
        _intertsLabel.textAlignment = 0;
    }
    return _intertsLabel;
}
-(UILabel *)signatureLabel{
    if (!_signatureLabel) {
        UILabel *theLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectX(self.headImage)/AdaptationWidth(), CGRectYH(self.headImage)/AdaptationWidth()+25, 110, 45)];
        theLabel.textAlignment = 0;
        theLabel.font = WFont(25);
        theLabel.text = @"个性签名";
        theLabel.textColor = LH_RGBCOLOR(148, 148, 148);
        [self addSubview:theLabel];
        
        _signatureLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(theLabel)/AdaptationWidth(), CGRectYH(self.headImage)/AdaptationWidth()+25, 464, 45)];
        
        _signatureLabel.text = @"无";
        _signatureLabel.font = WFont(30);
        _signatureLabel.textAlignment = 0;
    }
    return _signatureLabel;
}
-(UIButton *)focusBtn{
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(610, 125, 64, 40)];
        [_focusBtn setImage:MImage(@"gr_gz") forState:0];
        
    }
    return _focusBtn;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(610, CGRectYH(self.headImage)/AdaptationWidth()+25, 80, 50)];
        _timeLabel.text = @"11:15";
        _timeLabel.font = WFont(30);
        _timeLabel.textAlignment = 0;
    }
    return _timeLabel;
}
@end
