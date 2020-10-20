//
//  SSAudioPlayProgressBar.m
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/4.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSAudioPlayProgressBar.h"
#import "UIColor+hex.h"

@interface SSAudioPlayProgressBar()
@property (strong, nonatomic) CAShapeLayer *barLayer;
@property (strong, nonatomic) UIView *bar;
@end

@implementation SSAudioPlayProgressBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)initData {
    self.barTintColor = [UIColor colorWithHex:0x00BFA5];
}

- (void)initView {
    self.barLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.barLayer];
    
//    self.bar = [[UIView alloc] init];
//    self.bar.backgroundColor = [UIColor orangeColor];
//    [self addSubview:self.bar];
}

- (void)updateLayout {
    self.barLayer.frame = self.bounds;
    self.bar.frame = self.bounds;
}

#pragma mark - set / get

- (void)setPercentage:(CGFloat)percentage { 
    _percentage = percentage;
    [self updateBarPercentage];
}

#pragma mark - Private

//- (void)updateBarPercentage {
//    CGFloat width = self.bounds.size.width;
//    CGFloat barWidth = self.percentage * width;
//    CGFloat barHeight = self.bounds.size.height;
//    self.bar.frame = CGRectMake(0, 0, barWidth, barHeight);
//}

- (void)updateBarPercentage {
    CGFloat width = self.bounds.size.width;
    CGFloat barWidth = self.percentage * width;
    CGFloat barHeight = self.bounds.size.height;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, barWidth, barHeight)];
    self.barLayer.path = path.CGPath;
    self.barLayer.fillColor = self.barTintColor.CGColor;
}

@end









