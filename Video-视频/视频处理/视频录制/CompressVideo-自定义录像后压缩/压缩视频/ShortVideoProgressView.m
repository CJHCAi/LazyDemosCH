//
//  ShortVideoProgressView.m
//  压缩视频
//
//  Created by 施永辉 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ShortVideoProgressView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+Extension.h"
#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]
@implementation ShortVideoProgressView

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
