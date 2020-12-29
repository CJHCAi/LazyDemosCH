//
//  HKFrindInfoHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindInfoHeaderView.h"

@interface HKFrindInfoHeaderView ()
@property (nonatomic, strong)UIImageView *backGroudImageView;
@property (nonatomic, strong)UIImageView *headerView;
@property (nonatomic, strong)UILabel *levelLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *sexView;
@property (nonatomic, strong)UILabel *mottoLabel;
@property (nonatomic, strong)UILabel *tipsLabel;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIButton *morenBtn;

@end

@implementation HKFrindInfoHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        
        [self addSubview:self.backGroudImageView];
        [self addSubview:self.headerView];
        [self addSubview:self.levelLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.sexView];
        [self addSubview:self.mottoLabel];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.backBtn];
        [self addSubview:self.morenBtn];
    }
    return self;
}
-(UIImageView *)backGroudImageView {
    if (!_backGroudImageView) {
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        bgImgView.layer.masksToBounds =YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
        [bgImgView addSubview:effectView];
        _backGroudImageView = bgImgView;
    }
    return _backGroudImageView;
}
-(UIImageView *)headerView {
    if (!_headerView) {
        _headerView =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-37,37,74,74)];
        _headerView.image =[UIImage imageNamed:@"Man"];
        _headerView.layer.cornerRadius =37;
        _headerView.layer.masksToBounds =YES;
        _headerView.borderColor =[UIColor whiteColor];
        _headerView.borderWidth =2;
    }
    return _headerView;
}
-(UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerView.frame)+3,CGRectGetMinY(self.headerView.frame),100,8)];
        [AppUtils getConfigueLabel:_levelLabel font:PingFangSCRegular10 aliment:NSTextAlignmentLeft textcolor:[UIColor whiteColor] text:@""];
    }
    return _levelLabel;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.headerView.frame),CGRectGetMaxY(self.headerView.frame)+8,CGRectGetWidth(self.headerView.frame),20)];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular20 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@"夏莹莹"];
    }
    return _nameLabel;
}
-(UILabel *)mottoLabel {
    if (!_mottoLabel) {
        _mottoLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.nameLabel.frame)+8,kScreenWidth,13)];
        [AppUtils getConfigueLabel:_mottoLabel font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@"吃水不忘挖井人"];
    }
    return _mottoLabel;
}
-(UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.mottoLabel.frame)+11,kScreenWidth,12)];
        [AppUtils getConfigueLabel:_tipsLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@"北京朝阳 4分钟前 1152个粉丝"];
    }
    return _tipsLabel;
}

-(void)setResponse:(HKMediaInfoResponse *)response {
    _response =response;
    if (response.data.introduction.length) {
        self.mottoLabel.text =response.data.introduction;
    }else {
        self.mottoLabel.text =@"该用户还未设置介绍哦";
    }
    self.tipsLabel.text =[NSString stringWithFormat:@"%@ %@ %zd个粉丝",response.data.located,response.data.loginTime,response.data.fans];
    //属性字符串.
    NSString *le =[NSString stringWithFormat:@"%zd",response.data.level];
    NSString * levelStr =[NSString stringWithFormat:@"LV.%@",le];
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:levelStr
                                     ];
    [att addAttribute:NSForegroundColorAttributeName value:RGB(73,239,249) range:NSMakeRange(0,3)];
    self.levelLabel.attributedText = att;
        [self.backGroudImageView sd_setImageWithURL:[NSURL URLWithString:response.data.headImg]];
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:response.data.headImg]];
}
-(void)setModel:(HKMyFollowAndFansList *)model {
    _model = model;
    [self.backGroudImageView sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
    
    self.nameLabel.text =model.name;
}

-(void)setIsCompany:(BOOL)isCompany {
    self.mottoLabel.hidden = YES;
    self.levelLabel.hidden =YES;
    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x,CGRectGetMaxY(self.headerView.frame)+20,self.nameLabel.frame.size.width,self.nameLabel.frame.size.height);
    self.tipsLabel.frame = CGRectMake(self.tipsLabel.frame.origin.x,CGRectGetMaxY(self.nameLabel.frame)+20,self.tipsLabel.frame.size.width,self.tipsLabel.frame.size.height);
    self.backBtn.hidden = NO;
    self.morenBtn.hidden = NO;
}

-(void)setComRes:(HKCompanyResPonse *)comRes {
    _comRes  =comRes;
    [AppUtils seImageView:self.backGroudImageView withUrlSting:comRes.data.headImg placeholderImage:kPlaceholderImage];
    [AppUtils seImageView:self.headerView withUrlSting:comRes.data.headImg placeholderImage:kPlaceholderImage];
    self.nameLabel.text = comRes.data.eName;
    self.tipsLabel.text  =[NSString stringWithFormat:@"%zd人关注",comRes.data.follows];

}
-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(14,CGRectGetMinY(self.headerView.frame),40,40);
        [_backBtn setImage:[UIImage imageNamed:@"enterprise_goback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = 10;
        _backBtn.hidden =YES;
    }
    return _backBtn;
}
-(void)goBack:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(TopInfoClickWithSender:)]) {
        [self.delegete TopInfoClickWithSender:sender.tag];
    }
}
-(UIButton *)morenBtn {
    if (!_morenBtn) {
        _morenBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _morenBtn.frame = CGRectMake(kScreenWidth-14-40,CGRectGetMinY(self.headerView.frame),40,40);
        [_morenBtn setImage:[UIImage imageNamed:@"enterprise_more"] forState:UIControlStateNormal];
        [_morenBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        _morenBtn.tag = 20;
        _morenBtn.hidden =YES;
    }
    return _morenBtn;
}
@end
