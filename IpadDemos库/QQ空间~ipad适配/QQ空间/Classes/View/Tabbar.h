//
//  Tabbar.h
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tabbar;

@protocol TabbarDelegate <NSObject>

@optional
- (void)tabbar:(Tabbar *)tabbar fromIndex:(NSInteger)from toIndex:(NSInteger)to;

@end

@interface Tabbar : UIView

@property (nonatomic, weak) id<TabbarDelegate> delegate;

// 告知Tabbar当前屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape;

// 让SelectItem变成不选中
- (void)unSelected;

@end




#pragma mark - TabbarItem类
@interface TabbarItem : UIButton

@end
