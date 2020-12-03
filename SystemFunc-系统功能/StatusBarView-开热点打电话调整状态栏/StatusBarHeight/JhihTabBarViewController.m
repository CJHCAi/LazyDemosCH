//
//  JhihTabBarViewController.m
//  StatusBarHeight
//
//  Created by kuanchih on 2014/7/16.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import "JhihTabBarViewController.h"
#import "FirstTabViewController.h"
#import "SecondTabViewController.h"

@interface JhihTabBarViewController ()

@property (strong, nonatomic) UITabBarController *tabBarController;
@property CGFloat statusBarHeight;

@end

@implementation JhihTabBarViewController

#define STATUS_BAR_BASE 20.0f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initial tabBarController
    _tabBarController = [[UITabBarController alloc] init];
    
    // add 2 temp view
    FirstTabViewController *first1 = [[FirstTabViewController alloc] init];
    first1.title = @"title1";
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:first1];
    SecondTabViewController *first2 = [[SecondTabViewController alloc] init];
    first2.title = @"title2";
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:first2];

    first1.view.backgroundColor = [UIColor brownColor];
    first2.view.backgroundColor = [UIColor blueColor];
    first1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
    first2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    
    _tabBarController.viewControllers = [[NSArray alloc] initWithObjects:nav1, nav2, nil];
    _tabBarController.selectedIndex = 0;
    
    [self.view addSubview:_tabBarController.view];
    
    // after view did load, will call viewDidLayoutSubviews once
    // so don't need to get the default statusBarHeight at beginning
}

- (void)viewDidLayoutSubviews {
    CGRect barFrame = [[UIApplication sharedApplication] statusBarFrame];
    if (_statusBarHeight != barFrame.size.height) {
        CGRect tabViewFrame = _tabBarController.view.frame;
        NSLog(@"barFrame y:%f height:%f", barFrame.origin.y, barFrame.size.height);
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        NSLog(@"applicationFrame y:%f height:%f", applicationFrame.origin.y, applicationFrame.size.height);
        NSLog(@"old tabViewFrame y:%f height:%f", tabViewFrame.origin.y, tabViewFrame.size.height);
        tabViewFrame.size = CGSizeMake(tabViewFrame.size.width, applicationFrame.size.height + STATUS_BAR_BASE);
        tabViewFrame.origin = CGPointMake(0, 0);
        NSLog(@"new tabViewFrame y:%f height:%f", tabViewFrame.origin.y, tabViewFrame.size.height);
        _tabBarController.view.frame = tabViewFrame;
        _statusBarHeight = barFrame.size.height;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
