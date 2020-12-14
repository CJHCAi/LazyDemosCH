//
//  UIDevice+ASMandatoryLandscapeDevice.m
//  iOS在某个页面强制横屏
//
//  Created by Mac on 2020/5/11.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "UIDevice+ASMandatoryLandscapeDevice.h"

@implementation UIDevice (ASMandatoryLandscapeDevice)

/// 输入要强制转屏的方向
/// @param interfaceOrientation 转屏的方向
+ (void)deviceMandatoryLandscapeWithNewOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];

    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    // 将输入的转屏方向（枚举）转换成Int类型
    int orientation = (int)interfaceOrientation;

    // 对象包装
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];

    // 实现横竖屏旋转
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end
