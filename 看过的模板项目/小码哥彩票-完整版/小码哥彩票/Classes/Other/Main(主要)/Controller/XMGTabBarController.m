//
//  XMGTabBarController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTabBarController.h"

#import "XMGNavigationController.h"

#import "XMGHallViewController.h"
#import "XMGArenaViewController.h"
#import "XMGDiscoverViewController.h"
#import "XMGHistoryViewController.h"
#import "XMGMyLotteryViewController.h"

#import "XMGTabBar.h"

#import "XMGArenaNavController.h"

@interface XMGTabBarController ()<XMGTabBarDelegate>

// 保存所有控制器对应按钮的内容（UITabBarItem）
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation XMGTabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // 添加子控制器
    [self setUpAllChildViewController];
    // 自定义tabBar
    [self setUpTabBar];

}

#pragma mark - 自定义tabBar
- (void)setUpTabBar
{
   
    XMGTabBar *tabBar = [[XMGTabBar alloc] init];
    
    // 存储UITabBarItem
    tabBar.items = self.items;
    
    tabBar.delegate = self;
    
    tabBar.backgroundColor = [UIColor orangeColor];
    
    tabBar.frame = self.tabBar.bounds;
    
    [self.tabBar addSubview:tabBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 把系统的tabBar上的按钮干掉
    for (UIView *childView in self.tabBar.subviews) {
        if (![childView isKindOfClass:[XMGTabBar class]]) {
            [childView removeFromSuperview];
        }
    }
}

#pragma mark - XMGTabBarDelegate方法
// 监听tabBar上按钮的点击
- (void)tabBar:(XMGTabBar *)tabBar didClickBtn:(NSInteger)index
{
    self.selectedIndex = index;
}

#pragma mark - 添加所有子控制器
// tabBar上面按钮的图片尺寸是由规定，不能超过44
- (void)setUpAllChildViewController
{
    // 购彩大厅
    XMGHallViewController *hall = [[XMGHallViewController alloc] init];
    
    [self setUpOneChildViewController:hall image:[UIImage imageNamed:@"TabBar_LotteryHall_new"] selImage:[UIImage imageNamed:@"TabBar_LotteryHall_selected_new"] title:@"购彩大厅"];
 
    
    // 竞技场
    XMGArenaViewController *arena = [[XMGArenaViewController alloc] init];
    
    [self setUpOneChildViewController:arena image:[UIImage imageNamed:@"TabBar_Arena_new"] selImage:[UIImage imageNamed:@"TabBar_Arena_selected_new"] title:nil];
    
    arena.view.backgroundColor = [UIColor purpleColor];
    

    // 发现
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XMGDiscoverViewController" bundle:nil];
    XMGDiscoverViewController *discover = [storyboard instantiateInitialViewController];
    [self setUpOneChildViewController:discover image:[UIImage imageNamed:@"TabBar_Discovery_new"] selImage:[UIImage imageNamed:@"TabBar_Discovery_selected_new"] title:@"发现"];
    
    // 开奖信息
    XMGHistoryViewController *history = [[XMGHistoryViewController alloc] init];
    [self setUpOneChildViewController:history image:[UIImage imageNamed:@"TabBar_History_new"] selImage:[UIImage imageNamed:@"TabBar_History_selected_new"] title:@"开奖信息"];
    
    // 我的彩票
    XMGMyLotteryViewController *myLottery = [[XMGMyLotteryViewController alloc] init];
    [self setUpOneChildViewController:myLottery image:[UIImage imageNamed:@"TabBar_MyLottery_new"] selImage:[UIImage imageNamed:@"TabBar_MyLottery_selected_new"] title:@"我的彩票"];
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title
{
    
    vc.navigationItem.title = title;
    
    // 描述对应按钮的内容
    vc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 记录所有控制器对应按钮的内容
    [self.items addObject:vc.tabBarItem];
    
    // 把控制器包装成导航控制器
    UINavigationController *nav = [[XMGNavigationController alloc] initWithRootViewController:vc];
    
    if ([vc isKindOfClass:[XMGArenaViewController class]]) {
        nav = [[XMGArenaNavController alloc] initWithRootViewController:vc];

    }
    
    // 如果要设置背景图片，必须填UIBarMetricsDefault,默认导航控制器的子控制器的view尺寸会变化。
    // 设置导航条背景图片，一定要在导航条显示之前设置
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    [self addChildViewController:nav];
}

- (UIColor *)randomColor
{
    
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}


@end
