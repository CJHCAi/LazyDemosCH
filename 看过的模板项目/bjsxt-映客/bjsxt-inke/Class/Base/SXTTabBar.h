//
//  SXTTabBar.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/1.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SXTItemType) {
    
    SXTItemTypeLaunch = 10,//启动直播
    SXTItemTypeLive = 100,//展示直播
    SXTItemTypeMe, //我的

};

@class SXTTabBar;

typedef void(^TabBlock)(SXTTabBar * tabbar,SXTItemType idx);

@protocol SXTTabBarDelegate <NSObject>

- (void)tabbar:(SXTTabBar *)tabbar clickButton:(SXTItemType) idx;

@end

@interface SXTTabBar : UIView

@property (nonatomic, weak) id<SXTTabBarDelegate> delegate;

@property (nonatomic, copy) TabBlock block;

@end
