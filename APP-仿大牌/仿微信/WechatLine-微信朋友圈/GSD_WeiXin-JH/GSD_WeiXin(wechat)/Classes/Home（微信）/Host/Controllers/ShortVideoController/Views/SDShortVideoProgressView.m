//
//  SDShortVideoProgressView.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/12.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDShortVideoProgressView.h"

#import "GlobalDefines.h"
#import "UIView+SDAutoLayout.h"

@implementation SDShortVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _progressLine = [UIView new];
    _progressLine.backgroundColor = Global_tintColor;
    [self addSubview:_progressLine];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress >= 0 && progress <= 1.0) {
        [self updateProgressLineWithProgress:progress];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _progressLine.frame = self.bounds;
}

- (void)updateProgressLineWithProgress:(CGFloat)Progress
{
    if (_progressLine.width > self.width) {
        _progressLine.frame = self.bounds;
        _progressLine.transform = CGAffineTransformIdentity;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat x = MIN((1 - Progress), 1);
        _progressLine.transform = CGAffineTransformMakeScale(x, 1);
        [_progressLine setNeedsDisplay];
    });
}

@end

