//
//  JRGuideViewController.m
//  JR
//
//  Created by 张骏 on 17/8/25.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRGuideViewController.h"
#import "JRHomeViewController.h"
#import "JRRelationViewController.h"
#import "JRMeTableViewController.h"
#import "Lottie.h"

@interface JRGuideViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *page1;
@property (nonatomic, strong) LOTAnimationView *animation1;
@property (nonatomic, strong) UIImageView *page2;
@property (nonatomic, strong) LOTAnimationView *animation2;
@property (nonatomic, strong) UIImageView *page3;
@property (nonatomic, strong) LOTAnimationView *animation3;
@property (nonatomic, strong) UIView *launchMask;
@property (nonatomic, strong) LOTAnimationView *launchAnimation;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation JRGuideViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setSubViews];
    
    [self setupLaunchMask];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_launchMask && _launchAnimation) {
        WeakObj(self);
        [_launchAnimation playWithCompletion:^(BOOL animationFinished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                selfWeak.launchMask.alpha = 0;
            } completion:^(BOOL finished) {
                [selfWeak.launchAnimation removeFromSuperview];
                selfWeak.launchAnimation = nil;
                [selfWeak.launchMask removeFromSuperview];
                selfWeak.launchMask = nil;
            }];
        }];
    }
    
    [_animation1 play];
    [_animation2 play];
    [_animation3 play];
}


#pragma mark - private
- (void)setSubViews{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(JRScreenWidth * 3, JRScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];

    _page1 = [UIImageView imageViewWithFrame:self.view.bounds image:[UIImage imageNamed:@"page1"]];

    [_scrollView addSubview:_page1];
    
    _animation1 = [LOTAnimationView animationNamed:@"GuidePage1"];
    _animation1.cacheEnable = NO;
    _animation1.frame = CGRectMake(JRPadding, JRScreenHeight - 200 - 4 * JRPadding, 200, 300);
    _animation1.contentMode = UIViewContentModeScaleToFill;
    _animation1.animationSpeed = 1.0;
    _animation1.loopAnimation = YES;
    [_scrollView addSubview:_animation1];
    

    _page2 = [UIImageView imageViewWithFrame:CGRectMake(JRScreenWidth, 0, JRScreenWidth, JRScreenHeight) image:[UIImage imageNamed:@"page2"]];
    
    [_scrollView addSubview:_page2];
    
    _animation2 = [LOTAnimationView animationNamed:@"GuidePage2"];
    _animation2.cacheEnable = NO;
    _animation2.frame = CGRectMake(JRPadding + JRScreenWidth, JRScreenHeight - 200 - 4 * JRPadding, 200, 300);
    _animation2.contentMode = UIViewContentModeScaleToFill;
    _animation2.animationSpeed = 1.0;
    _animation2.loopAnimation = YES;
    
    [_scrollView addSubview:_animation2];
    
    
    _page3 = [UIImageView imageViewWithFrame:CGRectMake(JRScreenWidth * 2, 0, JRScreenWidth, JRScreenHeight) image:[UIImage imageNamed:@"page3"]];
    
    [_scrollView addSubview:_page3];
    
    _animation3 = [LOTAnimationView animationNamed:@"GuidePage3"];
    _animation3.cacheEnable = NO;
    _animation3.frame = CGRectMake(JRPadding  + JRScreenWidth * 2, JRScreenHeight - 200 - 4 * JRPadding, 200, 300);
    _animation3.contentMode = UIViewContentModeScaleToFill;
    _animation3.animationSpeed = 1.0;
    _animation3.loopAnimation = YES;
    
    [_scrollView addSubview:_animation3];
    
    CGFloat btnWidth = JRWidth(132.5);
    CGFloat btnHeight = JRHeight(35.5);
    _startBtn = [UIButton buttonWithFrame:CGRectMake((JRScreenWidth - btnWidth) / 2 + 2 * JRScreenWidth, JRScreenHeight - btnHeight - 2 * JRPadding, btnWidth, btnHeight) title:nil color:nil font:nil backgroundImage:[UIImage imageNamed:@"startImg"] target:self action:@selector(loadRootViewController)];
    
    [_scrollView addSubview:_startBtn];
}


- (void)setupLaunchMask{
    _launchMask = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_launchMask];
    
    _launchAnimation = [LOTAnimationView animationNamed:@"data"];
    _launchAnimation.cacheEnable = NO;
    _launchAnimation.frame = self.view.bounds;
    _launchAnimation.contentMode = UIViewContentModeScaleToFill;
    _launchAnimation.animationSpeed = 1.2;
    
    [_launchMask addSubview:_launchAnimation];
}


- (void)loadRootViewController{
    
    //初始化
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    tabBarVC.tabBar.tintColor = JRCommonTextColor;
    
    JRHomeViewController *homeVC = [[JRHomeViewController alloc] init];
    homeVC.showLaunchAnimation = NO;
    JRNavigationController *homeNaviVC = [[JRNavigationController alloc] initWithRootViewController:homeVC];
    homeNaviVC.tabBarItem.title = @"首页";
    homeNaviVC.tabBarItem.image = [UIImage renderingModeOriginalImageNamed:@"home"];
    homeNaviVC.tabBarItem.selectedImage = [UIImage renderingModeOriginalImageNamed:@"homeSel"];
    
    JRRelationViewController *relationVC = [[JRRelationViewController alloc] init];
    JRNavigationController *relationNaviVC = [[JRNavigationController alloc] initWithRootViewController:relationVC];
    relationNaviVC.tabBarItem.title = @"关系";
    relationNaviVC.tabBarItem.image = [UIImage renderingModeOriginalImageNamed:@"relation"];
    relationNaviVC.tabBarItem.selectedImage = [UIImage renderingModeOriginalImageNamed:@"relationSel"];
    
    JRMeTableViewController *meVC = [[JRMeTableViewController alloc] init];
    JRNavigationController *meNaviVC = [[JRNavigationController alloc] initWithRootViewController:meVC];
    meNaviVC.tabBarItem.title = @"我";
    meNaviVC.tabBarItem.image = [UIImage renderingModeOriginalImageNamed:@"me"];
    meNaviVC.tabBarItem.selectedImage = [UIImage renderingModeOriginalImageNamed:@"meSel"];
    
    tabBarVC.viewControllers = @[homeNaviVC, relationNaviVC, meNaviVC];
    
    JRKeyWindow.rootViewController = tabBarVC;
}

@end
