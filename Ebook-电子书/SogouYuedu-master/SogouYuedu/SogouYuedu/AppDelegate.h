//
//  AppDelegate.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/25.
//  Copyright © 2017年 andyron. All rights reserved.
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

