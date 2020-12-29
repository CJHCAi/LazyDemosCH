//
//  NavigationViewController.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/28.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()
@property (weak, nonatomic) IBOutlet UITabBarItem *one;
@property (weak, nonatomic) IBOutlet UITabBarItem *two;
@property (weak, nonatomic) IBOutlet UITabBarItem *Three;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [UIImage imageNamed:@"arrow_return.png"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, img.size.width, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0)forBarMetrics:UIBarMetricsDefault];
    
    
    
//    UIImage *selected1 = [UIImage imageNamed:@"tab_1_h"];
//    _one.selectedImage = [selected1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *selected2 = [UIImage imageNamed:@"tab_2_h"];
//    _two.selectedImage = [selected2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *selected3 = [UIImage imageNamed:@"tab_3_h"];
//    _Three.selectedImage = [selected3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UITabBar appearance] setTintColor:colorAll];

    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSAssert(self.viewControllers.count != 0, @"异常");
    
    UIViewController* lastController = [self.viewControllers lastObject];
    //push隐藏地底部
    [lastController setHidesBottomBarWhenPushed:YES];
    [super pushViewController:viewController animated:animated];
    
    if ([self.viewControllers objectAtIndex:0] == lastController) {
        
        [lastController setHidesBottomBarWhenPushed:NO];
    }
    
    
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
