//
//  AppDelegate.h
//  YJDemo
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "MyControl.h"
#define GrayLine [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
#define GreenFont UIColorFromRGB(0x24C67F)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

