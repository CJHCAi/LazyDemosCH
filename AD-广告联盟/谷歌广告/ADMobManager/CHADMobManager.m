//
//  CHADMobManager.m
//  CHVideoEditorDemo
//
//  Created by 火虎MacBook on 2020/8/4.
//  Copyright © 2020 Allen_Macbook Pro. All rights reserved.
//

#import "CHADMobManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface CHADMobManager()<GADBannerViewDelegate,GADFullScreenContentDelegate>
@property (nonatomic,strong) GADBannerView * bannerView;
@property (nonatomic,strong) GADInterstitialAd *interstitialAd;
@property (nonatomic,strong) GADRewardedAd *rewardedAd;
@property(nonatomic) GADAppOpenAd* appOpenAd;

@property (nonatomic,copy) NSString *interstitialUnitID;//记录插页广告ID
@property (nonatomic,copy) NSString *rewardUnitID;//记录激励广告ID
@property (nonatomic,copy) NSString *launchUnitID;//记录开屏广告ID

@end

@implementation CHADMobManager

static CHADMobManager * _manager = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CHADMobManager alloc] init];
    });
    return _manager;
}

#pragma mark - 横幅广告
/**添加 谷歌横幅广告 默认尺寸 */
-(GADBannerView *)addADmobBannerADWithsuperView:(UIView *)superView{
    BOOL isVip = GetVIPState;
    GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    if (isVip == NO) {
        GADAdSize size = GADAdSizeFromCGSize(CGSizeMake(superView.width,superView.height));
        bannerView.adSize = size;
        bannerView.adUnitID = BannerADUnitID;
        UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        bannerView.rootViewController = rootVC;
        bannerView.delegate =_manager;
        [superView addSubview:bannerView];
        [bannerView loadRequest:[GADRequest request]];
    }
    return bannerView;
}

/**获取 横幅广告 自己添加 发送请求  */
-(GADBannerView *)getADmobBannerAD{
    BOOL isVip = GetVIPState;
    GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    if (isVip == NO) {
        UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        bannerView.rootViewController = rootVC;
        bannerView.delegate =_manager;
        self.bannerView = bannerView;
    }
    return bannerView;
}

/**获取 横幅广告 指定unitID*/
-(GADBannerView *)getADmobBannerADWithUnitID:(NSString *)unitID{
    BOOL isVip = GetVIPState;
    GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    if (isVip == NO) {
        bannerView.adUnitID = unitID;
        UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        bannerView.rootViewController = rootVC;
        bannerView.delegate =_manager;
        self.bannerView = bannerView;
    }
    return bannerView;
}

/**横幅广告 加载请求*/
-(void)bannerViewLoadRequest{
    [self.bannerView loadRequest:[GADRequest request]];
}

/**横幅广告 加载请求 unitId*/
-(void)bannerViewLoadRequestWithUnitID:(NSString *)unitId{
    self.bannerView.adUnitID = unitId;
    [self.bannerView loadRequest:[GADRequest request]];
}


/**添加横幅广告 指定广告ID*/
-(GADBannerView *)addADmobBannerADWithsuperView:(UIView *)superView bannerUnitID:(NSString *)unitID{
    BOOL isVip = GetVIPState;
    GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    if (isVip == NO) {
        //    GADAdSize size = GADAdSizeFromCGSize(CGSizeMake(superView.width,superView.height));
        //    bannerView.adSize = size;
            bannerView.adUnitID = unitID;
            UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
            bannerView.rootViewController = rootVC;
            bannerView.delegate =_manager;
            [superView addSubview:bannerView];
            [bannerView loadRequest:[GADRequest request]];
    }
    return bannerView;
}

/**添加谷歌横幅广告 指定尺寸类型*/
-(GADBannerView *)addADmobBannerADWithsuperView:(UIView *)superView bannerADType:(GADAdSize)bannerADType {
    BOOL isVip = GetVIPState;
    GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:bannerADType];
    if (isVip == NO) {
        GADAdSize size = GADAdSizeFromCGSize(CGSizeMake(superView.width,superView.height));
        bannerView.adSize = size;
        bannerView.adUnitID = BannerADUnitID;
        UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        bannerView.rootViewController = rootVC;
        bannerView.delegate =_manager;
        [superView addSubview:bannerView];
        [bannerView loadRequest:[GADRequest request]];
    }
    return bannerView;
}


#pragma mark - ADMOb
#pragma mark - <GADBannerViewDelegate>
/// 收到横幅广告
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//  NSLog(@"收到横幅广告");
    if ([self.delegate respondsToSelector:@selector(bannerADViewDidReceiveAd:)]) {
        [self.delegate bannerADViewDidReceiveAd:adView];
    }
}

///横幅广告请求失败
- (void)adView:(GADBannerView *)adView    didFailToReceiveAdWithError:(NSError *)error {
//  NSLog(@"横幅广告请求失败");

}

/// 横幅广告将要显示全屏视图
/// 点击广告的用户
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
//  NSLog(@"横幅广告将要显示全屏视图");
}

/// 横幅广告将要取消全屏视图
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
//  NSLog(@"横幅广告将要取消全屏视图");

}

/// 横幅广告已取消全屏视图
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
//  NSLog(@"横幅广告已取消全屏视图");
}

/// 横幅广告用户单击将打开另一个应用程序
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
//  NSLog(@"横幅广告用户单击将打开另一个应用程序");
    if ([self.delegate respondsToSelector:@selector(bannerADViewWillLeaveApplication:)]) {
        [self.delegate bannerADViewWillLeaveApplication:adView];
    }
}

#pragma mark - 插页广告
/**加载插页广告 指定ID */
- (GADInterstitialAd *)createAndLoadInterstitialADWithUnitID:(NSString *)unitID {
    self.interstitialUnitID = unitID;
    GADInterstitialAd *interstitialAd =
      [[GADInterstitialAd alloc] init];
    [GADInterstitialAd loadWithAdUnitID:unitID request:[GADRequest request] completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        if (!error) {
            self.interstitialAd = interstitialAd;
            self.interstitialAd.fullScreenContentDelegate = _manager;
            NSLog(@"获得插页广告");
        }else{
            NSLog(@"获取插页广告出现错误:%@",error);
        }

    }];
  return interstitialAd;
}

/**展示插页广告*/
-(void)showInterstitialADWithRootViewController:(UIViewController *)rootVC{
    BOOL canPresent = [self.interstitialAd canPresentFromRootViewController:rootVC error:nil];
    if (canPresent&&self.interstitialAd) {
        [self.interstitialAd presentFromRootViewController:rootVC];
    } else {
        NSLog(@"插页广告还没准备好");
        [SVProgressHUD showInfoWithStatus:@"插页广告还没准备好" hidewithInterVal:1];
    }
}

#pragma mark - GADInterstitialDelegate
///广告已被移出屏幕
- (void)interstitialDidDismissScreen:(GADInterstitialAd *)interstitial {
 
    //重新请求插页广告
    [_manager createAndLoadInterstitialADWithUnitID:self.interstitialUnitID];
    //关闭插页广告的回调
    if ([_manager.delegate respondsToSelector:@selector(interstitialDidDismissScreen:)]) {
        [_manager.delegate interstitialDidDismissScreen:interstitial];
    }
}

///插页广告请求成功
- (void)interstitialDidReceiveAd:(GADInterstitialAd *)ad {
    NSLog(@"插页广告请求成功");
}

/// 插页广告请求失败
- (void)interstitial:(GADInterstitialAd *)ad
    didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"插页广告请求失败: %@", [error localizedDescription]);
}

/// 将显示一个插页广告。
- (void)interstitialWillPresentScreen:(GADInterstitialAd *)ad {
  NSLog(@"将显示一个插页广告");
}

/// 插页广告将被动画移出屏幕
- (void)interstitialWillDismissScreen:(GADInterstitialAd *)ad {
  NSLog(@"插页广告将被动画移出屏幕");
}

///用户单击将打开另一个应用程序
- (void)interstitialWillLeaveApplication:(GADInterstitialAd *)ad {
  NSLog(@"用户单击将打开另一个应用程序");
}

#pragma mark - 激励广告
/**创建加载激励广告*/
- (GADRewardedAd *)createAndLoadRewardedAdWithUnitID:(NSString *)unitID{
  self.rewardUnitID = unitID;
  GADRewardedAd *rewardedAd = [[GADRewardedAd alloc] init];
    [GADRewardedAd loadWithAdUnitID:unitID request:[GADRequest request] completionHandler:^(GADRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
        if (error) {
          NSLog(@"奖励广告出现错误: %@", [error localizedDescription]);
          return;
        }else{
            NSLog(@"获得激励广告>>>%@",rewardedAd);
            self.rewardedAd = rewardedAd;
            self.rewardedAd.fullScreenContentDelegate =_manager;
        }
      
    }];
  return rewardedAd;
}

/**展示激励广告*/
-(void)showRewardADWithRootViewController:(UIViewController *)rootVC{
    BOOL canpresent = [self.rewardedAd canPresentFromRootViewController:rootVC error:nil];
    if (self.rewardedAd && canpresent) {
      [self.rewardedAd presentFromRootViewController:rootVC userDidEarnRewardHandler:^{
         
          GADAdReward *reward = self.rewardedAd.adReward;
          NSString *rewardMessage = [NSString stringWithFormat:@"获得奖励:%@,amount:%lf",reward.type, [reward.amount doubleValue]];
          NSLog(@"%@", rewardMessage);
          //获得奖励的回调
          if ([_manager.delegate respondsToSelector:@selector(rewardedAd:userDidEarnReward:)]) {
              [_manager.delegate rewardedAd:self.rewardedAd userDidEarnReward:reward];
          }

       }];
    }else{
        NSLog(@"广告还在准备中");
        [SVProgressHUD showInfoWithStatus:@"广告还在准备中" hidewithInterVal:1];

    }
}


#pragma - GADFullScreeContentDelegate
- (void)adDidPresentFullScreenContent:(id)ad {
  NSLog(@"呈现了激励广告");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
  NSLog(@"显示激励广告出现错误 %@.", [error localizedDescription]);
}

- (void)adDidDismissFullScreenContent:(id)ad {
  NSLog(@"关闭了广告。");
    //关闭了激励广告
    if ([ad isEqual:self.rewardedAd]) {
        NSLog(@"关闭了激励视频广告");
        //重新请求激励视频广告
        [_manager createAndLoadRewardedAdWithUnitID:_rewardUnitID];
        //关闭广告的回调
        if ([_manager.delegate respondsToSelector:@selector(rewardedAdDidDismiss:)]) {
            [_manager.delegate rewardedAdDidDismiss:self.rewardedAd];
        }
    }
    
    //插页广告关闭的回调
    if ([ad isEqual:self.interstitialAd]) {
        NSLog(@"关闭了插页广告");
        //重新请求插页广告
        [_manager createAndLoadInterstitialADWithUnitID:self.interstitialUnitID];
        //关闭插页广告的回调
        if ([_manager.delegate respondsToSelector:@selector(interstitialDidDismissScreen:)]) {
            [_manager.delegate interstitialDidDismissScreen:self.interstitialAd];
        }
    }
}

#pragma mark - GADRewardedAdDelegate
/// 用户获得了奖励
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
  NSLog(@"用户获得了奖励%@",reward);
    if ([_manager.delegate respondsToSelector:@selector(rewardedAd:userDidEarnReward:)]) {
        [_manager.delegate rewardedAd:rewardedAd userDidEarnReward:reward];
    }
}

/**激励广告已经关闭*/
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
  self.rewardedAd = [self createAndLoadRewardedAdWithUnitID:self.rewardUnitID];
    if ([_manager.delegate respondsToSelector:@selector(rewardedAdDidDismiss:)]) {
        [_manager.delegate rewardedAdDidDismiss:rewardedAd];
    }
}

/// 显示奖励广告
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
  NSLog(@"显示奖励广告");
}

/// 奖励广告显示失败
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
  NSLog(@"奖励广告显示失败");
}

#pragma mark - 开屏广告
/**请求一个开屏广告 默认ID*/
- (void)requestLaunchOpenAd {
    self.launchUnitID = nil;
  [GADAppOpenAd loadWithAdUnitID:LaunchADUnitID
                         request:[GADRequest request]
                     orientation:UIInterfaceOrientationPortrait
               completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                 if (error) {
                   NSLog(@"加载开屏广告失败: %@", error);
                   return;
                 }
                 self.appOpenAd = appOpenAd;
               }];
}

/**请求一个开屏广告 自定义广告ID*/
- (void)requestLaunchOpenAdWithUnitID:(NSString *)unitID{
    self.launchUnitID = unitID;
  [GADAppOpenAd loadWithAdUnitID:unitID
                         request:[GADRequest request]
                     orientation:UIInterfaceOrientationPortrait
               completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                 if (error) {
                   NSLog(@"加载开屏广告失败: %@", error);
                   return;
                 }
                 self.appOpenAd = appOpenAd;
               }];
}

/**展示开屏开屏广告*/
- (void)presentTryToLaunchOpenAd {
  GADAppOpenAd *ad = self.appOpenAd;
  self.appOpenAd = nil;
  if (ad) {
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [ad presentFromRootViewController:rootController];

  } else {
    //如果还没有准备好广告，请求一个
      if (_launchUnitID) {
          [_manager requestLaunchOpenAdWithUnitID:_launchUnitID];
      }else{
          [_manager requestLaunchOpenAd];
      }
  }
}
@end
