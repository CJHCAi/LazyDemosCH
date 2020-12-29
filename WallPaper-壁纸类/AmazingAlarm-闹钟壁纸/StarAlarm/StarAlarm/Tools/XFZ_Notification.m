//
//  XFZ_Notification.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/7.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "XFZ_Notification.h"
#import "WQPlaySound.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface XFZ_Notification ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XFZ_Notification

+ (void)registerLocalNotification:(NSInteger)alertTime{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置触发时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
//    NSLog(@"fireDate=%@",fireDate);
    notification.fireDate = fireDate;
    //时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //通知时播放的音乐
   // notification.soundName = UILocalNotificationDefaultSoundName;
    //通知时的参数
        NSString *Time = [NSString stringWithFormat:@"❤️时间到了❤️"];
        notification.alertBody = Time;
        NSString *Type = [NSString stringWithFormat:@"亲😊～闹钟响了"];
        notification.alertAction = NSLocalizedString(Type, nil);
        [notification setSoundName:@"Alien Metron.mp3"];

    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSCalendarUnitDay;
        notification.repeatInterval = NSCalendarUnitSecond;//每周都响

    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitSecond;
    }

    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


- (void)setUpTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)timerAction {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSLog(@"aa");
}

//- (void)setShouldGroupAccessibilityChildren:(BOOL)shouldGroupAccessibilityChildren {
//    NSData *locadate = [NSData date];
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateFormat:@"eeee HH:mm"];
//    NSString *localTimeStr2 = [formatter1 stringFromDate:locadate];
//    NSLog(@"localTimeStr2 = %@",localTimeStr2);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
