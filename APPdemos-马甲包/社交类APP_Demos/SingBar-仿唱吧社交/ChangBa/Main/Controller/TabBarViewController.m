//
//  TabBarViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/11.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "TabBarViewController.h"
#import "DiscoverTableViewController.h"
#import "HomeViewController.h"
#import "PerformViewController.h"
#import "ChatTableViewController.h"
#import "SingViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor redColor];
    
    
    
    HomeViewController *hVC = [[HomeViewController alloc]init];
    UINavigationController *hNavi = [[UINavigationController alloc]initWithRootViewController:hVC];
    hNavi.navigationBar.hidden = YES;
    hNavi.navigationBar.barStyle = UIBarStyleDefault;
    hNavi.tabBarItem.image = [UIImage imageNamed:@"my_changba_tab_normal"];
    hNavi.tabBarItem.title = @"我的唱吧";

    PerformViewController *pVC = [[PerformViewController alloc]init];
    UINavigationController *pNavi = [[UINavigationController alloc]initWithRootViewController:pVC];
    pNavi.navigationBar.tintColor = [UIColor redColor];
    pNavi.tabBarItem.image = [UIImage imageNamed:@"show_tab_normal"];
    pNavi.tabBarItem.title = @"精彩表演";
    
    SingViewController *sVC = [[SingViewController alloc]init];
    UINavigationController *sNavi = [[UINavigationController alloc]initWithRootViewController:sVC];
    sNavi.navigationBar.tintColor = [UIColor redColor];
    sNavi.tabBarItem.image = [UIImage imageNamed:@"ms_ktv_tab_song_normal"];
    sNavi.tabBarItem.title = @"唱歌";
    
    ChatTableViewController *cTVC = [[ChatTableViewController alloc]init];
    UINavigationController *cNavi = [[UINavigationController alloc]initWithRootViewController:cTVC];
    cNavi.navigationBar.tintColor = [UIColor redColor];
    cNavi.tabBarItem.image = [UIImage imageNamed:@"chat_tab_normal"];
    cNavi.tabBarItem.title = @"聊天";

    DiscoverTableViewController *dTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DiscoverTableViewController"];
    UINavigationController *dNavi = [[UINavigationController alloc]initWithRootViewController:dTVC];
    dNavi.tabBarItem.image = [UIImage imageNamed:@"discovery_tab_normal"];
    dNavi.tabBarItem.title = @"发现";
    
    self.viewControllers = @[hNavi ,pNavi ,sNavi ,cNavi ,dNavi];
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
