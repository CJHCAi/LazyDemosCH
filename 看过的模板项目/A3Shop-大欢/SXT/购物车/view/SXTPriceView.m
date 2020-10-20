//
//  SXTPriceView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTPriceView.h"

@interface SXTPriceView()

@property (strong, nonatomic)   UILabel *allLabel;              /** 全场包邮 */
@property (strong, nonatomic)   UIButton *goPayButton;              /** 去支付 */

@end

@implementation SXTPriceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.priceLabel];
        [self addSubview:self.allLabel];
        [self addSubview:self.goPayButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(7);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.height.equalTo(@17);
        make.right.equalTo(weakSelf.goPayButton.mas_left).offset(-20);
    }];
    
    [_allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(62, 14));
        make.left.equalTo(weakSelf.mas_left).offset(60);
    }];
    
    [_goPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 35));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-15);
    }];
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 15)];
        _priceLabel.text = @"$111";
        _priceLabel.textColor = [UIColor blackColor];
    }
    return _priceLabel;
}

- (UILabel *)allLabel{
    if (!_allLabel) {
        _allLabel = [[UILabel alloc]init];
        _allLabel.text = @"(全场包邮)";
        _allLabel.font = [UIFont systemFontOfSize:13.0];
        _allLabel.textColor = RGB(87, 87, 87);
    }
    return _allLabel;
}

- (UIButton *)goPayButton{
    if (!_goPayButton) {
        _goPayButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_goPayButton setImage:[UIImage imageNamed:@"购物车界面去结算按钮"] forState:(UIControlStateNormal)];
        [_goPayButton addTarget:self action:@selector(goPayBtnMethod) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _goPayButton;
}

- (void)goPayBtnMethod{
    if (_gotoInsert) {
        _gotoInsert();
    }
}
@end
