//
//  BaiduMobAdInterstitialDelegate.h
//  BaiduMobAdWebSDK
//
//  Created by deng jinxiang on 13-8-1.
//
//
#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"
@class BaiduMobAdNative;
@class BaiduMobAdNativeAdView;

@protocol BaiduMobAdNativeAdDelegate <NSObject>

@required
/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString *)publisherId;

/**
 * 广告位id
 */
-(NSString*)apId;

@optional

/**
 * 模版高度，仅用于信息流模版广告
 */
-(NSNumber*)height;

/**
 * 模版宽度，仅用于信息流模版广告
 */
-(NSNumber*)width;

/**
 *  渠道ID
 */
- (NSString *)channelId;

/**
 *  启动位置信息
 */
-(BOOL) enableLocation;//如果enable，plist 需要增加NSLocationWhenInUseUsageDescription


/**
 * 广告请求成功
 * @param 请求成功的BaiduMobAdNativeAdObject数组，如果只成功返回一条原生广告，数组大小为1
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds;
/**
 *  广告请求失败
 * @param 失败的BaiduMobAdNative
 * @param 失败的类型 BaiduMobFailReason
 */
- (void)nativeAdsFailLoad:(BaiduMobFailReason) reason;

/**
 * 对于视频广告，展现一张视频预览图，点击可选择开始播放视频
 */
- (void)nativeAdVideoAreaClick:(BaiduMobAdNativeAdView*)nativeAdView;

/**
 *  广告点击
 */
- (void)nativeAdClicked:(BaiduMobAdNativeAdView*)nativeAdView;

/**
 *  广告详情页关闭
 */
-(void)didDismissLandingPage:(BaiduMobAdNativeAdView *)nativeAdView;
///---------------------------------------------------------------------------------------
/// @name 人群属性板块
///---------------------------------------------------------------------------------------

/**
 *  关键词数组
 */
-(NSArray*) keywords;

/**
 * 附加字段
 */
-(NSDictionary*) extraDic;

/**
 *  用户性别
 */
-(BaiduMobAdUserGender) userGender;

/**
 *  用户生日
 */
-(NSDate*) userBirthday;

/**
 *  用户城市
 */
-(NSString*) userCity;


/**
 *  用户邮编
 */
-(NSString*) userPostalCode;


/**
 *  用户职业
 */
-(NSString*) userWork;

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0代表小学，1代表初中，2代表中专/高中，3代表专科
 *  - 4代表本科，5代表硕士，6代表博士
 */
-(NSInteger) userEducation;

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary;

/**
 *  用户爱好
 */
-(NSArray*) userHobbies;

/**
 *  其他自定义字段,key以及value都为NSString
 */
-(NSDictionary*) userOtherAttributes;



@end
