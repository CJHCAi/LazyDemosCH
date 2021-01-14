//
//  MainViewController.m
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MainViewController.h"
#import "Dock.h"
#import "BottomMenu.h"
#import "Tabbar.h"
#import "IconButton.h"
#import "MoodViewController.h"
#import "AllStatusViewController.h"

@interface MainViewController () <BottomMenuDelegate, TabbarDelegate>

/** Dock */
@property (nonatomic, weak) Dock *dock;

/* 内容的View */
@property (nonatomic, weak) UIView *contentView;

/** 当前控制器的下标 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:55.0/255 green:55.0/255 blue:55.0/255 alpha:1.0];
    
    // 2.初始化Dock
    [self setupDock];
    
    // 3.初始化控制器
    [self setupControllers];
    
    // 4.初始化内容的View
    [self setupContentView];
    
    // 5.默认选中的控制器
    [self iconButtonClick];
}

/**
 *  初始化内容的View
 */
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.width = kContentViewWidth;
    contentView.height = self.view.height - 20;
    contentView.x = self.dock.width;
    contentView.y = 20;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

/**
 *  初始化六个控制器
 */
- (void)setupControllers
{
    AllStatusViewController *vc1 = [[AllStatusViewController alloc] init];
    [self packNav:vc1];
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor blackColor];
    [self packNav:vc2];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor purpleColor];
    [self packNav:vc3];
    
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = [UIColor orangeColor];
    [self packNav:vc4];
    
    UIViewController *vc5 = [[UIViewController alloc] init];
    vc5.view.backgroundColor = [UIColor yellowColor];
    [self packNav:vc5];
    
    UIViewController *vc6 = [[UIViewController alloc] init];
    vc6.view.backgroundColor = [UIColor greenColor];
    [self packNav:vc6];
    
    UIViewController *vc7 = [[UIViewController alloc] init];
    vc7.title = @"个人中心";
    vc7.view.backgroundColor = [UIColor lightGrayColor];
    [self packNav:vc7];
}

/**
 *  抽出一个包装导航控制器的方法,并且将他加入到我们的ChildViewControllers里面
 */
- (void)packNav:(UIViewController *)vc
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)setupDock
{
    // 1.创建Dock
    Dock *dock = [[Dock alloc] init];
    dock.height = self.view.height;
    self.dock = dock;
    self.dock.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // 拿到屏幕方向,根据屏幕的方向来设置width
    BOOL isLandscape = self.view.width == kLandscapeWidth;
    
    [self.view addSubview:dock];
    
    // 2.告知Dock目前屏幕的方向
    [self.dock rotateToLandscape:isLandscape];
    
    // 3.设置BottomMenu的代理
    self.dock.bottomMenu.delegate = self;
    
    // 4.设置Tabbar的代理
    self.dock.tabbar.delegate = self;
    
    // 5.监听IconButton的点击
    [self.dock.iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
}


// 当屏幕发生旋转的时候会执行该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 1.拿到屏幕的方向
    BOOL isLandscape = size.width == 1024;
    
    // 2.获取动画旋转的时间
    CGFloat duration = [coordinator transitionDuration];
    [UIView animateWithDuration:duration animations:^{
        // 3.告知Dock屏幕的方向
        [self.dock rotateToLandscape:isLandscape];
        
        self.contentView.x = self.dock.width;
    }];
}

#pragma mark - 实现BottoMenu的代理方法
- (void)bottomMenu:(BottomMenu *)bottomMenu type:(BottomMenuItemType)type
{
    switch (type) {
        case kBottomMenuItemTypeMood:
        {
            MoodViewController *moodVc = [[MoodViewController alloc] init];
            UINavigationController *moodNav = [[UINavigationController alloc] initWithRootViewController:moodVc];
            
            // 设置呈现样式
            moodNav.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // 设置过度样式
            moodNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:moodNav animated:YES completion:nil];
        }
            break;
            
        case kBottomMenuItemTypePhoto:
            NSLog(@"点击了发表照片");
            break;
            
        case kBottomMenuItemTypeBlog:
            NSLog(@"点击了发表日志");
            break;
            
        default:
            break;
    }
}

#pragma mark - 实现tabbar的代理方法
- (void)tabbar:(Tabbar *)tabbar fromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    // 1.取出旧控制器的View,移除掉
    UIViewController *oldVc = self.childViewControllers[from];
    [oldVc.view removeFromSuperview];
    
    // 2.取出新的控制器的View,添加到self.view(控制器的View的autoresizing属性,默认情况是宽度和高度随着父控件拉伸而拉伸)
    UIViewController *newVc = self.childViewControllers[to];
    newVc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:newVc.view];
    
    // 3.记录当前下标
    self.currentIndex = to;
}

#pragma mark - 监听IconButton的点击
- (void)iconButtonClick
{
    [self tabbar:nil fromIndex:self.currentIndex toIndex:self.childViewControllers.count - 1];
    
    [self.dock.tabbar unSelected];
}

@end
