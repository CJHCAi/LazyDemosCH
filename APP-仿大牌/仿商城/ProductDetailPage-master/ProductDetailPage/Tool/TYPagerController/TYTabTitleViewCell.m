//
//  TYTabTitleViewCell.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/4.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "TYTabTitleViewCell.h"


@implementation TYTabTitleViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel {
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
