//
//  ADMobTool.m
//  SNHVideoEditorTool
//
//  Created by 七啸网络 on 2018/4/21.
//  Copyright © 2018年 huangshuni. All rights reserved.
//
#define BannerID @"ca-app-pub-3940256099942544/2934735716"
#define InterstitialID @"ca-app-pub-3940256099942544/4411468910"
#define RewardID @"ca-app-pub-3940256099942544/1712485313"
#import "ADMobTool.h"

@interface ADMobTool()<GADBannerViewDelegate,GADInterstitialDelegate,GADRewardBasedVideoAdDelegate>

@end
@implementation ADMobTool

static GADNativeAppInstallAd * nativeAppInstallAd_;
static GADNativeContentAd  * nativeContentAd_;
static GADNativeAppInstallAdView *  appInstallAdView_;

//AppDelegate初始化
//[GADMobileAds configureWithApplicationID:@"ca-app-pub-3940256099942544~1458002511"];


#pragma mark-横幅广告
+(GADBannerView *)Admob_creatBannerADWithRootAndDelegateVC:(id)rootVC{
    GADBannerView * bannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.adUnitID = BannerID;
    bannerView.rootViewController = rootVC;
    bannerView.delegate = rootVC;
    [bannerView loadRequest:[GADRequest request]];
    return bannerView;
}

#pragma mark-GADBannerViewDelegate(控制器实现代理方法)
/// 接收到广告
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    
}
///横幅广告加载失败
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
}

///横幅将要显示
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
}

///横幅广告将要消失
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
}

///横幅广告消失
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
}

///离开应用
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
}




#pragma mark-插页广告
+(GADInterstitial *)Admob_RequestInterstitialWithDelegate:(id)vc{
    
    GADInterstitial * interstitial = [[GADInterstitial alloc] initWithAdUnitID:InterstitialID];
    [interstitial loadRequest:[GADRequest request]];
    interstitial.delegate=vc;
    return interstitial;
}
/**展示插页广告*/
+(void)Admob_presentInterstitial:(GADInterstitial *)interstitial WithVc:(id)vc isUnReady:(void(^)(void))Unready{
    if (interstitial.isReady ){
        [interstitial presentFromRootViewController:(UIViewController *)vc];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (Unready) {
                Unready();
            }
            
        });
    }

}

#pragma mark-GADInterstitialDelegate
///广告消失
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    //重新加载Admob_createAndLoadInterstitial
}
///展示失败
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    
}
///接收到广告
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    
}

///将要展示广告
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
}

///广告将要消失
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
}


/// 进入后台离开当前app
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
}



#pragma mark-激励视频
/**请求激励广告*/
+(void)Admob_requestRewardedVideoWithDelegate:(id )VC{
    
    [GADRewardBasedVideoAd sharedInstance].delegate =VC;
    if (![[GADRewardBasedVideoAd sharedInstance] isReady]) {

        [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:RewardID];
    }
}
/**展示激励视频广告*/
+(void)Admob_presentRewardVideoWithVC:(id)VC ADIsUnReady:(void(^)(void))ADUnReaady{
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:VC];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ADUnReaady) {
                ADUnReaady();
            }
        });
    }
}

#pragma mark-GADRewardBasedVideoAdDelegate(方法要再控制器实现)
/**收到奖励*/
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
//    NSString *rewardMessage =[NSString stringWithFormat:@"收到奖励数量%lf",reward.type,[reward.amount doubleValue]];
    
}
/**关闭激励视频*/
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
}
/**激励视频加载失败*/
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error {
}




/**收到激励广告*/
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
}
/**打开激励视频*/
- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
}
/**激励视频开始播放*/
- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
}
/**激励视频播放完成*/
- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
}
/**离开当前应用*/
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
}



@end
