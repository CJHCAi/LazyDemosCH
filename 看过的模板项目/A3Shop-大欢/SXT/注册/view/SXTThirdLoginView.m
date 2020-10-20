//
//  SXTThirdLoginView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTThirdLoginView.h"

@interface SXTThirdLoginView()
@property (strong, nonatomic)   UIButton *qqLoginBtn;              /** qq登录button */
@property (strong, nonatomic)   UIButton *WXLoginBtn;              /** 微信登陆button */
@property (strong, nonatomic)   UIButton *sinaLoginBtn;              /** 新浪登录 */
@property (strong, nonatomic)   UILabel *oneLogin;              /** 一键登录 */
@property (strong, nonatomic)   UILabel *lineLabel;              /** 分割线 */
@end

@implementation SXTThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineLabel];
        [self addSubview:self.oneLogin];
        [self addSubview:self.qqLoginBtn];
        [self addSubview:self.sinaLoginBtn];
        [self addSubview:self.WXLoginBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [_oneLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top);
    }];
    
    [_WXLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneLogin.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    [_qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneLogin.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.equalTo(weakSelf.WXLoginBtn.mas_left).offset(-(VIEW_WIDTH-135)/4);
    }];
    
    [_sinaLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneLogin.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.equalTo(weakSelf.WXLoginBtn.mas_right).offset((VIEW_WIDTH-135)/4);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.oneLogin.mas_centerY);
        make.height.equalTo(@1);
        make.left.equalTo(weakSelf.mas_left).offset(16);
        make.right.equalTo(weakSelf.mas_right).offset(-16);
    }];
}

- (UILabel *)oneLogin{
    if (!_oneLogin) {
        _oneLogin = [[UILabel alloc]init];
        _oneLogin.text = @"一键登录";
        _oneLogin.textColor = RGB(190, 190, 190);
        _oneLogin.backgroundColor = MainColor;
        _oneLogin.textAlignment = NSTextAlignmentCenter;
        _oneLogin.font = [UIFont systemFontOfSize:16.0];
    }
    return _oneLogin;
}

- (UIButton *)qqLoginBtn{
    if (!_qqLoginBtn) {
        _qqLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_qqLoginBtn setImage:[UIImage imageNamed:@"登录界面qq登陆"] forState:(UIControlStateNormal)];
        [_qqLoginBtn addTarget:self action:@selector(qqLandingBtnMethod) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _qqLoginBtn;
}

- (UIButton *)WXLoginBtn{
    if (!_WXLoginBtn) {
        _WXLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_WXLoginBtn setImage:[UIImage imageNamed:@"登录界面微信登录"] forState:(UIControlStateNormal)];
    }
    return _WXLoginBtn;
}

- (UIButton *)sinaLoginBtn{
    if (!_sinaLoginBtn) {
        _sinaLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sinaLoginBtn setImage:[UIImage imageNamed:@"登陆界面微博登录"] forState:(UIControlStateNormal)];
    }
    return _sinaLoginBtn;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = RGB(190, 190, 190);
    }
    return _lineLabel;
}

- (void)qqLandingBtnMethod{
    if(_qqBlock){
        _qqBlock();
    }
}

@end
