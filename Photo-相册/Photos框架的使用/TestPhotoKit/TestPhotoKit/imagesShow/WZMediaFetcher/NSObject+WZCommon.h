//
//  NSObject+WZCommon.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/19.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

/**
 *  作用于系统的权限 设置等
 */
@interface NSObject (WZCommon)


/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^)(BOOL ownAuthorization))handler;


/**
 进入app设置页面
 */
+ (void)openAppSettings;


/**
 颜色转图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
