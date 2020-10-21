//
//  UINavigationController+hidesBottomBarWhenPushed.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/11/18.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "UINavigationController+hidesBottomBarWhenPushed.h"

@implementation UINavigationController (hidesBottomBarWhenPushed)
+ (void)load {
    [self exchangeMethod:@"initWithRootViewController:" exchangeMethod:@selector(hidesBottomBarAndPopnavigationController:)];
    [self exchangeMethod:@"pushViewController:animated:" exchangeMethod:@selector(hidesBottomBarAndPushViewController:animated:)];
}

+ (void)exchangeMethod:(NSString *)originalMethodStr exchangeMethod:(SEL)exchangeMethodSel {
    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(originalMethodStr));
    Method exchangeMethod = class_getInstanceMethod([self class], exchangeMethodSel);
    method_exchangeImplementations(exchangeMethod, originalMethod);
}

- (instancetype)hidesBottomBarAndPopnavigationController:(UIViewController *)rootViewController {
    UINavigationController *nav = [self hidesBottomBarAndPopnavigationController:rootViewController];
    nav.delegate = self;
    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!(self.tabBarController && [self.tabBarController isKindOfClass:[CYTabBarController class]])) {
        return;
    }
    if (navigationController.viewControllers.count == 1) {
        [self hiddenTabBar:@NO];
    }
}

- (void)hidesBottomBarAndPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!(self.tabBarController && [self.tabBarController isKindOfClass:[CYTabBarController class]])) {
        [self hidesBottomBarAndPushViewController:viewController animated:animated];
        return;
    }
    switch ([CYTabBarConfig shared].HidesBottomBarWhenPushedOption) {
        case HidesBottomBarWhenPushedTransform: {
            if ([self.delegate isEqual:self]) {
                if (self.viewControllers.count > 0 ) {
                    [self hiddenTabBar:@YES];
                }
            } else {
                NSLog(@"HidesBottomBarWhenPushedTransform is invalid, the delegate is not itself.");
            }
            [self hidesBottomBarAndPushViewController:viewController animated:animated];
        }
            break;
        case HidesBottomBarWhenPushedAlone: {
            if (self.viewControllers.count > 0) {
                viewController.hidesBottomBarWhenPushed = YES;
            }
            [self hidesBottomBarAndPushViewController:viewController animated:animated];
            CGRect frame = self.tabBarController.tabBar.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
            self.tabBarController.tabBar.frame = frame;
        }
            break;
        default:
            [self hidesBottomBarAndPushViewController:viewController animated:animated];
            break;
    }
}

- (void)hiddenTabBar:(id)hidden {
    SEL faSelector=NSSelectorFromString(@"setTabBarHidden:");
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.tabBarController performSelector:faSelector withObject:hidden];
    #pragma clang diagnostic pop
}
@end
