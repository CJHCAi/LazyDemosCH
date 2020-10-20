//
//  SDEyeAnimationView.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/11.
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

#import "SDEyeAnimationView.h"

#import "UIView+SDAutoLayout.h"

static const CGFloat kEyeImageViewWidth = 65.0f;
static const CGFloat kEyeImageViewHeight = 44.0f;

@implementation SDEyeAnimationView
{
    UIImageView *_eyeImageView;
    CGFloat _originalY;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _eyeImageView = [UIImageView new];
    _eyeImageView.image = [UIImage imageNamed:@"icon_sight_capture_mask"];
    [self addSubview:_eyeImageView];
    
    _eyeImageView.sd_layout
    .widthIs(kEyeImageViewWidth)
    .heightIs(kEyeImageViewHeight)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    self.progress = 0.0;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self progressAnimationWithProgress:progress];
}


/**绘制眼睛进度*/
- (void)progressAnimationWithProgress:(CGFloat)progress
{
    
    CGFloat eyeViewProgress = MIN(progress, 1);
    CGFloat w = kEyeImageViewWidth * eyeViewProgress;
    CGFloat h = kEyeImageViewHeight;
    if (w < h) {
        h = w;
    }
    CGFloat x = (kEyeImageViewWidth - w) * 0.5;
    CGFloat y = (kEyeImageViewHeight - h) * 0.5;
    CGRect rect = CGRectMake(x, y, w, h);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.path = path.CGPath;
    
    _eyeImageView.layer.mask = mask;
    _eyeImageView.alpha = progress;
    
    
    
    if (_originalY == 0) {
        _originalY = self.top;
    }
    
    CGFloat move = 30 * progress;
    self.top = _originalY + move;
}

@end
