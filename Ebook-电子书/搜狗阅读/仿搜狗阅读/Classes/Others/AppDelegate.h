//
//  AppDelegate.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

@property (nonatomic, strong) UIViewController *leftslideViewController;
@property (nonatomic, strong) UIViewController *bookstoreViewController;
@property (nonatomic, strong) UIViewController *discoverViewController;
@property (nonatomic, strong) UICollectionViewController *bookshelfViewController;




+ (AppDelegate *)globalDelegate;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;

@end

