//
//  YCEditBackView.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditBackView.h"

@interface YCEditBackView ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *loveBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@end

@implementation YCEditBackView
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImg = [UIImage imageNamed:@"yc_img_back"];
        [_backBtn setImage:backImg forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -20, -10, 40);
    }
    return _backBtn;
}
- (UIButton *)loveBtn
{
    if (!_loveBtn) {
        _loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loveBtn setImage:[UIImage imageNamed:@"yc_img_collect_normal"] forState:UIControlStateNormal];
        [_loveBtn setImage:[UIImage imageNamed:@"yc_img_collect_selete"] forState:UIControlStateSelected];
        [_loveBtn addTarget:self action:@selector(loveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _loveBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 17, -12, -17);
    }
    return _loveBtn;
}
- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"yc_img_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        [self addSubview:self.backBtn];
        [self addSubview:self.loveBtn];
        [self addSubview:self.shareBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(@100);
    }];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(@100);
    }];
}
#pragma mark - backBtnAction
- (void)backBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickBackBtn)]) {
        [_delegate clickBackBtn];
    }
}
#pragma mark - loveBtnAction
- (void)loveBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickLoveBtn)]) {
        [_delegate clickLoveBtn];
    }
}
- (void)setLoveBtnSelete:(BOOL)selete
{
    _loveBtn.selected = selete;
}
@end
