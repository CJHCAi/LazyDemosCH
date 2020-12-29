//
//  HKBaseShareView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseShareView.h"
#import "UIButton+ZSYYWebImage.h"
@implementation HKBaseShareView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    [self addSubview:self.iconBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(50);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBtn.mas_right).offset(10);
        make.top.equalTo(self.iconBtn);
        make.right.lessThanOrEqualTo(self).offset(-10);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBtn.mas_right).offset(10);
        make.bottom.equalTo(self.iconBtn);
        make.right.lessThanOrEqualTo(self).offset(-10);
    }];
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToVc)];
    [self addGestureRecognizer:tap];
}
-(void)clickToVc{
    if ([self.delegate respondsToSelector:@selector(contentClick)]) {
        [self.delegate contentClick];
    }
}
-(UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [[UIButton alloc]init];
    }
    return _iconBtn;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = PingFangSCMedium14;
        _titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    return _titleLabel;
}
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = PingFangSCMedium14;
        _descLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    return _descLabel;
}
-(void)setMessage:(ShareMessage *)message{
    _message = message;
    [self.iconBtn hk_setBackgroundImageWithURL:message.imgSrc forState:0 placeholder:kPlaceholderHeadImage];
    self.titleLabel.text = message.title;
    self.descLabel.text = message.source.length>0?[NSString stringWithFormat:@"来自%@",message.source]:@"分享自乐小转";
//    self.descLabel.text = message.level;
}
@end
