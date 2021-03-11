//
//  ViewController.m
//  DrivingLicense
//
//  Created by #incloud on 17/1/17.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"
#import "homePageViewController.h"
#import "userPageViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UITabBarController *contentTabBarController;

@end

@implementation ViewController

-(UITabBarController *)contentTabBarController
{
    if (!_contentTabBarController)
    {
        _contentTabBarController = [[UITabBarController alloc] init];
        homePageViewController *home  = [[homePageViewController alloc] init];
        userPageViewController *user = [[userPageViewController alloc] init];
        UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:home];
        homeNC.navigationBar.translucent = NO;
        UINavigationController *userNC = [[UINavigationController alloc] initWithRootViewController:user];
        userNC.navigationBar.translucent = NO;
        _contentTabBarController.viewControllers = [[NSArray alloc] initWithObjects:homeNC, userNC, nil];
        
        UIImage *userImgNormal  = [[UIImage imageNamed:@"user_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *userImghighlight = [[UIImage imageNamed:@"user_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *homeImgNormal = [[UIImage imageNamed:@"notepad_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *homeImghighlight = [[UIImage imageNamed:@"notepad_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        homeNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"驾考" image:homeImgNormal selectedImage:homeImghighlight];
        userNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:userImgNormal selectedImage:userImghighlight];
        
        _contentTabBarController.tabBar.tintColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    }
    return _contentTabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.contentTabBarController];
    [self.view addSubview:self.contentTabBarController.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
