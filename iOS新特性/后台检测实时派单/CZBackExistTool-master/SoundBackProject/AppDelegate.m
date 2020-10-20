//
//  AppDelegate.m
//  SoundBackProject
//
//  Created by Keyu Zhou on 2017/8/25.
//  Copyright © 2017年 ZCZ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, assign) NSInteger     numFlag;        // Demo自加参数
@property (nonatomic, strong) NSTimer   *   myTimer;        // 循环请求计数，后台开启，前台关闭。
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //如果已经获得发送通知哦的授权则创建本地通知，否则请求授权（注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置）
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self addLocationForAlert];
    }else{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound   categories:nil]];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
    _numFlag = 0;
    
    self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^( void) {
        [self endBackgroundTask];
        
    }];
    
    self.myTimer =[NSTimer scheduledTimerWithTimeInterval:3.0f
                   
                                                   target:self
                   
                                                 selector:@selector(timerMethod:)     userInfo:nil
                   
                                                  repeats:YES];
    
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
 
    [self.myTimer invalidate];
    
    self.myTimer = nil;
    
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application { }

#pragma  启动定时器 检测系统派单

- (void) endBackgroundTask{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    AppDelegate *weakSelf = self;
    
    dispatch_async(mainQueue, ^(void) {
        
        AppDelegate *strongSelf = weakSelf;
        
        if (strongSelf != nil){
            
            [strongSelf.myTimer invalidate];// 停止定时器
            
            
            /*
             每个对 beginBackgroundTaskWithExpirationHandler:方法的调用
             必须要相应的调用 endBackgroundTask:方法。这样，来告诉应用程序你已经执行完成了。
             也就是说,我们向 iOS 要更多时间来完成一个任务,那么我们必须告诉 iOS 你什么时候能完成那个任务。
             也就是要告诉应用程序：“好借好还”。
             标记指定的后台任务完成
            */
            
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            
            // 销毁后台任务标识符
            
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            
        }
        
    });
    
}
- (void) timerMethod:(NSTimer *)paramSender{
    
    
    _numFlag  ++;
    
    
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    
    if (backgroundTimeRemaining == DBL_MAX){
     
        if (_numFlag % 5 == 0) {
            
            [self addLocationForAlert];
            
        }
        
    } else {
        
        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
        
    }
    
}
- (void) addLocationForAlert{
    
  
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];//通知触发时间，10s之后
    notification.repeatInterval = 0; //通知重复次数
    
    //设置通知属性
    notification.alertBody = @"您的附近有新订单";//通知主体
    notification.applicationIconBadgeNumber = 1;//应用程序右上角显示的未读消息数
    notification.alertAction = @"滑动打开";//待机界面的滑动动作提示
    notification.alertTitle = @"xxxxApp名称";
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片，这里使用程序启动图片
    notification.soundName= UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
     
}


@end
