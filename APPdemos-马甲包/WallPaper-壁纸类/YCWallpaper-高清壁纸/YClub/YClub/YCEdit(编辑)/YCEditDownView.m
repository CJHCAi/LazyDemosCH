//
//  YCEditDownView.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditDownView.h"

@interface YCEditDownView()

@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *readBtn;
@property (nonatomic, strong) UIView   *lineView;
@end
@implementation YCEditDownView

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"yc_img_download"] forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downBtn addTarget:self action:@selector(downBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _downBtn.titleLabel.font = YC_Base_TitleFont;
        _downBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
        _downBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    }
    return _downBtn;
}
- (UIButton *)readBtn
{
    if (!_readBtn) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_readBtn setImage:[UIImage imageNamed:@"yc_img_look"] forState:UIControlStateNormal];
        [_readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_readBtn addTarget:self action:@selector(readBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _readBtn.titleLabel.font = YC_Base_TitleFont;
        _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
        _readBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        
    }
    return _readBtn;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = YC_Base_GrayEdgeColor;
    }
    return _lineView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.downBtn];
        [self addSubview:self.lineView];
        [self addSubview:self.readBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat kBtnWidth = (KSCREEN_WIDTH-1)/2.f;
    [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(@(kBtnWidth));
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self);
        make.left.equalTo(_downBtn.mas_right);
        make.width.mas_equalTo(@1);
    }];
    [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(@(kBtnWidth));
    }];
}
#pragma mark - BtnAction
- (void)downBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickDownBtn)]) {
        [_delegate clickDownBtn];
    }
}
- (void)readBtnAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickReadBtn:)]) {
        [_delegate clickReadBtn:sender];
    }
}

@end
