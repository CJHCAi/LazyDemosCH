//
//  CHADMobManager.h
//  CHVideoEditorDemo
//
//  Created by 火虎MacBook on 2020/8/4.
//  Copyright © 2020 Allen_Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>//谷歌广告

@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN
@protocol CHADMobManagerDelegate <NSObject>
@optional
#pragma mark - 横幅广告代理方法
/// 收到横幅广告
- (void)bannerADViewDidReceiveAd:(GADBannerView *)adView;

/// 横幅广告用户单击将打开另一个应用程序
- (void)bannerADViewWillLeaveApplication:(GADBannerView *)adView;

#pragma mark - 插页广告代理方法
/**插页广告消失*/
- (void)interstitialDidDismissScreen:(GADInterstitialAd *)interstitial;

#pragma mark - 激励广告代理方法
/**激励广告收到奖励*/
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward;
/**激励广告已经关闭*/
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd;

@end

@interface CHADMobManager : NSObject
@property (nonatomic,weak) id<CHADMobManagerDelegate> delegate;

+(instancetype)shareInstance;

#pragma mark - 横幅广告
/**添加 谷歌横幅广告 默认尺寸 */
-(GADBannerView *)addADmobBannerADWithsuperView:(UIView *)superView;
/**添加 谷歌横幅广告 自己添加 发送请求 [bannerView loadRequest:[GADRequest request]] */
-(GADBannerView *)getADmobBannerAD;
/**获取 横幅广告 指定unitID*/
-(GADBannerView *)getADmobBannerADWithUnitID:(NSString *)unitID;
/**横幅广告 加载请求*/
-(void)bannerViewLoadRequest;
/**横幅广告 加载请求 unitId*/
-(void)bannerViewLoadRequestWithUnitID:(NSString *)unitId;

/**添加横幅广告 指定广告ID*/
-(GADBannerView *)addADmobBannerADWithsuperView:(UIView *)superView bannerUnitID:(NSString *)unitID;
/**添加谷歌横幅广告 bannerADType = kGADAdSizeSmartBannerPortrait*/
-(GADBannerView *)addADmobBannerADWithsuperView:(UIView *)superView bannerADType:(GADAdSize)bannerADType;

#pragma mark - 插页广告
/**加载插页广告 指定ID  */
- (GADInterstitialAd *)createAndLoadInterstitialADWithUnitID:(NSString *)unitID;
/**展示插页广告*/
-(void)showInterstitialADWithRootViewController:(UIViewController *)rootVC;

#pragma mark - 激励广告
/**创建加载激励广告*/
- (GADRewardedAd *)createAndLoadRewardedAdWithUnitID:(NSString *)unitID;
/**展示激励广告*/
-(void)showRewardADWithRootViewController:(UIViewController *)rootVC;

#pragma mark - 开屏广告
/**请求一个开屏广告 默认ID*/
- (void)requestLaunchOpenAd;
/**请求一个开屏广告 自定义广告ID*/
- (void)requestLaunchOpenAdWithUnitID:(NSString *)unitID;
/**展示开屏开屏广告*/
- (void)presentTryToLaunchOpenAd;
@end

NS_ASSUME_NONNULL_END
