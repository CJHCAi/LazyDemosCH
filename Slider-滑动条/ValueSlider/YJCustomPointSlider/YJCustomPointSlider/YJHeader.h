//
//  YJHeader.h
//  YJCustomPointSlider
//
//  Created by 于英杰 on 2019/5/15.
//  Copyright © 2019 YYJ. All rights reserved.
//

#ifndef YJHeader_h
#define YJHeader_h


//----------------------------------洪
//屏幕宽度
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
//状态栏高度
#define KStatuesBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)
//导航栏高度
#define KNavigationBarHeight 44.0
//导航栏高度+状态栏高度
#define kViewTopHeight (KStatuesBarHeight + KNavigationBarHeight)
//iphoneX适配差值
#define KiPhoneXSafeAreaDValue ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//----------------------------------头文件
#import "UIColor+YJColorExtention.h"




#endif /* YJHeader_h */
