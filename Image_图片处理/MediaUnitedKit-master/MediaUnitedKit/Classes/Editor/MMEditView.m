//
//  MMEditView.m
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/21.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMEditView.h"

@interface MMEditView ()

@property (nonatomic,strong) UIImageView *midImageView;

@end

@implementation MMEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [RGBColor(190, 193, 195, 1.0) CGColor];
        layer.frame = CGRectMake(0, 0, self.width, 0.7);
        [self.layer addSublayer:layer];
        // 取消按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 完成按钮
        button = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-60, 0, 60, 50)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 102;
        [button setImage:[UIImage imageNamed:@"menu_finish"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 中间的图片
        [self addSubview:self.midImageView];
    }
    return self;
}

- (void)setMidImage:(UIImage *)midImage
{
    self.midImageView.image = midImage;
}

#pragma mark  - 视图
- (UIImageView *)midImageView
{
    if (!_midImageView) {
        CGFloat h = 28;
        _midImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-h)/2, (50-h)/2, h, h)];
    }
    return _midImageView;
}

#pragma mark - 点击事件
- (void)btClicked:(UIButton *)btn
{
    OperateType type;
    if (btn.tag == 101) {
        type = kOperateTypeCancel;
    } else {
        type = kOperateTypeFinish;
    }
    if ([self.delegate respondsToSelector:@selector(editView:operateType:)]) {
        [self.delegate editView:self operateType:type];
    }
}

@end
