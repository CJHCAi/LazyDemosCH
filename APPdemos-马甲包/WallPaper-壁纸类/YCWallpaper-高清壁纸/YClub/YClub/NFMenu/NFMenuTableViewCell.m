//
//  NFMenuTableViewCell.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFMenuTableViewCell.h"

@implementation NFMenuTableViewCell

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = YC_Base_TitleFont;
        _titleLabel.textColor = YC_Base_TitleColor;
    }
    return _titleLabel;
}
- (UILabel *)cacheLabel
{
    if (!_cacheLabel) {
        _cacheLabel = [[UILabel alloc] init];
        _cacheLabel.text = @"0.00M";
        _cacheLabel.font = YC_Base_ContentFont;
        _cacheLabel.textColor = YC_Base_ContentColor;
        _cacheLabel.textAlignment = NSTextAlignmentRight;
    }
    return _cacheLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.cacheLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_iconView.mas_right).with.offset(8);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-32);
    }];
    
    [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(@100);
    }];
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    _iconView.image   = nil;
    _titleLabel.text  = nil;
    _cacheLabel.text  = nil;
}
@end
