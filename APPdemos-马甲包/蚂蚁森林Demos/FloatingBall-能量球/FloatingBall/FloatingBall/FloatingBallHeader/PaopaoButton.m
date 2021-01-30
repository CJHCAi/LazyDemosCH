//
//  PaopaoButton.m
//  YiLink
//
//  Created by CygMac on 2018/6/2.
//  Copyright © 2018年 xunku_mac. All rights reserved.
//

#import "PaopaoButton.h"
#import <Masonry/Masonry.h>

@interface PaopaoButton ()

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation PaopaoButton

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomLabel];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topImageView.mas_bottom).offset(4);
            make.centerX.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setPaopaoImage:(UIImage *)image {
    self.topImageView.image = image;
}

- (void)setTitle:(NSString *)title {
    self.bottomLabel.text = title;
}

#pragma mark - Get

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
    }
    return _topImageView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:10];
        _bottomLabel.textColor = [UIColor whiteColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

@end
