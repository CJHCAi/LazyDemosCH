//
//  MMTabBar.h
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/21.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  底部菜单
//

#import <UIKit/UIKit.h>

@protocol MMTabBarDelegate;
@interface MMTabBar : UIView

// 代理
@property (nonatomic,assign) id<MMTabBarDelegate> delegate;

- (MMTabBar *)initWithFrame:(CGRect)frame
                     titles:(NSArray *)titles
                     images:(NSArray *)images
               selectdColor:(UIColor *)selectdColor
             selectedImages:(NSArray *)selectedImages;

@end

@protocol MMTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MMTabBar *)tabBar didSelectAtIndex:(NSInteger)index;

@end
