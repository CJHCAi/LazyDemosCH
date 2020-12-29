//
//  UtilEnmu.h
//  XiYou_IOS
//
//  Created by regan on 15/11/17.
//  Copyright © 2015年 regan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UtilHKEnmu_h
#define UtilHKEnmu_h

#define APP_FRAME [UIScreen mainScreen ].applicationFrame
#define SCREEN_FRAME [UIScreen mainScreen ].bounds
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]
#define UICOLOR_HEX(_color) UICOLOR_RGB_Alpha(_color,1)
#define UICOLOR_BIG [UIColor colorWithRed:106.0f/255 green:115.0f/255 blue: 125.0f/255 alpha:1.0f]

#define isStringNotEmpty(X) ((X) != nil && ![(X) isEqualToString:@""])

#define AppDelegateInstance ((AppDelegate*)[UIApplication sharedApplication].delegate)

//font
#define PingFangSCMedium @"PingFangSC-Medium"
#define PingFangSCRegular @"PingFangSC-Regular"
#define FontMaker(_fontName,_size) [UIFont fontWithName:_fontName size:_size]

#define HEIGHT_OF_STATUS_BAR 20.0f
#define HEIGHT_OF_NAVIGATION_BAR 44.0f
#define HEIGHT_OF_X_NAVIGATION_VIEW 64.0f
#define HEIGHT_OF_SEARCH_BAR 44.0f

#define GLOBAL_LEFT_PADDING_SMALL 10.0f
#define GLOBAL_LEFT_PADDING_NORMAL 13.0f
#define GLOBAL_LEFT_PADDING_LARG 15.0f


//#define GLOBAL_FONT_SIZE_SMALL 13.0f
#define GLOBAL_FONT_SIZE_NORMAL 15.0f
#define GLOBAL_FONT_SIZE_LARG 16.0f

#define GLOBAL_FONT_COLOR_DEEP RGBMAKE(0x33, 0x33, 0x33, 1)


#define GLOBAL_CELL_HEIGHT_NORMAL 42.0f


// =============
#pragma mark - 长度值
// =============

#define LENGHT_OF_PASSWORD_MIN 6
#define LENGHT_OF_PASSWORD_MAX 16


//#define kMediaLength self.player.media.length
//#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//#define kSCREEN_BOUNDS [[UIScreen mainScreen] bounds]
//
//static const CGFloat SMA_ProgressWidth = 3.0f;
//static const CGFloat SMA_VideoControlBarHeight = 40.0;
//static const CGFloat SMA_VideoControlSliderHeight = 10.0;
//static const CGFloat SMA_VideoControlAnimationTimeinterval = 0.3;
//static const CGFloat SMA_VideoControlTimeLabelFontSize = 10.0;
//static const CGFloat SMA_VideoControlBarAutoFadeOutTimeinterval = 4.0;
//static const CGFloat SMA_VideoControlCorrectValue = 3;
//static const CGFloat SMA_VideoControlAlertAlpha = 0.75;


/**
 //在项目的prefix.pch文件里加入下面一段代码，加入后，NSLog就只在Debug下有输出，Release下不输出了。
 #ifndef __OPTIMIZE__
 #define NSLog(...) NSLog(__VA_ARGS__)
 #else
 #define NSLog(...) {}
 #endif
 **/


//设置网络指示器开关
//#define WNetworkActivityIndicatorVisible(isVisible) [UIApplication sharedApplication].networkActivityIndicatorVisible = isVisible
//#define WGetWeakSelf(toName,instance)   __weak typeof(&*instance)toName = instance    //设置弱引用
//#define WGetStrongSelf(toName,instance)   __strong typeof(&*instance)toName = instance //设置强引用
//加载与nibClass同名的nib文件
//#define WLoadBundleNibClass(nibClass) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(nibClass) owner:self options:nil] firstObject]

#define WStatusBarHeight    ([UIApplication sharedApplication].statusBarFrame.size.height)
#define Screen_AppShowFrame ([UIScreen mainScreen].applicationFrame)


//------------系统默认控件--------------
#define SystemNavBar                                 self.navigationController.navigationBar
#define SystemTabBar                                 self.tabBarController.tabBar
#define SystemNavBarHeight                           self.navigationController.navigationBar.bounds.size.height
#define SystemTabBarHeight                           self.tabBarController.tabBar.bounds.size.height
#define SystemDefaultNavBarHeightWithStatueBarNum    (64.0f)
#define SystemDefaultNavBarHeightWithoutStatusBarNum (44.0f)
#define SystemDefaultTabBarHeightNum                 (49.0f)


#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar

#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height

#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height

#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define DefaultToolbarHeight                self.navigationController.navigationBar.frame.size.height

////-----------------颜色-----------------
//#define WColorFromRGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#define WColorFromRGB(r,g,b)     WColorFromRGBA(r,g,b,1.0)


//ARC And MRC
#define WSDKIsRunInARC (__has_feature(objc_arc))
#define WSDKIsRunInMRC (!__has_feature(objc_arc))
//SDK是否是IOS9以上
#define WSDKIsIOS9OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_9_0)
//SDK是否是IOS8以上
#define WSDKIsIOS8OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_8_0)
//SDK是否是IOS7以上
#define WSDKIsIOS7OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_7_0)
//SDK是否是IOS6以上
#define WSDKIsIOS6OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_6_0)
//SDK是否是sdkVersion之后,sdkVersion形如:__IPHONE_9_0
#define WSDKIsOrLaterFromVersionFlag(sdkVersion) (__IPHONE_OS_VERSION_MAX_ALLOWED >= sdkVersion)
//SDK是否是sdkVersion之前,sdkVersion形如:__IPHONE_9_0
#define WSDKBeforeFromVersionFlag(sdkVersion)    ((__IPHONE_OS_VERSION_MAX_ALLOWED < sdkVersion))

#define XYfont(s)  [UIFont systemFontOfSize:(s)]
#define XYColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define SafeAreaTopHeight (isIPhoneXAll ? 88 : 64)

#define SafeAreaBottomHeight (isIPhoneXAll ? 34 : 0)

#define kWJHeightCoefficient (kScreenHeight == 812.0 ? 667.0/667.0 : kScreenHeight/667.0)

#define isIPhoneXAll ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

typedef NS_ENUM(NSInteger,ClickTag)
{
    //以下是枚举成员
    Tag_None=0,
    //---------------add here------------------------
    
    //---------------end here------------------------
    TagLast
    
};

typedef NS_ENUM(NSInteger,UNITE_TYPE)

{
    //以下是枚举成员
    UNITE_None = 0,
    
    UNITE_One,
    //---------------add here------------------------
    UNITE_Two,
    //---------------end here------------------------
    UNITE_Three,
    //---------------end here------------------------
    UNITE_Four,
    //---------------end here------------------------
    UNITE_Five,
    //---------------end here------------------------
    UNITE_Six,
    //---------------end here------------------------
    UNITE_Seven,
    //---------------end here------------------------
    UNITE_Eight,
    //---------------end here------------------------
    UNITE_Nine,
    //---------------end here------------------------
    UNITE_Ten,
    //---------------end here------------------------
    UNITE_Eleven,
    //---------------end here------------------------
    UNITE_Twelve,
    //---------------end here------------------------
    UNITE_Thirteen,
    //---------------end here------------------------
    UNITE_Fourteen,
    //---------------end here------------------------
    UNITE_Fifteen,
    //---------------end here------------------------
    UNITE_Sixteen,
    //---------------end here------------------------
    UNITE_Seventeen,
    //---------------end here------------------------
    UNITE_Eighteen,
    //---------------end here------------------------
    UNITE_Nineteen,
    //---------------end here------------------------
    UNITE_Twenty,
    //---------------end here------------------------
    UNITE_TwentyOne,
    //---------------end here------------------------
    UNITE_TwentyTwo,
    //---------------end here------------------------
    
    


    UNITE_Last
    
};

typedef NS_ENUM(NSInteger,PARSER_TYPE)

{
    //以下是枚举成员
    PARSER_None= 0,
    //---------------add here------------------------
    PARSER_Brand,
    //---------------end here------------------------
    PARSER_Shop,
    //---------------end here------------------------
    PARSER_Album,
    //---------------end here------------------------
    PARSER_Last
    
};


typedef NS_ENUM(NSInteger,AliPay_TYPE)

{
    //以下是枚举成员
    AliPay_None= 0,
    
    AliPay_Domestic,
    
    AliPay_Abroad,

    AliPay_Last
    
};

#endif /* UtilEnmu_h */
