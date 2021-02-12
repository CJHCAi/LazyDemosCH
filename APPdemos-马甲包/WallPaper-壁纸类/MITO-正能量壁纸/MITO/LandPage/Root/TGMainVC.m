//
//  TGMainVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/3/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//  Blog http://blog.csdn.net/callzjy
//  Mail targetcloud@163.com
//  Github https://github.com/targetcloud

#import "TGMainVC.h"
#import "TGEssenceVC.h"
#import "TGEssenceNewVC.h"
#import "TGNewestVC.h"
#import "TGFriendTrendVC.h"
#import "TGMeVC.h"
#import "TGNewVC.h"
#import "TGPublishVC.h"
#import "TGTabBar.h"
#import "TGNavigationVC.h"

@interface TGMainVC ()//MARK:1 UITabBarDelegate <UITabBarDelegate> 不用写，TabBarVC已经是TabBar的代理了

@end

@implementation TGMainVC

+ (void)load{
    
    UITabBarItem *item =[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *attrsSelected = [NSMutableDictionary dictionary];
    attrsSelected[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrsSelected forState:UIControlStateSelected];
    
    NSMutableDictionary *attrsNormal = [NSMutableDictionary dictionary];
    attrsNormal[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [item setTitleTextAttributes:attrsNormal forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupAllChildVC];
    [self setupAllTitleButton];
    [self setupTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:BackEssenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(across) name:AcrossEssenceNotification object:nil];
}

-(void) setupTabBar {
    TGTabBar * tabbar = [[TGTabBar alloc] init];

    [self setValue:tabbar forKeyPath:@"tabBar"];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    
}

- (void) back {
    TGNavigationVC *essenceVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGEssenceNewVC alloc] init]];
    TGNavigationVC *newVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGNewestVC alloc] init]];
    self.viewControllers = @[essenceVc,newVc,self.childViewControllers[2],self.childViewControllers[3]];
    [self setupAllTitleButton];
}

- (void) across{
    TGNavigationVC * acrossVc =[[TGNavigationVC alloc] initWithRootViewController:[[TGEssenceVC alloc] init]];
    TGNavigationVC *newVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGNewVC alloc] init]];
    self.viewControllers = @[acrossVc,newVc,self.childViewControllers[2],self.childViewControllers[3]];
    [self setupAllTitleButton];
}

- (void)setupAllChildVC{
    //壁纸
    TGNavigationVC *essenceVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGEssenceNewVC alloc] init]];
    //发现
    TGNavigationVC *newVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGNewestVC alloc] init]];
    //图卡
    TGNavigationVC *ftVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGFriendTrendVC alloc] init]];
    //设置
    TGNavigationVC *meVc = [[TGNavigationVC alloc] initWithRootViewController:[[TGMeVC alloc] init]];

    
    self.viewControllers = @[essenceVc,newVc,ftVc,meVc];
    
}

- (void)setupAllTitleButton{
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"壁纸";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"发现";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon"];
    
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"图卡";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"设置";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];
}

- (void) dealloc{
    TGFunc
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackEssenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AcrossEssenceNotification object:nil];
}

@end
