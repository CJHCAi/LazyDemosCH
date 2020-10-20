//
//  ZHBStandardViewCollectionReusableHeaderView.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/29.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBStandardViewCollectionReusableHeaderView.h"

@implementation ZHBStandardViewCollectionReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupContentView];
        [self setupContentConstraints];
    }
    return self;
}

- (void)setupContentView
{
    [self addSubview:self.headerTitleLabel];
    [self addSubview:self.noChooseLabel];
    [self addSubview:self.lineView];
}

- (void)setupContentConstraints
{
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.mas_trailing).offset(15.f);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    [self.noChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.headerTitleLabel.mas_trailing).offset(10);
        make.height.equalTo(self.headerTitleLabel.mas_height);
        make.centerY.equalTo(self.headerTitleLabel.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.mas_trailing).offset(15.f);
        make.height.equalTo(@1);
        make.trailing.equalTo(self.mas_trailing);
        make.centerY.equalTo(self.mas_top);
    }];
}

#pragma mark - lazy
- (UILabel *)headerTitleLabel
{
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.textColor = ColorWithHex(0x555555);
        _headerTitleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _headerTitleLabel;
}
- (UILabel *)noChooseLabel
{
    if (!_noChooseLabel) {
        _noChooseLabel = [[UILabel alloc] init];
//        _noChooseLabel.textColor = redSwitchColor;
        _noChooseLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _noChooseLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ColorWithHex(0XF1F2F6);
    }
    return _lineView;
}
@end
