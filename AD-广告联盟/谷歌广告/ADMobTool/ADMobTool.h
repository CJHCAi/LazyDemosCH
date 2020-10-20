//
//  ADMobTool.h
//  SNHVideoEditorTool
//
//  Created by 七啸网络 on 2018/4/21.
//  Copyright © 2018年 huangshuni. All rights reserved.
//
typedef void (^CallBlock)(void);
#import <Foundation/Foundation.h>
@import GoogleMobileAds;

@interface ADMobTool : NSObject
/**创建横幅广告View*/
+(GADBannerView *)Admob_creatBannerADWithRootAndDelegateVC:(id)rootVC;
/**请求插页广告*/
+(GADInterstitial *)Admob_RequestInterstitialWithDelegate:(id )vc;
/**展示插页广告*/
+(void)Admob_presentInterstitial:(GADInterstitial *)interstitial WithVc:(id)vc isUnReady:(void(^)(void))isUnready;
/**请求激励视频广告*/
+(void)Admob_requestRewardedVideoWithDelegate:(id )VC;
/**展示激励视频广告*/
+(void)Admob_presentRewardVideoWithVC:(id)VC ADIsUnReady:(void(^)(void))ADUnReaady;
@end
