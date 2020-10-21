//
//  CDNavigationVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDNavigationVC.h"

@interface CDNavigationVC ()<UINavigationBarDelegate>

@end

@implementation CDNavigationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)popToBack
{
    [self popViewControllerAnimated:YES];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}
//#pragma mark --------navigation delegate
////该方法可以解决popRootViewController时tabbar的bug
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    //删除系统自带的tabBarButton
//    for (UIView *tabBar in self.tabBarController.tabBar.subviews)
//    {
//        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")])
//        {
//            [tabBar removeFromSuperview];
//        }
//    }
//    
//}

@end
