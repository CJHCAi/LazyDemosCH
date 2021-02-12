//
//  Config.h
//  仿支付宝蚂蚁森林
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#ifndef Config_h
#define Config_h

//导航栏高度
#define NAVIHEIGHT 44.0
//状态栏高度
#define STATUSHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏和状态栏总高度
#define NAVISTATUSHEIGHT (NAVIHEIGHT + STATUSHEIGHT)

//屏幕宽高
#define YLBScreenWidth [UIScreen mainScreen].bounds.size.width
#define YLBScreenHeight [UIScreen mainScreen].bounds.size.height
#define YLBScreenBounds [UIScreen mainScreen].bounds

/**宽度比例*/
#define WZC_ScaleWidth(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375)*(__VA_ARGS__)

/**高度比例*/
#define WZC_ScaleHeight(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375.0f)*(__VA_ARGS__)


#endif /* Config_h */
