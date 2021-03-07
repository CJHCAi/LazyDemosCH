//
//  WaveView.m
//  QHPay
//
//  Created by liqunfei on 16/3/22.
//  Copyright © 2016年 chenlizhu. All rights reserved.
//

#import "WaveView.h"

@implementation UIView(Frame)

- (void)setTop:(CGFloat)top {
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.left, bottom - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)left {
    self.frame = CGRectMake(left, self.top, self.width, self.height);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.top,self.width, self.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end

@implementation WaveView
static NSString * cellMoveKey = @"waveMoveAnimation";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.bounds.size.width / 2;
        self.layer.borderColor = RGBA(82, 172, 205, 1.0f).CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)buildUI {
    self.waveImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 650, 300)];
    self.waveImgView.image = [UIImage imageNamed:@"fb_wave"];
    self.waveImgView.top = self.bounds.size.width * 2 / 3;
    self.waveImgView.left = 0;
    [self addSubview:self.waveImgView];
    UILabel *enchashLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width / 2 - 10 + 15, self.bounds.size.width, 20)];
    enchashLabel.font = [UIFont systemFontOfSize:12.0f];
    enchashLabel.textColor = RGBA(171, 171, 171, 1.0f);
    enchashLabel.textAlignment = NSTextAlignmentCenter;
    NSString *string = [NSString stringWithFormat:@"再提%@元",self.money];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(2, self.money.length)];
    enchashLabel.attributedText = attributeString;
    UILabel *percent = [[UILabel alloc] initWithFrame:CGRectMake(0, enchashLabel.frame.origin.y -30.0 - 20, self.bounds.size.width, 40.0f)];
    percent.font = [UIFont systemFontOfSize:45.0f];
    NSString *str = self.percent;
    NSMutableAttributedString *attributi = [[NSMutableAttributedString alloc] initWithString:str];
    [attributi setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(str.length - 1, 1)];
    percent.attributedText = attributi;
    percent.textColor = RGBA(82, 172, 205, 1.0f);
    percent.textAlignment = NSTextAlignmentCenter;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"立即取现" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, self.frame.size.width *  5 / 6 - 13, self.bounds.size.width, 26.0f);
    [button addTarget:self action:@selector(pushToCalendar:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:button];
    [self addSubview:percent];
    [self addSubview:enchashLabel];
}

- (void)pushToCalendar:(UIButton *)sender
{
    
}

- (void)addAnimate {
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    moveAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-60],[NSNumber numberWithFloat:self.waveImgView.layer.position.x], nil];
    moveAnimation.duration = 4.0f;
    moveAnimation.repeatCount = MAXFLOAT;
    moveAnimation.autoreverses = YES;
    [self.waveImgView.layer addAnimation:moveAnimation forKey:cellMoveKey];
}

- (void)dealloc {
    [self.waveImgView.layer removeAnimationForKey:cellMoveKey];
}

@end
