//
//  YCEditCollectionViewCell.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditCollectionViewCell.h"

@interface YCEditCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YCBaseModel *model;
@property (nonatomic, strong) MMMaterialDesignSpinner *spiner;
@end

@implementation YCEditCollectionViewCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (MMMaterialDesignSpinner *)spiner
{
    if (!_spiner) {
        _spiner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _spiner.lineWidth = 4;
        _spiner.hidesWhenStopped = YES;
        _spiner.tintColor = YC_TabBar_SeleteColor;
    }
    return _spiner;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.spiner];
        _imageView.frame = self.bounds;
        _spiner.center   = CGPointMake(self.contentView.centerX, self.contentView.centerY);
    }
    return self;
}
- (void)setModel:(YCBaseModel *)model
{
    if (!model || kStringIsEmpty(model.img)) {
        return;
    }
    _model = model;
    [_spiner startAnimating];
    [_imageView sd_setImageWithURL:[NSURL safeURLWithString:model.img] placeholderImage:[UIImage imageNamed:@"yc_default_place"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_spiner stopAnimating];
    }];
}
- (UIImage *)getShowImg
{
    return _imageView.image;
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
    _model = nil;
    [_spiner stopAnimating];
}
@end
