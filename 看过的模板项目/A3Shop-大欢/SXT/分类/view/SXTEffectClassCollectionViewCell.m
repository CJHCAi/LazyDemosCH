//
//  SXTEffectClassCollectionViewCell.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTEffectClassCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface SXTEffectClassCollectionViewCell()

@property (strong, nonatomic)   UILabel *iconTitle;              /** 标题 */
@property (strong, nonatomic)   UIImageView *iconImage;              /** 图标 */
@end

@implementation SXTEffectClassCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImage];
        [self addSubview:self.iconTitle];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(10, 20, 30, 20));
    }];
    [_iconTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom);
        make.bottom.and.left.and.right.equalTo(weakSelf);
    }];
    
}

- (void)setEffectModel:(SXTEffectClassModel *)effectModel{
    _iconTitle.text = effectModel.GoodsTypeName;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:effectModel.ImgView]];
}

- (UILabel *)iconTitle{
    if (!_iconTitle) {
        _iconTitle = [[UILabel alloc]init];
        _iconTitle.textAlignment = NSTextAlignmentCenter;
        _iconTitle.font = [UIFont systemFontOfSize:12.0];
        _iconTitle.textColor = [UIColor blackColor];
    }
    return _iconTitle;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}@end
