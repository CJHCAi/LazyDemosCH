//
//  UIDevice+ASMandatoryLandscapeDevice.h
//  iOS在某个页面强制横屏
//
//  Created by Mac on 2020/5/11.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ASMandatoryLandscapeDevice)

/// 输入要强制转屏的方向
/// @param interfaceOrientation 转屏的方向
+ (void)deviceMandatoryLandscapeWithNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

NS_ASSUME_NONNULL_END
