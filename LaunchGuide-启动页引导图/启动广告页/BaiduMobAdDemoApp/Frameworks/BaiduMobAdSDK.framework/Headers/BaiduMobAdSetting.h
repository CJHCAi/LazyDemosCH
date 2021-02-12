//
//  BaiduMobAdWebSDK
//
//
//
#import <UIKit/UIKit.h>
#import "BaiduMobAdCommonConfig.h"

@interface BaiduMobAdSetting : NSObject
@property BOOL supportHttps;
/**
 *  设置Landpage页面导航栏颜色
 */
+ (void)setLpStyle:(BaiduMobAdLpStyle)style;
+ (BaiduMobAdSetting *)sharedInstance;

@end

