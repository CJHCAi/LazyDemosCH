//
//  CDTabbarVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/8/31.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDTabbarVC.h"
#import "CDNavigationVC.h"
#import "CDOneVC.h"
#import "CDTwoVC.h"
#import "CDThreeVC.h"
#import "CDFourVC.h"
#import "CDTabBar.h"
#import "CDMiddleVC.h"

@interface CDTabbarVC ()
@property (nonatomic, strong) CDOneVC *oneVC;
@property (nonatomic, strong) CDTwoVC *twoVC;
@property (nonatomic, strong) CDThreeVC *threeVC;
@property (nonatomic, strong) CDFourVC *fourVC;

@end

@implementation CDTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitView];
    [self InitMiddleView];
}

- (void)InitMiddleView
{
    CDTabBar *tabBar = [[CDTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
        [tabBar setDidMiddBtn:^{
        CDMiddleVC *vc = [[CDMiddleVC alloc] init];
        CDNavigationVC *nav = [[CDNavigationVC alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //NSLog(@" --- %@", item.title);
   
}

- (void)InitView
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"列表", @"动画", @"消息", @"我的"];
    NSArray *images = @[@"tabbar_home@3x", @"tabbar_reward@3x", @"tabbar_message_center@3x", @"tabbar_profile@3x"];
    NSArray *selectedImages = @[@"tabbar_home_selected@3x", @"tabbar_reward_selected@3x", @"tabbar_message_center_selected@3x", @"tabbar_profile_selected@3x"];
    CDOneVC * oneVc = [[CDOneVC alloc] init];
    self.oneVC = oneVc;
    CDTwoVC * twoVc = [[CDTwoVC alloc] init];
    self.twoVC = twoVc;
    CDThreeVC * threeVc = [[CDThreeVC alloc] init];
    self.threeVC = threeVc;
    CDFourVC * fourVc = [[CDFourVC alloc] init];
    self.fourVC = fourVc;
    NSArray *viewControllers = @[oneVc, twoVc, threeVc, fourVc];
    for (int i = 0; i < viewControllers.count; i++)
    {
        UIViewController *childVc = viewControllers[i];
        [self setVC:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)setVC:(UIViewController *)VC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
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
