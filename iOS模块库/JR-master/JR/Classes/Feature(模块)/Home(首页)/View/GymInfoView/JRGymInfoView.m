
//
//  JRGymInfoView.m
//  JR
//
//  Created by Zj on 17/8/19.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRGymInfoView.h"
#import "JRInfoView.h"

@interface JRGymInfoView()
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *accessaryImgView;
@property (nonatomic, strong) JRInfoView *tempInfoView;
@property (nonatomic, strong) JRInfoView *airInfoView;
@property (nonatomic, strong) JRInfoView *manInfoView;
@property (nonatomic, strong) JRInfoView *womanInfoView;

@end

@implementation JRGymInfoView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self setupSubViews];
    }
    return self;
}


#pragma mark - private
- (void)setupSubViews{

    _headerImgView = [UIImageView imageViewWithFrame:CGRectMake(0, 0, JRScreenWidth, JRHeight(175)) image:[UIImage imageNamed:@"headerImg"]];
    
    [self addSubview:_headerImgView];
    
    CGFloat blockViewHeight = JRHeight(167.5);
    _blockView = [[UIView alloc] initWithFrame:CGRectMake(JRPadding, JRGymInfoViewHeight - blockViewHeight, JRScreenWidth - 2 * JRPadding, blockViewHeight)];
    _blockView.backgroundColor = JRWhiteColor;
    [JRTool shadow:_blockView.layer];
    
    [self addSubview:_blockView];
    
    CGFloat avatarWidth = JRWidth(75);
    _avatar = [UIImageView imageViewWithFrame:CGRectMake(2.5 * JRPadding, _blockView.y - 1.5 * JRPadding, avatarWidth, avatarWidth) image:[UIImage imageNamed:@"headerIcon"]];

    [self addSubview:_avatar];
    
    CGFloat accessaryImgViewY = (avatarWidth - 1.5 * JRPadding) / 2 - 8.5 + _blockView.y;
    _accessaryImgView = [UIImageView imageViewWithFrame:CGRectMake(_blockView.right - 17 - 2 * JRPadding, accessaryImgViewY, 17, 17) image:[UIImage imageNamed:@"accessaryImg"]];
    
    [self addSubview:_accessaryImgView];
    
    CGFloat addressLabelHeight = avatarWidth - 1.5 * JRPadding;
    _addressLabel = [UILabel labelWithFrame:CGRectMake(_avatar.right + 2 * JRPadding, _blockView.y, _accessaryImgView.x - 3 * JRPadding, addressLabelHeight) text:@"地址: 光谷新世界店" color:JRCommonTextColor font:JRCommonFont(13) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_addressLabel];
    
    CGFloat infoViewWidth = _blockView.width / 4;
    CGFloat infoViewHeight = JRHeight(85);
    CGFloat infoViewY = _avatar.bottom + 1.5 * JRPadding;
    _tempInfoView = [[JRInfoView alloc] initWithFrame:CGRectMake(JRPadding, infoViewY, infoViewWidth, infoViewHeight)];
    _tempInfoView.imageView.image = [UIImage imageNamed:@"temp"];
    _tempInfoView.label.text = @"室内温度";
    _tempInfoView.detailLabel.text = @"23℃";
    
    [self addSubview:_tempInfoView];
    
    _airInfoView = [[JRInfoView alloc] initWithFrame:CGRectMake(_tempInfoView.right, infoViewY, infoViewWidth, infoViewHeight)];
    _airInfoView.imageView.image = [UIImage imageNamed:@"air"];
    _airInfoView.label.text = @"PM2.5";
    _airInfoView.detailLabel.text = @"30";
    
    [self addSubview:_airInfoView];
    
    _manInfoView = [[JRInfoView alloc] initWithFrame:CGRectMake(_airInfoView.right, infoViewY, infoViewWidth, infoViewHeight)];
    _manInfoView.imageView.image = [UIImage imageNamed:@"man"];
    _manInfoView.label.text = @"男";
    _manInfoView.detailLabel.text = @"7";
    
    [self addSubview:_manInfoView];
    
    _womanInfoView = [[JRInfoView alloc] initWithFrame:CGRectMake(_manInfoView.right, infoViewY, infoViewWidth, infoViewHeight)];
    _womanInfoView.imageView.image = [UIImage imageNamed:@"woman"];
    _womanInfoView.label.text = @"女";
    _womanInfoView.detailLabel.text = @"15";
    
    [self addSubview:_womanInfoView];
}

@end
