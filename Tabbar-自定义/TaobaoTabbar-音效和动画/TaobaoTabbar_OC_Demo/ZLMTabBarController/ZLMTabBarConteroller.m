//
//  ZLMTabBarConteroller.m
//  TaobaoTabbar_OC_Demo
//
//  Created by 赵黎明 on 2017/3/13.
//  Copyright © 2017年 赵黎明. All rights reserved.
//

#import "ZLMTabBarConteroller.h"

#import "ZLMHomeViewController.h"//首页
#import "ZLMCategoryController.h"//分类
#import "ZLMSaleViewController.h"//促销
#import "ZLMShoppingCartsViewController.h"//购物车
#import "ZLMMineViewController.h"//我的

#import "AppDelegate.h"

#import <AudioToolbox/AudioToolbox.h>
@interface ZLMTabBarConteroller ()

@end

@implementation ZLMTabBarConteroller

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**
         *  设置 TabBar
         */
        ZLMHomeViewController *home                 = [[ZLMHomeViewController alloc] init];
        UINavigationController *homeNav            = [[UINavigationController alloc] initWithRootViewController:home];
        homeNav.tabBarItem.title                   = @"首页";
        homeNav.tabBarItem.selectedImage           = [UIImage imageNamed:@"tab1_p"];
        homeNav.tabBarItem.image                   = [UIImage imageNamed:@"tab1"];
        
        ZLMCategoryController *catagory     = [[ZLMCategoryController alloc] init];
        UINavigationController *catagoryNav        = [[UINavigationController alloc] initWithRootViewController:catagory];
        catagoryNav.tabBarItem.title               = @"分类";
        catagoryNav.tabBarItem.selectedImage       = [UIImage imageNamed:@"tab2_p"];
        catagoryNav.tabBarItem.image               = [UIImage imageNamed:@"tab2"];
        
        ZLMSaleViewController *promotion           = [[ZLMSaleViewController alloc] init];
        UINavigationController *promotionNav       = [[UINavigationController alloc] initWithRootViewController:promotion];
        promotionNav.tabBarItem.title              = @"促销";
        promotionNav.tabBarItem.selectedImage      = [UIImage imageNamed:@"tab3_p"];
        promotionNav.tabBarItem.image              = [UIImage imageNamed:@"tab3"];
        
        ZLMShoppingCartsViewController *shoppingCart = [[ZLMShoppingCartsViewController alloc] init];
        UINavigationController *shoppingCartNav    = [[UINavigationController alloc] initWithRootViewController:shoppingCart];
        shoppingCartNav.tabBarItem.title           = @"购物车";
        shoppingCartNav.tabBarItem.selectedImage   = [UIImage imageNamed:@"tab4_p"];
        shoppingCartNav.tabBarItem.image           = [UIImage imageNamed:@"tab4"];
        
        ZLMMineViewController *account             = [[ZLMMineViewController alloc] init];
        UINavigationController *accountNav         = [[UINavigationController alloc] initWithRootViewController:account];
        accountNav.tabBarItem.title                = @"我的";
        accountNav.tabBarItem.selectedImage        = [UIImage imageNamed:@"tab5_p"];
        accountNav.tabBarItem.image                = [UIImage imageNamed:@"tab5"];
        
        self.viewControllers  = @[homeNav, catagoryNav, promotionNav, shoppingCartNav, accountNav];
        self.tabBar.tintColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil) {
        self.view = nil;
    }
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];//动画
    [self playSound];//音效
    if([item.title isEqualToString:@"首页"]){
        NSLog(@"点击了首页");
    }
}



-(void) playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"caf"];
    SystemSoundID soundID;
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] 
     addAnimation:pulse forKey:nil]; 
}

@end
