//
//  CHTOOL.m
//  TestPhotoKit
//
//  Created by 七啸网络 on 2017/8/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CHTOOL.h"
@implementation CHTOOL
/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^)(BOOL ownAuthorization))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (handler) {
            BOOL boolean = false;
            if (status == PHAuthorizationStatusAuthorized) {
                boolean = true;
            }
            handler(boolean);
        }
    }];
}

/**
 进入app设置页面
 */
+ (void)openAppSettings {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"无法打开设置");
    }
}

/************************************************/
//颜色转图
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
