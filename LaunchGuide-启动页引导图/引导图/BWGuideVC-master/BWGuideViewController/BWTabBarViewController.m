//
//  BWTabBarViewController.m
//  BWGuideViewController
//
//  Created by syt on 2019/12/20.
//  Copyright © 2019 syt. All rights reserved.
//

#import "BWTabBarViewController.h"

#import "BWFirstViewController.h"
#import "BWSecondViewController.h"


@interface BWTabBarViewController ()

@end

@implementation BWTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildControllers];
}

- (void)addChildControllers
{
    [self addChildController:[BWFirstViewController new] title:@"首页" imageName:@"" selectedImageName:@""];
    [self addChildController:[BWSecondViewController new] title:@"我的" imageName:@"" selectedImageName:@""];
}



// 添加某个 childViewController
- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName {
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}





@end
