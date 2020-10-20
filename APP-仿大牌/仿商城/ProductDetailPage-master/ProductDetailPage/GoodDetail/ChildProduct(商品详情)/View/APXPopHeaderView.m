//
//  APXPopHeaderView.m
//  ZhongHeBao
//
//  Created by 云无心 on 2017/2/20.
//  Copyright © 2017年 zhbservice. All rights reserved.
//

#import "APXPopHeaderView.h"

@interface APXPopHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation APXPopHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView
{

    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    // 删除按钮shut_down01
    UIButton *dismissBtn = [[UIButton alloc] init];
    [dismissBtn setImage:[UIImage imageNamed:@"goodDetail_standard_cancelBtn"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(self.mas_trailing);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorWithHex(0xe2e2e4);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
}

- (void)dismissButtonClick
{
    if ([self.delegate respondsToSelector:@selector(popHeaderViewDidClickDissMissButtton:)]) {
        [self.delegate popHeaderViewDidClickDissMissButtton:self];
    }
}

- (void)setTitleString:(NSString *)titleString
{
    self.titleLabel.text = titleString;
}

#pragma mark - lazy
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = ColorWithHex(0x353535);
    }
    return _titleLabel;
}
@end
