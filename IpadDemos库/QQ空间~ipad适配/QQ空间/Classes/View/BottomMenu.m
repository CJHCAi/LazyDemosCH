//
//  BottomMenu.m
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "BottomMenu.h"

@implementation BottomMenu

#pragma mark - 初始化控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBottomMenuItemWithImageName:@"tabbar_mood" type:kBottomMenuItemTypeMood];
        [self setupBottomMenuItemWithImageName:@"tabbar_photo" type:kBottomMenuItemTypePhoto];
        [self setupBottomMenuItemWithImageName:@"tabbar_blog" type:kBottomMenuItemTypeBlog];
        
    }
    return self;
}

- (void)setupBottomMenuItemWithImageName:(NSString *)imageName type:(BottomMenuItemType)type
{
    UIButton *item = [[UIButton alloc] init];
    [item setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:@"tabbar_separate_selected_bg"] forState:UIControlStateHighlighted];
    
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    item.tag = type;
    
    [self addSubview:item];
}

- (void)itemClick:(UIButton *)item
{
    // 当按钮发生点击,通知代理来做事情
    if ([self.delegate respondsToSelector:@selector(bottomMenu:type:)]) {
        [self.delegate bottomMenu:self type:(int)item.tag];
    }
}

#pragma mark - 拿到屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape
{
    // 0.拿到子控件的个数
    NSInteger count = self.subviews.count;
    
    // 1.设置自身frame
    self.width = self.superview.width;
    self.height = isLandscape ? kDockItemHeight : kDockItemHeight * count;
    self.y = self.superview.height - self.height;
    
    // 2.设置子控件的frame
    for (int i = 0; i < count; i++) {
        UIButton *item = self.subviews[i];
        item.width = isLandscape ? self.width / count : self.width;
        item.height = kDockItemHeight;
        item.x = isLandscape ? item.width * i : 0;
        item.y = isLandscape ? 0 : item.height * i;
    }
}

@end
