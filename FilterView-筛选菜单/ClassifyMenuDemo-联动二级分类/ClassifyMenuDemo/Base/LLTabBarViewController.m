//
//  LLTabBarViewController.m
//  ClassifyMenuDemo
//
//  Created by LiuLi on 2019/2/21.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "LLTabBarViewController.h"
#import "LLNavigationController.h"

#import "ViewController.h"

@interface LLTabBarViewController ()

@end

@implementation LLTabBarViewController

+ (void)initialize {
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor blueColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    ViewController *tempVC = [[ViewController alloc] init];
    [self setUpOneChildVcWithVc:tempVC Image:@"tab_btn_home" selectedImage:@"tab_btn_home_pre" title:@"就一页"];
    // Do any additional setup after loading the view.
}

- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    LLNavigationController *nav = [[LLNavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.image = myImage;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    [self addChildViewController:nav];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
