//
//  HJTabbarViewController.m
//  多语言切换demo
//
//  Created by 黄坚 on 2018/3/19.
//  Copyright © 2018年 黄坚. All rights reserved.
//

#import "HJTabbarViewController.h"
#import "DeviceViewController.h"
#import "MineViewController.h"
@interface HJTabbarViewController ()

@end

@implementation HJTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DeviceViewController *device=[[DeviceViewController alloc]init];
    [self setOneChildController:device title:languageStr(@"bartitle_device") nomarlImage:@"设备" selectedImage:@"设备-bright"];
    
    MineViewController *mine=[[MineViewController alloc]init];
    [self setOneChildController:mine title:languageStr(@"bartitle_mine") nomarlImage:@"我" selectedImage:@"我-bright"];
    
}
- (void)setOneChildController:(UIViewController *)vc title:(NSString *)title nomarlImage:(NSString *)nomarlImage selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title=title;
    vc.tabBarItem.image=[[UIImage imageNamed:nomarlImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:99/255.0 green:187/255.0 blue:247/255.0 alpha:1]} forState:UIControlStateSelected];
    
    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:navi];
}
@end
