//
//  YCTypeCollectionViewCell.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCTypeCollectionViewCell.h"

@interface YCTypeCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel     *nameLabel;

@end

@implementation YCTypeCollectionViewCell

- (UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.layer.masksToBounds = YES;
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageview;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = YC_Base_TitleFont;
        _nameLabel.textColor = YC_Base_TitleColor;
    }
    return _nameLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubview];
    }
    return self;
}
- (void)setUpSubview
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.imageview];
    [self.contentView addSubview:self.nameLabel];
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(self.contentView.height-30));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(@30);
    }];
}
- (void)setModel:(YCBaseModel *)model
{
    if (!model) {
        return;
    }
    [_imageview sd_setImageWithURL:[NSURL safeURLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"yc_default_place"]] ;
    _nameLabel.text = model.name;
}

@end
