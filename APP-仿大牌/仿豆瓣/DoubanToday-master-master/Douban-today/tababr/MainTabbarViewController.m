//
//  MainTabbarViewController.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "DouTodayViewController.h"
#import "ViewController.h"


@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DouTodayViewController *douTodayVC = [DouTodayViewController new];
    [self setChildViewController:douTodayVC title:nil image:@"dou" selectImage:@"dou-select"];
    ViewController *vc = [ViewController new];
    [self setChildViewController:vc title:nil image:@"xcode" selectImage:@"xcode-select"];
}

-(void)setChildViewController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    static NSInteger index = 0;
    viewController.tabBarItem.title = title;
    viewController.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.tag = index;
    index++;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
