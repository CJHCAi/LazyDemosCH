//
//  UIImageView+CYCrop.m
//  CYImageCrop
//
//  Created by Cyrus on 16/6/10.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import "UIImageView+CYCrop.h"

#import <objc/runtime.h>

const static char *CYCropViewKey = "CYCropViewKey";

@implementation UIImageView (CYCrop)

/** 利用关联对象 添加一个 cropView */
- (CYCropView *)cy_cropView {
    CYCropView *cropView = objc_getAssociatedObject(self, CYCropViewKey);
    if (!cropView) {
        CYCropView *newCropView = [[CYCropView alloc] initWithFrame:self.cy_contentFrame];
        self.cy_cropView = newCropView;
        return newCropView;
    }
    return cropView;
}

- (void)setCy_cropView:(UIView *)cy_cropView {
    objc_setAssociatedObject(self, CYCropViewKey, cy_cropView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 计算出 imageView 中显示内容的尺寸 */
- (CGRect)cy_contentFrame {
    
    // 目前只支持这三种缩放类型 UIViewContentModeScaleToFill / UIViewContentModeScaleAspectFill / UIViewContentModeScaleAspectFit
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFill:
            self.clipsToBounds = YES;
        case UIViewContentModeScaleToFill:
            return self.bounds;
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat x = 0.0;
            CGFloat y = 0.0;
            CGFloat width = 0.0;
            CGFloat height = 0.0;
            CGSize imageSize = self.image.size;
            if ((imageSize.width / imageSize.height) >= (self.frame.size.width / self.frame.size.height)) {
                width = self.frame.size.width;
                height = width / (imageSize.width / imageSize.height);
                x = 0.0;
                y = self.frame.size.height/2.0 - height/2.0;
            } else {
                height = self.frame.size.height;
                width = (imageSize.width / imageSize.height) * height;
                y = 0.0;
                x = self.frame.size.width/2.0 - width/2.0;
            }
            return CGRectMake(x, y, width, height);
        }
        default:
            return CGRectZero;
            break;
    }
}

- (void)layoutSubviews {
    // 因为有可能在布局前访问了 cropView，导致 cropView 的 frame 不准确
    // 所以在 imageView 布局后更新一下 cropView 的 frame
    [super layoutSubviews];
    self.cy_cropView.frame = self.cy_contentFrame;
}

/** 返回实际裁剪区域的 frame */
- (CGRect)cy_cropFrame {
    return self.cy_cropView.cropFrame;
}
- (CGRect)cy_cropFrameRatio {
    return self.cy_cropView.cropFrameRatio;
}

/** 设置裁剪框的类型 默认进行动画 */
- (void)cy_setScaleType:(CYCropScaleType)scaleType {
    [self cy_setScaleType:scaleType animated:YES];
}

/** 设置裁剪框的类型以及是否进行动画 */
- (void)cy_setScaleType:(CYCropScaleType)scaleType animated:(BOOL)animated {
    [self.cy_cropView setScaleType:scaleType animated:animated];
}

/** 隐藏裁剪框 */
- (void)cy_hideCropView {
    [UIView animateWithDuration:0.15 animations:^{
        self.cy_cropView.alpha = 0.0;
    }];
}

/** 显示裁剪框 */
- (void)cy_showCropView {
    [UIView animateWithDuration:0.15 animations:^{
        self.cy_cropView.alpha = 1.0;
    }];
}


/** 根据类型 显示裁剪框 */
- (void)cy_showCropViewWithType:(CYCropScaleType)type {
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = YES;
    }
    // 如果还没被加到父视图
    if (!self.cy_cropView.superview) {
        [self addSubview:self.cy_cropView];
        [self cy_showCropView];
        [self cy_setScaleType:type animated:NO];
        return;
    } else {
        // 如果还未显示，不用进行缩放时的动画，只要显示整个视图的动画
        if (self.cy_cropView.alpha == 0) {
            [self cy_showCropView];
            [self cy_setScaleType:type animated:NO];
        } else {
            [self cy_setScaleType:type animated:YES];
        }
    }
}

/** 设置每次拖拽裁剪框后的回调 */
- (void)cy_setComplectionHandler:(void (^)())complectionHandler {
    self.cy_cropView.completionHandler = complectionHandler;
}



@end
