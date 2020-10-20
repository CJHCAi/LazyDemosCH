//
//  GDTADTool.h
//  GDTMobSample
//
//  Created by 七啸网络 on 2018/4/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTMobBannerView.h"
#import "GDTMobInterstitial.h"
#import "GDTNativeAd.h"
#import "GDTSplashAd.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

//#import "GDTAppDelegate.h"
@interface GDTADTool : NSObject
+(GDTMobBannerView *)GDT_setupBannerView;
+(GDTMobInterstitial *)GDT_setupInterstitial;
+(GDTNativeAd *)GDT_setupNativeAD;
/**半开屏*/
+(GDTSplashAd *)GDT_setupSplashADWithBottomView:(UIView *)bottomView  skipView:(UIView *)skipView;
/**全屏开屏*/
+(GDTSplashAd *)GDT_FullSplashAD:(UIWindow *)window;
/**原生模板广告*/
+(GDTNativeExpressAd *)GDT_setupNativeExpressADWithWidth:(CGFloat)width height:(CGFloat)height Adcount:(NSInteger)adCount;
/**原生视频模板广告*/
+(GDTNativeExpressAd *)GDT_setupNativeVideoExpressADWithSize:(CGSize)size autoPlay:(BOOL)autoPlay videoMute:(BOOL)videoMute adCount:(NSInteger)adCount;
@end
