//
//  IconButton.m
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "IconButton.h"

@implementation IconButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"Easy"] forState:UIControlStateNormal];
        [self setTitle:@"小码哥" forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

#pragma mark - 拿到屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape
{
    // 设置自身的Frame
    self.width = isLandscape ? kIconButtonLandscapeWidth : kIconButtonPortraitWH;
    self.height = isLandscape ? kIconButtonLandscapeHeight : kIconButtonPortraitWH;
    self.x = (self.superview.width - self.width) * 0.5;
    self.y = kIconButtonY;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (self.width == self.height) { // 竖屏
        return self.bounds;
    } else { // 横屏
        CGFloat width = self.width;
        CGFloat height = width;
        CGFloat x = 0;
        CGFloat y = 0;
        return CGRectMake(x, y, width, height);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (self.width == self.height) { // 竖屏
        return CGRectMake(0, 0, -1, -1);
    } else { // 横屏
        CGFloat width = self.width;
        CGFloat height = kIconButtonLandscapeTitleH;
        CGFloat x = 0;
        CGFloat y = self.width;
        return CGRectMake(x, y, width, height);
    }
}

@end
