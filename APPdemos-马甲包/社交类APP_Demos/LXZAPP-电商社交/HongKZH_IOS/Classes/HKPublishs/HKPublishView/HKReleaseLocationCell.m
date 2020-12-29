//
//  HKReleaseLocationCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseLocationCell.h"

@interface HKReleaseLocationCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation HKReleaseLocationCell

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"filter_map"];
        _iconView.hidden = YES;
    }
    return _iconView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x666666)
                                              textAlignment:NSTextAlignmentLeft
                                                       font:PingFangSCRegular14
                                                       text:@"定位中.."
                                                 supperView:nil];
        _locationLabel.hidden = YES;
    }
    return _locationLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                             textColor:UICOLOR_HEX(0x666666)
                                         textAlignment:NSTextAlignmentLeft
                                                  font:PingFangSCRegular14
                                                  text:@"显示地区"
                                            supperView:nil];
    }
    return _tipLabel;
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        _switchButton.on =YES;
        [_switchButton addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.switchButton];
}


-(void)changeLocation:(UISwitch *)sw {
    if (sw.on) {
        self.iconView.hidden = NO;
        self.locationLabel.hidden =NO;
    }else {
        self.iconView.hidden =YES;
        self.locationLabel.hidden = YES;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(7);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchButton.mas_left).offset(-13);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setLocationData:(HKReleaseLocationData *)locationData {
    if (locationData) {
        _locationData = locationData;
        self.locationLabel.text = locationData.location;
        self.switchButton.on = locationData.isShow;
    }
}

@end

@implementation HKReleaseLocationData

@end

