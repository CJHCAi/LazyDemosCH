//
//  HK_BlackNavigationView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BlackNavigationView.h"

@interface HK_BlackNavigationView ()

@end

@implementation HK_BlackNavigationView


- (UIStatusBarStyle)preferredStatusBarStyle
{
    if(self.viewControllers.count>1){
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreMore) name:@"moreMore" object:nil];
    // Do any additional setup after loading the view.
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated{
    //加上
    [self.tabBarController.tabBar removeFromSuperview];
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
        [self moreMore];
    }
}

-(void)moreMore
{
    return;
    for (UIView *tabBarButton in self.tabBarController.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moreMore" object:nil];
}


@end
