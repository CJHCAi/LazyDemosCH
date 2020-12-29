//
//  HKTagRightView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTagRightView.h"
#import "HK_AllTags.h"
@interface HKTagRightView ()

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation HKTagRightView

#pragma mark 懒加载
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                     frame:CGRectZero
                                                     taget:self
                                                    action:@selector(cancelButtonClick:) supperView:nil];
        [_cancelButton setImage:[UIImage imageNamed:@"Left3we"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (void)cancelButtonClick:(UIButton *)sender {
    
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"lrghtbj"];
        UIImage *strImage = [image stretchableImageWithLeftCapWidth:image.size.width/2-1 topCapHeight:image.size.height/2-1];
        _bgView.image = strImage;
    }
    return _bgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.userInteractionEnabled = YES;
    }
    return _iconView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                             textColor:[UIColor whiteColor]
                                         textAlignment:NSTextAlignmentLeft
                                                  font:PingFangSCRegular13
                                                  text:@""
                                            supperView:nil];
    }
    return _tagLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"Left1q"];
        _arrowView.userInteractionEnabled = YES;
    }
    return _arrowView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self addSubview:self.cancelButton];
        [self addSubview:self.iconView];
        [self addSubview:self.arrowView];
        [self addSubview:self.tagLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowView.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(13);
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowView.mas_right);
        make.top.height.equalTo(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.tagLabel.mas_right);
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cancelButton);
    }];
}

- (void)setTagValue:(id)tagValue {
    if (tagValue) {
        _tagValue = tagValue;
        UIImage *image;
        if ([tagValue isKindOfClass:[HK_AllTagsHis class]]) {
            HK_AllTagsHis *value = (HK_AllTagsHis *)tagValue;
            self.tagLabel.text = value.tag;
            if ([value.type integerValue] == 1) { //圈子
                image = [UIImage imageNamed:@"qzsq1f"];
            } else if ([value.type integerValue] == 2) { //用户
                
            } else if ([value.type integerValue] == 3) { //自定义
                image = [UIImage imageNamed:@"bqqjj1s"];
            }
        } else if ([tagValue isKindOfClass:[HK_AllTagsCircles class]]) {
            HK_AllTagsCircles *value = (HK_AllTagsCircles *)tagValue;
            self.tagLabel.text = value.tag;
            if ([value.type integerValue] == 1) { //圈子
                image = [UIImage imageNamed:@"qzsq1f"];
            } else if ([value.type integerValue] == 2) { //用户
                
            } else if ([value.type integerValue] == 3) { //自定义
                image = [UIImage imageNamed:@"bqqjj1s"];
            }
        } else if ([tagValue isKindOfClass:[HK_AllTagsRecommends class]]) {
            HK_AllTagsRecommends *value = (HK_AllTagsRecommends *)tagValue;
            self.tagLabel.text = value.tag;
            if ([value.type integerValue] == 1) { //圈子
                image = [UIImage imageNamed:@"qzsq1f"];
            } else if ([value.type integerValue] == 2) { //用户
                
            } else if ([value.type integerValue] == 3) { //自定义
                image = [UIImage imageNamed:@"bqqjj1s"];
            }
        }
        self.iconView.image = image;
    }
}

@end
