//
//  HKPrivacySettingCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPrivacySettingCell.h"

@interface HKPrivacySettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UISwitch *switchButton;

@end


@implementation HKPrivacySettingCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                               textColor:UICOLOR_HEX(0x666666)
                                           textAlignment:NSTextAlignmentLeft
                                                    font:PingFangSCRegular14
                                                    text:@"隐私设置"
                                              supperView:nil];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                             textColor:UICOLOR_HEX(0x666666)
                                         textAlignment:NSTextAlignmentLeft
                                                  font:PingFangSCRegular14
                                                  text:@"不在我的动态展示"
                                            supperView:nil];
    }
    return _tipLabel;
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        _switchButton.on = NO;
    }
    return _switchButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.switchButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchButton.mas_left).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
}


@end
