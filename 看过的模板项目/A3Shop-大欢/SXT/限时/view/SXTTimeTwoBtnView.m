//
//  SXTTimeTwoBtnView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/22.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTTimeTwoBtnView.h"

@interface SXTTimeTwoBtnView()

@end

@implementation SXTTimeTwoBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.button1];
        [self addSubview:self.button2];
    }
    return self;
}

- (UIButton *)button1{
    if (!_button1) {
        _button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _button1.frame = CGRectMake(0, 0, VIEW_WIDTH/2, 50);
        [_button1 setTitle:@"新品团购" forState:(UIControlStateNormal)];
        [_button1 setImage:[UIImage imageNamed:@"限时特卖界面新品团购图标未选中"] forState:(UIControlStateNormal)];
        [_button1 setImage:[UIImage imageNamed:@"限时特卖界面新品团购图标"] forState:(UIControlStateSelected)];
        [_button1 setTitleColor:RGB(56, 166, 243) forState:(UIControlStateNormal)];
        [_button1 setTitleColor:RGB(213, 48, 34) forState:(UIControlStateSelected)];
        _button1.selected = YES;
    }
    return _button1;
}

- (UIButton *)button2{
    if (!_button2) {
        _button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _button2.frame = CGRectMake(VIEW_WIDTH/2, 0, VIEW_WIDTH/2, 50);
        [_button2 setTitle:@"品牌团购" forState:(UIControlStateNormal)];
        [_button2 setImage:[UIImage imageNamed:@"限时特卖界面品牌团购图标"] forState:(UIControlStateNormal)];
        [_button2 setImage:[UIImage imageNamed:@"限时特卖界面品牌团购图标选中"] forState:(UIControlStateSelected)];
        [_button2 setTitleColor:RGB(56, 166, 243) forState:(UIControlStateNormal)];
        [_button2 setTitleColor:RGB(213, 48, 34) forState:(UIControlStateSelected)];
        _button2.selected = NO;
    }
    return _button2;
}
@end
