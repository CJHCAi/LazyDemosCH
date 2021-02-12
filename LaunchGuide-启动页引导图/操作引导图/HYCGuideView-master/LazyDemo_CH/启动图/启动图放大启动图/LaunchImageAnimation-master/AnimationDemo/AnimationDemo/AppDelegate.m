//
//  AppDelegate.m
//  AnimationDemo
//
//  Created by DayHR on 2017/5/25.
//  Copyright © 2017年 xiangzuhua. All rights reserved.
//

#import "AppDelegate.h"
#import<libkern/OSAtomic.h>
#define timeIntence 5.0//图片放大的时间
@interface AppDelegate ()
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UIButton * skipButton;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //使主窗口显示到屏幕的最前端
    [self.window makeKeyAndVisible];
    //获取中心点的xy坐标
    float y = [UIScreen mainScreen].bounds.size.height/2;
    float x = [UIScreen mainScreen].bounds.size.width/2;
    //创建展示动画的imageView
    self.imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.center = CGPointMake(x, y);
    self.imageView.userInteractionEnabled = YES;
    self.imageView.image = [UIImage imageNamed:@"启动图.jpg"];
    [self.window addSubview:self.imageView];
    [self.window bringSubviewToFront:self.imageView];
    //添加一个跳过按钮
    self.skipButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.skipButton.frame = CGRectMake(2*x - 80, 40, 70, 25);
    self.skipButton.layer.cornerRadius = 12.5;
    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.skipButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.skipButton.backgroundColor = [UIColor grayColor];
    [self.skipButton addTarget:self action:@selector(skipAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.window addSubview:self.skipButton];
    //跳过按钮的倒计时
    __block int32_t timeOutCount=timeIntence;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        OSAtomicDecrement32(&timeOutCount);
        if (timeOutCount == 0) {
            NSLog(@"timersource cancel");
            dispatch_source_cancel(timer);
        }
        [self.skipButton setTitle:[NSString stringWithFormat:@"%d 跳过",timeOutCount+1] forState:(UIControlStateNormal)];
    });
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"timersource cancel handle block");
    });
    dispatch_resume(timer);
    
    //图片放大动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeIntence];
    self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5f, 1.5f);
    [UIView commitAnimations];
    //图片消失动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeIntence * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            self.imageView.alpha = 0;
            self.skipButton.alpha = 0;
        }];
    });
    //所有动画完成，删除图片和按钮
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeIntence + 2.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView removeFromSuperview];
        [self.skipButton removeFromSuperview];
    });
    return YES;
}
//点击跳过按钮，删除图片和按钮
-(void)skipAction:(UIButton*)sender{
    [self.imageView removeFromSuperview];
    [self.skipButton removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
