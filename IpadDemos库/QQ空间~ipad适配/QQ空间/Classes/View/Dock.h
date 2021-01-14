//
//  Dock.h
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BottomMenu, Tabbar, IconButton;

@interface Dock : UIView

@property (nonatomic, weak, readonly) BottomMenu *bottomMenu;
@property (nonatomic, weak, readonly) Tabbar *tabbar;
@property (nonatomic, weak, readonly) IconButton *iconButton;

// 告知Dock目前屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape;

@end
