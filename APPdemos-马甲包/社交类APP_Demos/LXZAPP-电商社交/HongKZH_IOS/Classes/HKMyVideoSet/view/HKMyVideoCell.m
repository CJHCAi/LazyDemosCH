//
//  HKMyVideoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyVideoCell.h"

@interface HKMyVideoCell()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UILabel *rewardCountLabel;

@property (nonatomic, strong) UILabel *praiseCountLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong)UIImageView *prideIcon;

@property (nonatomic, strong)UIImageView *rewardIcon;

@property (nonatomic, strong)UILabel  *tipLabel;

@end

@implementation HKMyVideoCell

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.layer.masksToBounds = YES;
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    }
    return _coverImgView;
}

//奖励
- (UILabel *)rewardCountLabel {
    if (!_rewardCountLabel) {
        _rewardCountLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0xff3c00)
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:PingFangSCMedium12
                                                          text:@"7260"
                                                    supperView:nil];
    }
    return _rewardCountLabel;
}

//点赞
- (UILabel *)praiseCountLabel {
    if (!_praiseCountLabel) {
        _praiseCountLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0xffffff)
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:PingFangSCRegular12
                                                          text:@"9714"
                                                    supperView:nil];
    }
    return _praiseCountLabel;
}

//标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0x333333)
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:PingFangSCMedium13
                                                          text:@"自媒体视频标题"
                                                    supperView:nil];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

//头像
- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.layer.cornerRadius = 9;
        _headImgView.layer.masksToBounds = YES;
    }
    return _headImgView;
}

//用户名
- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                               textColor:UICOLOR_HEX(0x666666)
                                           textAlignment:NSTextAlignmentLeft
                                                    font:PingFangSCRegular12
                                                    text:@"Free will"
                                              supperView:nil];
    }
    return _usernameLabel;
}

//定位
- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x666666)
                                              textAlignment:NSTextAlignmentRight
                                                       font:PingFangSCRegular12
                                                       text:@"上海"
                                                 supperView:nil];
    }
    return _locationLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

//添加布局子控件
- (void)setUpUI {
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    //添加封面
    [self.contentView addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.contentView);
        make.height.mas_equalTo(150);
    }];
    
    //点赞icon
    UIImageView *prideIcon = [[UIImageView alloc] init];
    self.prideIcon = prideIcon;
    prideIcon.image = [UIImage imageNamed:@"dz"];
    [self.contentView addSubview:prideIcon];
    [prideIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImgView).offset(10);
        make.bottom.equalTo(self.coverImgView).offset(-10);
    }];
    //点赞label
    [self.contentView addSubview:self.praiseCountLabel];
    [self.praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prideIcon.mas_right).offset(6);
        make.centerY.equalTo(prideIcon);
    }];

        //奖励label
        [self.contentView addSubview:self.rewardCountLabel];
        [self.rewardCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(prideIcon);
        }];
        //奖励icon
        UIImageView *rewardIcon = [[UIImageView alloc] init];
        self.rewardIcon  =rewardIcon;
        rewardIcon.image = [UIImage imageNamed:@"coin5"];
        [self.contentView addSubview:rewardIcon];
        [rewardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rewardCountLabel.mas_left).offset(-2);
            make.centerY.equalTo(prideIcon);
        }];
        //赚
        UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0xffffff)
                                                 textAlignment:NSTextAlignmentRight
                                                          font:PingFangSCRegular11
                                                          text:@"赚"
                                                    supperView:nil];
        self.tipLabel  =tipLabel;
        [self.contentView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rewardIcon.mas_left).offset(-2);
            make.centerY.equalTo(prideIcon);
        }];
    //标题
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.right.equalTo(self.contentView).offset(-13);
        make.top.equalTo(self.coverImgView.mas_bottom).offset(13);
    }];

    //头像
    [self.contentView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    self.bottomV = self.headImgView;
    
    //username
    [self.contentView addSubview:self.usernameLabel];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(5);
        make.centerY.equalTo(self.headImgView);
    }];
    
    //locationLabel
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.headImgView);
    }];
    //locationIcon
    UIImageView *locationIcon = [[UIImageView alloc] init];
    locationIcon.image = [UIImage imageNamed:@"filter_map"];
    [self.contentView addSubview:locationIcon];
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locationLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.headImgView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo((kScreenWidth-30)/2);
        make.bottom.equalTo(self.headImgView.mas_bottom).offset(12);
    }];
}

- (void)setMyList:(HKMyVideoList *)myList {
    if (myList) {
        _myList = myList;
        HKMyVideoList *myVideoList = (HKMyVideoList *)myList;
        //设置封面
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:myVideoList.coverImgSrc] placeholderImage:[UIImage imageNamed:@"smrz_bg"]];
        CGFloat itemWidth = (kScreenWidth-30)/2;
        CGSize coverImgSize;
        if (myVideoList.coverImgWidth && myVideoList.coverImgHeight) {
             coverImgSize = CGSizeMake(itemWidth, itemWidth*[myVideoList.coverImgHeight floatValue]/[myVideoList.coverImgWidth floatValue]);
        }else {
              coverImgSize = CGSizeMake(itemWidth, itemWidth*kScreenHeight/kScreenWidth);
        }
        [self.coverImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(coverImgSize);
        }];
        //设置点赞
        self.praiseCountLabel.text = myVideoList.praiseCount;
        //设置奖励
        self.rewardCountLabel.text = myVideoList.rewardCount;
        //设置标题
        self.titleLabel.text = myVideoList.title;
        //设置头像
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:myVideoList.headImg] placeholderImage:[UIImage imageNamed:@"Man"]];
        //设置username
        self.usernameLabel.text = myVideoList.uName;
        //设置location
        self.locationLabel.text = myVideoList.provinceName;
    }
}

-(void)setData:(HKRecommendListData *)data {
    _data = data;

        self.tipLabel.hidden = YES;
        self.rewardCountLabel.hidden = YES;
        self.rewardIcon.image = [UIImage imageNamed:@"red_img"];
    
       [self.rewardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.prideIcon);
    }];
    
    //设置封面
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:data.coverImgSrc] placeholderImage:[UIImage imageNamed:@"smrz_bg"]];
    CGFloat itemWidth = (kScreenWidth-30)/2;
    CGSize coverImgSize ;
    if (data.coverImgWidth && data.coverImgHeight) {
        coverImgSize = CGSizeMake(itemWidth, itemWidth*[data
                                  .coverImgHeight floatValue]/[data.coverImgWidth floatValue]);
    }else {
        coverImgSize = CGSizeMake(itemWidth, itemWidth*kScreenHeight/kScreenWidth);
    }
    [self.coverImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(coverImgSize);
    }];
    //设置点赞
    self.praiseCountLabel.text = data.praiseCount;
    //设置标题
    self.titleLabel.text = data.title;
    //设置头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:data.headImg] placeholderImage:[UIImage imageNamed:@"smrz_bg"]];
    //设置username
    self.usernameLabel.text =data.uName;
}
-(void)setUserList:(HKUserVideoList *)userList {
    _userList = userList;
    self.tipLabel.hidden = YES;
    self.rewardCountLabel.hidden = YES;
    self.rewardIcon.image = [UIImage imageNamed:@"lk_hb_01"];
    [self.rewardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.prideIcon);
    }];
    //设置封面
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:userList.coverImgSrc] placeholderImage:[UIImage imageNamed:@"smrz_bg"]];
    CGFloat itemWidth = (kScreenWidth-30)/2;
    CGSize coverImgSize ;
    if (userList.coverImgWidth && userList.coverImgHeight) {
        coverImgSize = CGSizeMake(itemWidth, itemWidth*[userList
                                                        .coverImgHeight floatValue]/[userList.coverImgWidth floatValue]);
    }else {
        coverImgSize = CGSizeMake(itemWidth, itemWidth*kScreenHeight/kScreenWidth);
    }
    [self.coverImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(coverImgSize);
    }];
    //设置点赞
    self.praiseCountLabel.text = userList.playCount;
    //设置标题
    self.titleLabel.text = userList.title;
}

-(void)setUserVideoInfo:(NSString *)name andHeadImg:(NSString *)headImg {
    //设置头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"Man"]];
    //设置username
    self.usernameLabel.text =name;
}

-(CGSize)calcSelfSize
{
    return CGSizeMake((kScreenWidth-30)/2, [HK_Tool HeightForView:self bottom:self.bottomV offset:14]);
    
}

@end
