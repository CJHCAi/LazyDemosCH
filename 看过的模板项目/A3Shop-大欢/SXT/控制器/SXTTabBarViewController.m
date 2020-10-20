//
//  SXTTabBarViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTTabBarViewController.h"
#import "SXTNavigationViewController.h"
@interface SXTTabBarViewController ()
@property (strong, nonatomic)   NSArray *viewControllerArray;//存放view信息的数组
@end


@implementation SXTTabBarViewController

- (NSArray *)viewControllerArray{
    if (!_viewControllerArray) {
        _viewControllerArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SXTTabBarViewController" ofType:@"plist"]];
    }
    return _viewControllerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:56/255.0 green:165/255.0 blue:241/255.0 alpha:1]} forState:(UIControlStateSelected)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1]} forState:(UIControlStateNormal)];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_back"]];
    for (NSDictionary *dic in self.viewControllerArray) {
        Class view = NSClassFromString(dic[@"viewController"]);
        UIViewController *viewController = [[view alloc]init];
        viewController.tabBarItem.image = [UIImage imageNamed:dic[@"image"]];
        viewController.tabBarItem.selectedImage = [UIImage imageNamed:dic[@"selectImage"]];
        viewController.title = dic[@"title"];
        SXTNavigationViewController *nav = [[SXTNavigationViewController alloc]initWithRootViewController:viewController];
        [self addChildViewController:nav];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
