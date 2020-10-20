//
//  SXTGoodsListTopButtonView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTGoodsListTopButtonView.h"

@interface SXTGoodsListTopButtonView()

@property (strong, nonatomic)   UIButton *hostBtn;              /** 热门 */
@property (strong, nonatomic)   UIButton *priceBtn;              /** 价格 */
@property (strong, nonatomic)   UIButton *goodBtn;              /** 好评 */
@property (strong, nonatomic)   UIButton *newsBtn;              /** 新品 */
@property (strong, nonatomic)   UILabel *lineLabel;              /** 选中的线 */
@property (strong, nonatomic)   UIButton *oldBtn;              /** 之前选中的button */
@end

@implementation SXTGoodsListTopButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.hostBtn];
        [self addSubview:self.priceBtn];
        [self addSubview:self.goodBtn];
        [self addSubview:self.newsBtn];
        [self addSubview:self.lineLabel];
        self.oldBtn = _hostBtn;
        [self addLayout];
    }
    return self;
}

- (void)addLayout{
    __weak typeof (self) weakSelf = self;
    [_hostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(VIEW_WIDTH/4);
    }];
    
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(VIEW_WIDTH/4);
        make.left.equalTo(weakSelf.hostBtn.mas_right);
    }];
    
    [_goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(VIEW_WIDTH/4);
        make.left.equalTo(weakSelf.priceBtn.mas_right);
    }];
    
    [_newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(VIEW_WIDTH/4);
        make.left.equalTo(weakSelf.goodBtn.mas_right);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(40, 2));
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.centerX.equalTo(weakSelf.hostBtn.mas_centerX);
    }];
}

- (void)fourBtnTouchMethod:(UIButton *)selectBtn{
    selectBtn.selected = YES;
    _oldBtn.selected = NO;
    _oldBtn = selectBtn;
    __weak typeof (self) weakSelf = self;
    [_lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(40, 2));
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.centerX.equalTo(selectBtn.mas_centerX);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (UIButton *)hostBtn{
    if (!_hostBtn) {
        _hostBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_hostBtn setTitle:@"热门" forState:(UIControlStateNormal)];
        _hostBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_hostBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_hostBtn setTitleColor:RGB(56, 166, 243) forState:(UIControlStateSelected)];
        [_hostBtn addTarget:self action:@selector(fourBtnTouchMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        _hostBtn.selected = YES;
    }
    return _hostBtn;
}

- (UIButton *)priceBtn{
    if (!_priceBtn) {
        _priceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_priceBtn setTitle:@"价格" forState:(UIControlStateNormal)];
        _priceBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_priceBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_priceBtn setTitleColor:RGB(56, 166, 243) forState:(UIControlStateSelected)];
        [_priceBtn addTarget:self action:@selector(fourBtnTouchMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        _priceBtn.selected = NO;
    }
    return _priceBtn;
}

- (UIButton *)goodBtn{
    if (!_goodBtn) {
        _goodBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_goodBtn setTitle:@"好评" forState:(UIControlStateNormal)];
        _goodBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_goodBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_goodBtn setTitleColor:RGB(56, 166, 243) forState:(UIControlStateSelected)];
        [_goodBtn addTarget:self action:@selector(fourBtnTouchMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        _goodBtn.selected = NO;
    }
    return _goodBtn;
}

- (UIButton *)newsBtn{
    if (!_newsBtn) {
        _newsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_newsBtn setTitle:@"新品" forState:(UIControlStateNormal)];
        _newsBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_newsBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_newsBtn setTitleColor:RGB(56, 166, 243) forState:(UIControlStateSelected)];
        [_newsBtn addTarget:self action:@selector(fourBtnTouchMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        _newsBtn.selected = NO;
    }
    return _newsBtn;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = RGB(56, 166, 243);
    }
    return _lineLabel;
}



@end







