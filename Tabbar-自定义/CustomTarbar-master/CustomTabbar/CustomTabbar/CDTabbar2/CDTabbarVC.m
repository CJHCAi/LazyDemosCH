//
//  CDTabbarVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/8/31.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDTabbarVC.h"
#import "CDTabBar.h"
#import "CDNavigationVC.h"

#import "CDOneVC.h"
#import "CDTwoVC.h"
#import "CDThreeVC.h"
#import "CDFourVC.h"
#import "CDTabBar.h"
#import "CDMiddleVC.h"


@interface CDTabbarVC ()

@end

@implementation CDTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self InitView];
    [self InitMiddleView];
}

- (void)InitView{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"列表", @"动画", @"消息", @"我的"];
    NSArray *images = @[@"tabbar_home", @"tabbar_reward", @"tabbar_message_center", @"tabbar_profile"];
    NSArray *selectedImages = @[@"tabbar_home_selected", @"tabbar_reward_selected", @"tabbar_message_center_selected", @"tabbar_profile_selected"];
    CDOneVC * oneVc = [[CDOneVC alloc] init];
    CDTwoVC * twoVc = [[CDTwoVC alloc] init];
    CDThreeVC * threeVc = [[CDThreeVC alloc] init];
    CDFourVC * fourVc = [[CDFourVC alloc] init];
    NSArray *viewControllers = @[oneVc, twoVc, threeVc, fourVc];
    for (int i = 0; i < viewControllers.count; i++)
    {
        UIViewController *childVc = viewControllers[i];
        [self setVC:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }

}

- (void)InitMiddleView{
    CDTabBar *tabBar = [[CDTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
        [tabBar setDidMiddBtn:^{
            //中间按钮点击
            CDMiddleVC *vc = [[CDMiddleVC alloc] init];
            CDNavigationVC *nav = [[CDNavigationVC alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];

        }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@" --- %@", item.title);
   
}


- (void)setVC:(UIViewController *)VC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    VC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [VC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    VC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CDNavigationVC *nav = [[CDNavigationVC alloc] initWithRootViewController:VC];
    [self addChildViewController:nav];
}

@end
