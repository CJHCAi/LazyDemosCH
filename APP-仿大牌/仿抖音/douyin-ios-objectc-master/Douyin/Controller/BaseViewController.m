//
//  BaseViewController.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
@interface BaseViewController ()
@property (nonatomic, strong) UIView *customizedStatusBar;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNavigationBarTransparent];
}

- (void) initNavigationBarTransparent {
    [self setNavigationBarTitleColor:ColorWhite];
    [self setNavigationBarBackgroundImage:[UIImage new]];
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNavigationBarShadowImage:[UIImage new]];
    [self initLeftBarButton:@"icon_titlebar_whiteback"];
    [self setBackgroundColor:ColorThemeBackground];
}


- (void) setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void) setTranslucentCover {
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 1;
    [self.view addSubview:visualEffectView];
}

- (void) initLeftBarButton:(NSString *)imageName {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    leftButton.tintColor = ColorWhite;
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) setStatusBarHidden:(BOOL) hidden {
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}

//- (void) setStatusBarBackgroundColor:(UIColor *)color {
////    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
////    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
////        statusBar.backgroundColor = color;
////    }
//
//}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    if (@available(iOS 13.0, *)) {// iOS 13 不能直接获取到statusbar 手动添加个view到window上当做statusbar背景
          if (!self.customizedStatusBar) {
              //获取keyWindow
              UIWindow *keyWindow = [self getKeyWindow];
              self.customizedStatusBar = [[UIView alloc] initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
                  [keyWindow addSubview:self.customizedStatusBar];
          }
      }
     else {
        self.customizedStatusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
     }
 
      if ([self.customizedStatusBar respondsToSelector:@selector(setBackgroundColor:)]) {
          self.customizedStatusBar.backgroundColor = color;
      }
}

- (UIWindow *)getKeyWindow
{
    // 获取keywindow
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
 
     //  判断取到的window是不是keywidow
    if (!window.hidden || window.isKeyWindow) {
        return window;
    }
 
    //  如果上面的方式取到的window 不是keywidow时  通过遍历windows取keywindow
    for (UIWindow *window in array) {
        if (!window.hidden || window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}



- (void) setNavigationBarTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void) setNavigationBarTitleColor:(UIColor *)color {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

- (void) setNavigationBarBackgroundColor:(UIColor *)color {
    [self.navigationController.navigationBar setBackgroundColor:color];
}

- (void) setNavigationBarBackgroundImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void) setStatusBarStyle:(UIStatusBarStyle)style {
    [UIApplication sharedApplication].statusBarStyle = style;
}

- (void) setNavigationBarShadowImage:(UIImage *)image {
    [self.navigationController.navigationBar setShadowImage:image];
}

- (void) back {
    [self.navigationController popViewControllerAnimated:true];
}

- (void) dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat) navagationBarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (void) setLeftButton:(NSString *)imageName {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15.0f, StatusBarHeight + 11, 20.0f, 20.0f);
    [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:leftButton];
    });
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}

@end
