//
//  UIDevice+TFDevice.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TFDevice)

/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
