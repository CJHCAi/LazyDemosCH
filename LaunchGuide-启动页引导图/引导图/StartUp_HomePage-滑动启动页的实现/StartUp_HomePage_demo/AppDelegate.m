//
//  AppDelegate.m
//  StartUp_HomePage_demo
//
//  Created by Derek on 2017/4/29.
//  Copyright © 2017年 www.ioslover.club. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()<UIScrollViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIScrollView *StartUp_ScrollView=[[UIScrollView alloc]initWithFrame:self.window.frame] ;
    
    for (int i=0; i<3; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*450, 0, 450, 450)];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"pic_%d.png",i+1]];
        
        [StartUp_ScrollView addSubview:imageView];
        
    }
    
    StartUp_ScrollView.delegate=self;
    StartUp_ScrollView.backgroundColor=[UIColor redColor];
    StartUp_ScrollView.contentSize=CGSizeMake(3*450,400 );
    StartUp_ScrollView.pagingEnabled=YES;
    
 
    
    [self.window addSubview:StartUp_ScrollView];
    
    ;
    
    return YES;
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
