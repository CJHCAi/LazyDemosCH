//
//  JRConst.h
//  JR
//
//  Created by Zj on 17/8/18.
//  Copyright © 2017年 Zj. All rights reserved.
//

#ifndef JRConst_h
#define JRConst_h

/**
 字符串
 */


/**
 颜色
 */
#define JRWhiteColor [UIColor whiteColor] //白色
#define JRBlackColor [UIColor blackColor] //黑色
#define JRClearColor [UIColor clearColor] //透明色
#define JRCommonTextColor JRHexColor(0x3d4c4f) //一般文字颜色
#define JRLightTextColor JRHexColor(0xa1a1a1) //浅色文字
#define JRDisabledTextColor


/**
 尺寸
 */
#define JRScreenHeight [UIScreen mainScreen].bounds.size.height //屏幕高度
#define JRScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define JRPadding 15 //间隔
#define JRRadius 6 //圆角
#define JRHeight(height) (height * JRScreenHeight / 667) //高度缩放
#define JRWidth(width) (width * JRScreenHeight / 667) //宽度缩放


//首页
#define JRGymInfoViewHeight JRHeight(315)
#define JRZoomCycleImgViewHeight JRHeight(175)
#define JRFitnessStatusViewHeight JRHeight(225)
#define JRGymClassCellHeight JRHeight(255)
#define JRHomeTitleHeight JRHeight(50)


/**
 字体
 */
#define JRThinFont(size) [UIFont systemFontOfSize:size weight:UIFontWeightUltraLight]
#define JRCommonFont(size) [UIFont systemFontOfSize:size weight:UIFontWeightRegular]
#define JRBlodFont(size) [UIFont systemFontOfSize:size weight:UIFontWeightBold]

#define JRCommonTextFontSize 15
#define JRLargeTextFontSize 20
#define JRSmallTextFontSize 11

#endif /* JRConst_h */
