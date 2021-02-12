//
//  BaiduMobAdNativeAdObject.h
//  BaiduMobNativeSDK
//
//  Created by lishan04 on 15-5-26.
//  Copyright (c) 2015年 lishan04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"

@interface BaiduMobAdNativeAdObject: NSObject

/**
 * 标题 text
 */
@property (copy, nonatomic)  NSString *title;
/**
 * 描述 text
 */
@property (copy, nonatomic)  NSString *text;
/**
 * 小图 url
 */
@property (copy, nonatomic) NSString *iconImageURLString;
/**
 * 大图 url
 */
@property (copy, nonatomic) NSString *mainImageURLString;

/**
 * 广告标识图标 url
 */
@property (copy, nonatomic) NSString *adLogoURLString;

/**
 * 百度logo图标 url
 */
@property (copy, nonatomic) NSString *baiduLogoURLString;

/**
 * 多图信息流的image url array
 */
@property (strong, nonatomic) NSArray *morepics;
/**
 * 视频url
 */
@property (copy, nonatomic)  NSString *videoURLString;
/**
 * 视频时长，单位为s
 */
@property (copy, nonatomic)  NSNumber *videoDuration;
/**
 * 品牌名称，若广告返回中无品牌名称则为空
 */
@property (copy, nonatomic)  NSString *brandName;
/**
* 开发者配置可接受视频后，对返回的广告单元，需先判断MaterialType再决定使用何种渲染组件
 */
@property MaterialType materialType;

/**
 * 返回广告单元的点击类型
 */
@property (nonatomic)   BaiduMobNativeAdActionType actType;


/**
 * 是否过期，默认为false，30分钟后过期，需要重新请求广告
 */
-(BOOL) isExpired;

//#warning 重要，一定要调用这个方法发送视频状态事件和当前视频播放的位置
/**
 * 发送视频广告相关日志
 * @param currentPlaybackTime 播放器当前时间，单位为s
 */
- (void)trackVideoEvent:(BaiduAdNativeVideoEvent)event withCurrentTime:(NSTimeInterval)currentPlaybackTime;
@end
