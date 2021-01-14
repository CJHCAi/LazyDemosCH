//
//  Dock.m
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "Dock.h"
#import "BottomMenu.h"
#import "Tabbar.h"
#import "IconButton.h"

@interface Dock()

@end

@implementation Dock

#pragma mark - 初始化控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBottomMenu];
        [self setupTabbar];
        [self setupIconButton];
    }
    return self;
}

- (void)setupIconButton
{
    IconButton *iconButton = [[IconButton alloc] init];
    [self addSubview:iconButton];
    _iconButton = iconButton;
}

- (void)setupTabbar
{
    Tabbar *tabbar = [[Tabbar alloc] init];
    tabbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin; // 随着父控件的变化上面可拉伸
    [self addSubview:tabbar];
    _tabbar = tabbar;
}

- (void)setupBottomMenu
{
    BottomMenu *bottomMenu = [[BottomMenu alloc] init];
    bottomMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin; // 随着父控件的变化上面可拉伸
    [self addSubview:bottomMenu];
    _bottomMenu = bottomMenu;
}

#pragma mark - 拿到屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape
{
    // 1.设置Dock的宽度
    self.width = isLandscape ? kDockLandscapeWidth : kDockPortraitWidth;
    
    // 2.设置BottomMenu的frame
    [self.bottomMenu rotateToLandscape:isLandscape];
    
    // 3.设置tabbar的frame
    [self.tabbar rotateToLandscape:isLandscape];
    self.tabbar.y = self.height - self.tabbar.height - self.bottomMenu.height;
    
    // 3.设置IconButton的frame
    [self.iconButton rotateToLandscape:isLandscape];
}

@end
