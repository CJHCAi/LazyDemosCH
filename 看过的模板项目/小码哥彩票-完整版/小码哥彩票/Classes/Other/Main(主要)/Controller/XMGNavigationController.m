//
//  XMGNavigationController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGNavigationController.h"

#import <objc/runtime.h>

@interface XMGNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation XMGNavigationController

// 加载类的时候调用
// 当程序一启动的时候就会调用
+ (void)load
{
//    NSLog(@"%s",__func__);
}


// 当前类或者他的子类第一次使用的时候才会调用
+ (void)initialize
{
    
//    NSLog(@"%s",__func__);
    // 设置导航条的内容
    // 获取当前应用下所有的导航条     [UINavigationBar appearance]

    // 获取哪个类下面的导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    // 通过setTintColor设置导航条文字的颜色
    [bar setTintColor:[UIColor whiteColor]];
    
    
    // 设置导航条标题颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:titleAttr];
    
    
    // 可以跳转返回按钮文字的偏移量
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    
  
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    // 防止手势冲突
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 取出系统手势的target对象，
    
    //  取出某个对象里面属性 1.KVC 前提条件：必须知道属性名 2.运行时
    
    // 遍历某个类里面所有属性 Ivar:表示成员属性
    // copyIvarList只能获取哪个类下面的属性，并不会越界（不会把它的父类的属性给遍历出来）
    // Class 获取哪个类的成员属性
    // count:告诉你当前类里面成员属性的总数
//    unsigned int count = 0;
//    // 返回成员属性的数组
//    Ivar *ivars = class_copyIvarList([UIGestureRecognizer class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        // 取出成员变量
//        Ivar ivar = ivars[i];
//        
//        // 获取属性名
//        NSString *ivarName = @(ivar_getName(ivar));
//        
//        NSLog(@"%@",ivarName);
//        
//        
//    }
    
    // _targets:属性名 value
    NSArray *targets = [self.interactivePopGestureRecognizer valueForKeyPath:@"_targets"];
    
    id objc = [targets firstObject];
    
    id target = [objc valueForKeyPath:@"_target"];
    
    
    
//    NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
    // 系统也有滑动手势，系统也是使用Target实现了滑动功能（action），
//    self.interactivePopGestureRecognizer 滑动的手势
    

    
  
    
    
}

#pragma mark - 手势代理方法
// 是否开始触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 判断下当前控制器是否是跟控制器
    
    return (self.topViewController != [self.viewControllers firstObject]);
}

/*
 <UIScreenEdgePanGestureRecognizer: 0x7f9c22148dd0; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f9c2213db80>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f9c22148850>)>>
 
 系统滑动手势类型：UIScreenEdgePanGestureRecognizer
 target：_UINavigationInteractiveTransition
 action：handleNavigationTransition:
 */

// self -> 导航控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{


    if (self.viewControllers.count != 0) { // 非跟控制器hi
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航条左边按钮的内容,把系统的返回按钮给覆盖,导航控制器的滑动返回功能就木有啦
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    
    [self popViewControllerAnimated:YES];
}
@end
