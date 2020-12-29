//
//  TabBarController.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 拿到 TabBar 在拿到想应的item
    
    NSArray *array = @[@"Message", @"search", @"video", @"Mall", @"User"];
    for (int i = 0; i < 5; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        [item setImage:[[UIImage imageNamed:array[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bar"]];
    [self.tabBar setBarTintColor:[UIColor colorWithRed:0.945 green:0.263 blue:0.255 alpha:1.000]];
    [self.tabBar setTintColor:[UIColor colorWithRed:0.686 green:0.006 blue:0.000 alpha:1.000]];
    
    //  item文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.selectedIndex = 2;
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
