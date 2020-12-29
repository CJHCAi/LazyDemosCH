
//
//  UIDevice+TFDevice.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "UIDevice+TFDevice.h"

@implementation UIDevice (TFDevice)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
}
@end
