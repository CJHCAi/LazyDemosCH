//
//  XMGActiveMenu.h
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGActiveMenu;
@protocol XMGActiveMenuDelegate <NSObject>

@optional
- (void)activeMenuDidClickCloseBtn:(XMGActiveMenu *)menu;

@end

@interface XMGActiveMenu : UIView

@property (nonatomic, weak) id<XMGActiveMenuDelegate> delegate;

// 如果一个控制器从xib加载，控件的尺寸默认跟xib一样大
+ (instancetype)activeMenu;

+ (instancetype)showInPoint:(CGPoint)point;

+ (void)hideInPoint:(CGPoint)point completion:(void(^)())completion;

@end
