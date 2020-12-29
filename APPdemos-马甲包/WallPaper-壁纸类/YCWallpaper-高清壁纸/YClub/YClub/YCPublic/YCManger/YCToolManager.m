//
//  YCToolManager.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/9.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCToolManager.h"

@interface YCToolManager ()<UIAlertViewDelegate>

@end
@implementation YCToolManager
//检查更新
+ (BOOL)bUpdate
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kYCLastVersionKey];
    if (!lastVersion) {
        return NO;
    }
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([lastVersion isEqualToString:currentVersion]) {
        return NO;
    }
    return YES;
}
+ (NSString *)currentVerson
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}
+ (void)gotoJudge
{
    NSString *version = [YCToolManager currentVerson];
    NSString *commentVer = [[NSUserDefaults standardUserDefaults] objectForKey:kYCVersionCommentKey];
    if ([commentVer isEqualToString:version]) {
        return;
    }
    NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:kYCReadFoodCount] integerValue];
    if (number < 15) {
        number++;
        [[NSUserDefaults standardUserDefaults] setObject:@(number) forKey:kYCReadFoodCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    NSString *message = [NSString stringWithFormat:@"亲，%@一直努力要做简洁无广告版应用，如果您使用的还算满意，请支持下我们^_^",kAppName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    NSURL *commentUrl = [NSURL URLWithString:kAppUrl];
    [[UIApplication sharedApplication] openURL:commentUrl];
    NSString *version = [YCToolManager currentVerson];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kYCVersionCommentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isOnCheck
{
    NSDate *currentDate = [NSDate date];
    // 日期字符串
    NSString *endDateStr = @"2017-06-28 18:00:00";
    // 转化成NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormatter dateFromString:endDateStr];
    // 判断
    if ([currentDate compare:endDate] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

@end
