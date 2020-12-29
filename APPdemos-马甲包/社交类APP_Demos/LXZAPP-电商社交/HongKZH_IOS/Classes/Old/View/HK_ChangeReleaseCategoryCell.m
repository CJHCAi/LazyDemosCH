//
//  HK_ChangeReleaseCategoryCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_ChangeReleaseCategoryCell.h"

@interface HK_ChangeReleaseCategoryCell ()

@property (nonatomic, strong) UIControl *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HK_ChangeReleaseCategoryCell

- (UIControl *)bgView {
    if (!_bgView) {
        _bgView = [[UIControl alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = UICOLOR_HEX(0xf1f1f1).CGColor;
        [_bgView addTarget:self action:@selector(bgViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (void)bgViewClick {
    if (self.iconClickBlock) {
        self.iconClickBlock(self.category);
    }
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                               textColor:UICOLOR_HEX(0x666666) textAlignment:NSTextAlignmentCenter
                                                    font:PingFangSCRegular14
                                                    text:@""
                                              supperView:nil];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
    }];
}

- (void)setCategory:(AllcategorysModel *)category {
    if (!category) {
        return;
    }
    _category = category;
    self.titleLabel.text = category.name;
}

@end
