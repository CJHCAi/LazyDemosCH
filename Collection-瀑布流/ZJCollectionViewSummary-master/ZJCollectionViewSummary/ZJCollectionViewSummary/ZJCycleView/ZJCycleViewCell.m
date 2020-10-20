//
//  ZJCycleViewCell.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/9.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJCycleViewCell.h"
#import "UIView+ZJExtension.h"

@interface ZJCycleViewCell ()


@end

@implementation ZJCycleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleBackgroundView];
        [self.titleBackgroundView addSubview:self.titleL];
        [self.titleBackgroundView addSubview:self.currentPageL];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.titleBackgroundView.frame = CGRectMake(0, self.zj_height - 30, self.zj_width, 30);
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleL
{
    if (_titleL == nil) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.zj_width - 80, 30)];
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}

- (UILabel *)currentPageL
{
    if (_currentPageL == nil) {
        _currentPageL = [[UILabel alloc] initWithFrame:CGRectMake(self.zj_width - 80, 0, 70, 30)];
        _currentPageL.textAlignment = NSTextAlignmentRight;
        _currentPageL.textColor = [UIColor whiteColor];
    }
    return _currentPageL;
}

- (UIView *)titleBackgroundView
{
    if (_titleBackgroundView == nil) {
        _titleBackgroundView = [[UIView alloc] init];
        _titleBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    return _titleBackgroundView;
}

@end
