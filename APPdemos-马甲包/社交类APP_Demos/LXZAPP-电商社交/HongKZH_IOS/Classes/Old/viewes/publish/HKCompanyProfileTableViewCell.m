//
//  HKCompanyProfileTableViewCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCompanyProfileTableViewCell.h"

@interface HKCompanyProfileTableViewCell ()

@property (nonatomic, weak) UIImageView *iconView;  //logo

@property (nonatomic, weak) UILabel *companyNameLabel;  //公司名

@property (nonatomic, weak) UILabel *authenFlagLabel;   //认证标识

@property (nonatomic, weak) UILabel *detailLabel;     //行业-规模-发展阶段

@property (nonatomic, weak) UILabel *profileLabel;  //企业介绍

@property (nonatomic, weak) UIView *flagBgView;

@property (nonatomic, weak) UIView *line;

@property (nonatomic, weak) UIImageView *arrowView;  //箭头

@end

@implementation HKCompanyProfileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
    }
    return self;
}

#define lineColor RGB(226, 226, 226)

- (void)setUpUI {
    //Icon
    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.backgroundColor = [UIColor orangeColor];
    iconView.layer.cornerRadius =  20;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    //公司名
    UILabel *companyNameLabel = [[UILabel alloc] init];
    companyNameLabel.font = [UIFont fontWithName:PingFangSCMedium size:15.f];
    companyNameLabel.textColor = RGB(51, 51, 51);
    companyNameLabel.text = @"";
//    companyNameLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:companyNameLabel];
    self.companyNameLabel = companyNameLabel;

    UIView *flagBgView = [UIView new];
    flagBgView.backgroundColor = RGB(143, 198, 230);
    flagBgView.layer.cornerRadius = 3.f;
    flagBgView.layer.masksToBounds = YES;
    [self.contentView addSubview:flagBgView];
    self.flagBgView = flagBgView;
    
    //认证标识
    UILabel *authenFlagLabel = [[UILabel alloc] init];
    authenFlagLabel.font = [UIFont fontWithName:PingFangSCRegular size:10.f];
    //authenFlagLabel.backgroundColor = RGB(143, 198, 230);
    authenFlagLabel.textColor = [UIColor whiteColor];
    authenFlagLabel.text = @"";
    [authenFlagLabel sizeToFit];
    [self.contentView addSubview:authenFlagLabel];
    self.authenFlagLabel = authenFlagLabel;
    
    //行业-规模-发展阶段
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    detailLabel.textColor = RGB(102, 102, 102);
    detailLabel.text = @"";
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    UIImageView *arrowView = [HKComponentFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"nestchose"] supperView:self.contentView];
    self.arrowView = arrowView;
    
    UIView *line = [UIView new];
    line.backgroundColor = lineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    //企业介绍
    UILabel *profileLabel = [[UILabel alloc] init];
    profileLabel.font = [UIFont fontWithName:PingFangSCRegular size:12];
    profileLabel.textColor = RGB(153, 153, 153);
    profileLabel.lineBreakMode = NSLineBreakByCharWrapping;
    profileLabel.text = @"您还未填写企业描述";
    profileLabel.numberOfLines = 0;
    [self.contentView addSubview:profileLabel];
    self.profileLabel = profileLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //logo
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    //公司名
    [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(15);
        make.top.equalTo(self.contentView).offset(17);
        make.height.mas_equalTo(15);
    }];
    
    //认证标识
    [self.authenFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.companyNameLabel);
    }];
    
    [self.flagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyNameLabel.mas_right).offset(6);
        make.centerY.equalTo(self.companyNameLabel);
        make.width.equalTo(self.authenFlagLabel).offset(10);
        make.height.equalTo(self.authenFlagLabel);
    }];
    
    //detailLabel     行业-规模-发展阶段
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyNameLabel);
        make.top.equalTo(self.companyNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(11);
    }];
    
    //arrowView
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(self.iconView);
    }];
    
    //line
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(18);
        make.height.mas_equalTo(1);
    }];
    
    //企业介绍
    [self.profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(16);
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-23);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

- (void)setData:(HK_RecruitEnterpriseInfoData *)data {
    if (data == nil) {
        return;
    }
    _data = data;
    //设置数据
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:data.headImg] placeholderImage:[UIImage imageNamed:@""]];
    self.companyNameLabel.text = data.name;
    if (data.isAuth && [data.isAuth integerValue] == 1) {
        self.authenFlagLabel.text = @"已认证";
    } else if(data.isAuth && [data.isAuth integerValue] == 0) {
        self.authenFlagLabel.text = @"未认证";
    } else {
        self.authenFlagLabel.text = @"";
    }
    self.detailLabel.text = [NSString stringWithFormat:@"%@ 丨 %@ 丨 %@",data.industryName,data.scaleName,data.stageName];
    if (data.introduce && data.introduce.length > 0) {
        self.profileLabel.text = data.introduce;
    }
}


@end
