//
//  AppDelegate.h
//  xingtu
//
//  Created by Wondergirl on 2016/12/9.
//  Copyright © 2016年 Wondgirl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)LeftSlideViewController * leftSlideVC;  //!< 抽屉
@end

