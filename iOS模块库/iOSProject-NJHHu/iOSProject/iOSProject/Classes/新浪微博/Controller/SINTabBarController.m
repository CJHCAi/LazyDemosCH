//
//  SINTabBarController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINTabBarController.h"
#import "SINHomeViewController.h"
#import "SINMessageViewController.h"
#import "SINPublishViewController.h"
#import "SINDiscoveryViewController.h"
#import "SINProfileViewController.h"
#import "SINTabBar.h"
#import "PresentAnimator.h"

@interface SINTabBarController ()

@end

@implementation SINTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor orangeColor];
    self.tabBar.unselectedItemTintColor = [UIColor darkTextColor];
    [self setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, -3)] forKeyPath:LMJKeyPath(self, titlePositionAdjustment)];
    [self addTabarItems];
    [self addChildViewControllers];
}


/**
 *  利用 KVC 把系统的 tabBar 类型改为自定义类型。覆盖父类方法
 */
- (void)setUpTabBar {
    SINTabBar *tabBar = [[SINTabBar alloc] init];
    LMJWeak(self);
    [tabBar setPublishBtnClick:^(SINTabBar *tabBar, UIButton *publishBtn){
        if (![SINUserManager sharedManager].isLogined) {
            [weakself.view makeToast:@"请登录" duration:3 position:CSToastPositionCenter];
            return ;
        }
        SINPublishViewController *publishVc = [[SINPublishViewController alloc] init];

        // 封装好了, 直接在 block 里边写动画
        [PresentAnimator viewController:weakself presentViewController:[[LMJNavigationController alloc] initWithRootViewController:publishVc] presentViewFrame:[UIScreen mainScreen].bounds animated:YES completion:nil animatedDuration:0.5 presentAnimation:^(UIView *presentedView, UIView *containerView, void (^completionHandler)(BOOL finished)) {

            containerView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
            [UIView animateWithDuration:0.5 animations:^{
                containerView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                completionHandler(finished);
            }];
            
        } dismissAnimation:^(UIView *dismissView, void (^completionHandler)(BOOL finished)) {
            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.2, 0.2);
            [UIView animateWithDuration:1 animations:^{
                dismissView.transform = CGAffineTransformRotate(transform, M_PI);
            } completion:^(BOOL finished) {
                completionHandler(finished);
            }];
            
        }];
    }];
    
    [self setValue:tabBar forKeyPath:LMJKeyPath(self, tabBar)];
}

- (void)addChildViewControllers
{
    LMJNavigationController *one = [[LMJNavigationController alloc] initWithRootViewController:[[SINHomeViewController alloc] init]];
    
    LMJNavigationController *two = [[LMJNavigationController alloc] initWithRootViewController:[[SINMessageViewController alloc] init]];
    
    LMJNavigationController *four = [[LMJNavigationController alloc] initWithRootViewController:[[SINDiscoveryViewController alloc] init]];
    
    LMJNavigationController *five = [[LMJNavigationController alloc] initWithRootViewController:[[SINProfileViewController alloc] init]];
    
    self.viewControllers = @[one, two, four, five];
}

/*
 
 tabbar_home
 */

- (void)addTabarItems
{
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"tabbar_home",
                                                 CYLTabBarItemSelectedImage : @"tabbar_home_highlighted",
                                                 };
    
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"消息",
                                                  CYLTabBarItemImage : @"tabbar_message_center",
                                                  CYLTabBarItemSelectedImage : @"tabbar_message_center_highlighted",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"发现",
                                                 CYLTabBarItemImage : @"tabbar_discover",
                                                 CYLTabBarItemSelectedImage : @"tabbar_discover_highlighted",
                                                 };
    
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"tabbar_profile",
                                                  CYLTabBarItemSelectedImage : @"tabbar_profile_highlighted"
                                                  };
    
    self.tabBarItemsAttributes = @[
                                   firstTabBarItemsAttributes,
                                   secondTabBarItemsAttributes,
                                   thirdTabBarItemsAttributes,
                                   fourthTabBarItemsAttributes
                                   ];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}


@end

