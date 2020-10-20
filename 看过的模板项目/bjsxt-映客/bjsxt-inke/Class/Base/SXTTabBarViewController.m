//
//  SXTTabBarViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/1.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTTabBarViewController.h"
#import "SXTTabBar.h"
#import "SXTBaseNavViewController.h"
#import "SXTLaunchViewController.h"

@interface SXTTabBarViewController ()<SXTTabBarDelegate>

@property (nonatomic, strong) SXTTabBar * sxtTabbar;

@end

@implementation SXTTabBarViewController

- (SXTTabBar *)sxtTabbar {
    
    if (!_sxtTabbar) {
        _sxtTabbar = [[SXTTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _sxtTabbar.delegate = self;
    }
    return _sxtTabbar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载控制器
    [self configViewControllers];
    
    //加载tabbar
    [self.tabBar addSubview:self.sxtTabbar];
    
    //删除tabbar的阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}

- (void)configViewControllers {
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:@[@"SXTMainViewController",@"SXTMeViewController"]];
    
    for (NSInteger i = 0; i < array.count; i ++) {
        
        NSString * vcName = array[i];
        
        UIViewController * vc = [[NSClassFromString(vcName) alloc] init];
        
        SXTBaseNavViewController * nav = [[SXTBaseNavViewController alloc] initWithRootViewController:vc];
        
        [array replaceObjectAtIndex:i withObject:nav];
        
    }
    
    self.viewControllers = array;
    
}

#pragma mark-SXTTabBarDelegate
- (void)tabbar:(SXTTabBar *)tabbar clickButton:(SXTItemType)idx {
    
    if (idx != SXTItemTypeLaunch) {
        self.selectedIndex = idx - SXTItemTypeLive;
        return;
    }
    
    SXTLaunchViewController * launchVC = [[SXTLaunchViewController alloc] init];
    
    [self presentViewController:launchVC animated:YES completion:nil];
    
}

@end
