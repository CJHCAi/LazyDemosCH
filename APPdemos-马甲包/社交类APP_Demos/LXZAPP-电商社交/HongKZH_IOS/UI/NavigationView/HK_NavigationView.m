//
//  HK_NavigationView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_NavigationView.h"

@interface HK_NavigationView ()<UINavigationControllerDelegate>

@end

@implementation HK_NavigationView


- (UIStatusBarStyle)preferredStatusBarStyle
{
    if(self.viewControllers.count>1){
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreMore) name:@"moreMore" object:nil];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark 当push的时候调用这个方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count>0){
        viewController.hidesBottomBarWhenPushed=YES; //当push 的时候隐藏底部兰
    }
    
    [super pushViewController:viewController animated:animated];
    if (@available(iOS 11.0, *)) {
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated{
    //加上
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
            
        }
        
    }
}


-(void)moreMore
{
    return;
    if (@available(iOS 11.0, *)) {
        for (UIView *tabBarButton in self.tabBarController.tabBar.subviews) {
            if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButton removeFromSuperview];
            }
        }
    }
    else{
        for (UIView *tabBarButton in self.tabBarController.tabBar.subviews) {
            if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButton removeFromSuperview];
            }
        }
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moreMore" object:nil];
}

@end
