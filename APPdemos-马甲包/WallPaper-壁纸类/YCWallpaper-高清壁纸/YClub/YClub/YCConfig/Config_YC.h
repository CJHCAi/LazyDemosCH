//
//  Config_YC.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#ifndef Config_YC_h
#define Config_YC_h

#define kAppName                  @"高清壁纸"
#define kAppUrl                   @"itms-apps://itunes.apple.com/app/id1232126821"
#define kUMAppKey                 @"59127aac45297d3b1c002333"
#define kQQAppId                  @"1106156590"
#define kQQAppKey                 @"CH7ygTCDZafhKOwG"
// key
#define kYCLastVersionKey         @"lastVersion"
#define kYCVersionCommentKey      @"versionCommentKey"
#define kYCRemoveLaunchViewNoti   @"removeLaunchViewNoti"
#define kYCFirstVersionKey        @"firstVersionKey"
#define kYCReadFoodCount          @"readFoodCount"
#define kYCEditLoadingNoti        @"editLoadingNoti"

// 在线参数
#define kYCForAppstoreOnlineKey   @"ycForAppstoreOnlineKey"

//----------------------UI类--------------------------
//RGB颜色
#define RGBA(r,g,b,a)              [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)                 RGBA(r,g,b,1.0f)

//Font字体
#define SYSTEM_FONT(F)             [UIFont systemFontOfSize:F]
#define BOLD_FONT(F)               [UIFont boldSystemFontOfSize:F]


//#define YC_Nav_TitleColor          RGB(106, 106, 106)
#define YC_Nav_TitleColor          RGB(93, 109, 121)
#define YC_Nav_TitleFont           BOLD_FONT(16)

//#define YC_Base_TitleColor         RGB(106, 106, 106)
#define YC_Base_TitleColor         RGB(93, 109, 121)
#define YC_Base_TitleFont          SYSTEM_FONT(15)



#define YC_Base_ContentColor       RGB(149, 149, 149)
#define YC_Base_ContentFont        SYSTEM_FONT(13)

//#define YC_Base_BgGrayColor        RGB(241, 242, 243)
#define YC_Base_BgGrayColor        RGB(239, 239, 239)
#define YC_Base_LineColor          RGB(225, 225, 225)

#define YC_Line_Count              3.f
#define YC_Base_Space              5.f
#define YC_Base_Scale              KSCREEN_WIDTH/375.f
//基本UI
#define YC_TabBar_SeleteColor      RGB(43, 157, 204)
#define YC_Base_GrayEdgeColor      RGB(179, 179, 179)
//----------------------设备类--------------------------
//获取屏幕 宽度、高度
#define KSCREEN_WIDTH              ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT             ([UIScreen mainScreen].bounds.size.height)

#define IS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_MAX_LENGTH       (MAX(KSCREEN_WIDTH, KSCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS     (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5             (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6             (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P            (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//----------------------－引用－----------------------------
//Block
#define WS(weakSelf)            __weak   __typeof(&*self)weakSelf       = self

#define WeakSelf(weakSelf)      __weak   __typeof(&*self)weakSelf       = self
#define StrongSelf(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf

//----------------------数据判空----------------------------
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 ? YES : NO)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kAppVersion         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* Config_YC_h */
