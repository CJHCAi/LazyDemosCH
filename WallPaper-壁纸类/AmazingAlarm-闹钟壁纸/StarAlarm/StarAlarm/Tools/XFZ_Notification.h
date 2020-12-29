//
//  XFZ_Notification.h
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/7.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFZ_Notification : NSObject

//设置本地通知

+ (void)registerLocalNotification:(NSInteger)alertTime;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;


@end
