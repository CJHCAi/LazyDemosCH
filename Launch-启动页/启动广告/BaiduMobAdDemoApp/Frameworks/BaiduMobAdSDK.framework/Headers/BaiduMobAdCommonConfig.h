//
//  BaiduMobAdCommonConfig.h
//  BaiduMobAdSdk
//
//  Created by dengjinxiang on 13-8-22.
//
//
#import <UIKit/UIKit.h>
#ifndef BaiduMobAdSdk_BaiduMobAdCommonConfig_h
#define BaiduMobAdSdk_BaiduMobAdCommonConfig_h
// SDK版本号
#define SDK_VERSION_IN_MSSP @"4.4"

typedef enum {
    NORMAL, // 一般图文或图片广告
    VIDEO, // 视频播放类广告，需开发者增加播放器支持
    HTML // 信息流模版广告
} MaterialType;

typedef enum {
    BaiduMobNativeAdActionTypeLP = 1,
    BaiduMobNativeAdActionTypeDL = 2
} BaiduMobNativeAdActionType;

typedef enum {
    onShow,  //video展现
    onClickToPlay,//点击播放
    onStart, //开始播放
    onError, //播放失败
    onComplete, //完整播放
    onClose, //播放结束
    onFullScreen, //全屏观看
    onClick, //广告点击
    onSkip, //跳过视频
    onShowEndCard,// 展现endcard
    onClickEndCard// 点击endcard
} BaiduAdNativeVideoEvent;

/**
 *  性别类型
 */
typedef enum {
    BaiduMobAdMale = 0,
    BaiduMobAdFeMale = 1,
    BaiduMobAdSexUnknown = 2,
} BaiduMobAdUserGender;

/**
 *  广告展示失败类型枚举
 */
typedef enum _BaiduMobFailReason {
    BaiduMobFailReason_NOAD = 0,
    // 没有推广返回
    BaiduMobFailReason_EXCEPTION,
    //网络或其它异常
    BaiduMobFailReason_FRAME
    //广告尺寸异常，不显示广告
} BaiduMobFailReason;


/**
 *  Landpage页面导航栏颜色设置
 */
typedef enum {
    BaiduMobAdLpStyleDefault,
    BaiduMobAdLpStyleRed,
    BaiduMobAdLpStyleGreen,
    BaiduMobAdLpStyleBrown,
    BaiduMobAdLpStyleDarkBlue,
    BaiduMobAdLpStyleLightBlue,
    BaiduMobAdLpStyleBlack
} BaiduMobAdLpStyle;

/**
 *  度宝初始化位置，在屏幕左侧还是右侧
 */
typedef enum {
    BaiduMobAdDubaoPositionLeft,
    BaiduMobAdDubaoPositionRight
} BaiduMobAdDubaoPosition;

#endif
