//
//  ShoopingCartBottomView.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoopingCartBottomView.h"

@interface ShoopingCartBottomView ()
{
    DDButton *_selectAllBtn;
    UIButton *_balanceBtn;
}
@end

@implementation ShoopingCartBottomView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectAllBtn.frame = CGRectMake(0, 0, 88+20, self.frame.size.height);
    _allPriceLabel.frame = CGRectMake(88+20, 0, kScreenWidth-(88+20)*2-10, self.frame.size.height);
    _balanceBtn.frame = CGRectMake(kScreenWidth-88-20, 0, 88+20, self.frame.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _selectAllBtn = [DDButton buttonWithType:UIButtonTypeCustom];
        [_selectAllBtn setImage:[UIImage imageNamed:@"list_unchoose"] forState:UIControlStateNormal];
        [_selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn addTarget:self action:@selector(selectedAll:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectAllBtn];
        
        _allPriceLabel = [[DDLabel alloc] init];
        _allPriceLabel.text = @"总价：";
        _allPriceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_allPriceLabel];
        
        _balanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_balanceBtn setTitle:@"结算" forState:UIControlStateNormal];
        [_balanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_balanceBtn setBackgroundColor:RED_COLOR];
        [_balanceBtn setAlpha:0.5];
        [_balanceBtn setEnabled:NO];
        [_balanceBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_balanceBtn];
    }
    return self;
}

- (void)selectedAll:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self setBtnImg:btn.selected];
    if ([self.delegate respondsToSelector:@selector(allGoodsIsSelected:withButton:)])
    {
        [self.delegate allGoodsIsSelected:btn.selected withButton:btn];
    }
}
- (void)setBtnImg:(BOOL)selected {
    if (selected) {
        [_selectAllBtn setImage:ImgName(@"list_choose") forState:(UIControlStateNormal)];
    } else {
        [_selectAllBtn setImage:ImgName(@"list_unchoose") forState:(UIControlStateNormal)];
    }
}
- (void)pay:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(paySelectedGoods:)]) {
        [self.delegate paySelectedGoods:btn];
    }
}

- (void)setIsClick:(BOOL)isClick {
    _isClick = isClick;
    _selectAllBtn.selected = _isClick;
    [self setBtnImg:_isClick];
}
- (void)setPayEnable:(BOOL)payEnable {
    _payEnable = payEnable;
    if (_payEnable) {
        [_balanceBtn setAlpha:1.0];
    } else {
        [_balanceBtn setAlpha:0.5];
    }
    [_balanceBtn setEnabled:_payEnable];
}

@end
