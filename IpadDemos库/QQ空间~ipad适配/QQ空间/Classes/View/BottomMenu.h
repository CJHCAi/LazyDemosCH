//
//  BottomMenu.h
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BottomMenu;

typedef enum {
    kBottomMenuItemTypeMood,
    kBottomMenuItemTypePhoto,
    kBottomMenuItemTypeBlog
} BottomMenuItemType;

@protocol BottomMenuDelegate <NSObject>

@optional
- (void)bottomMenu:(BottomMenu *)bottomMenu type:(BottomMenuItemType)type;

@end

@interface BottomMenu : UIView

@property (nonatomic, weak) id<BottomMenuDelegate> delegate;

// 告知Dock目前屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape;

@end
