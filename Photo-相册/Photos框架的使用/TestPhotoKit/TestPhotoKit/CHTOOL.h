//
//  CHTOOL.h
//  TestPhotoKit
//
//  Created by 七啸网络 on 2017/8/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
@interface CHTOOL : NSObject
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
