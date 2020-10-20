//
//  GDTADTool.m
//  GDTMobSample
//
//  Created by 七啸网络 on 2018/4/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//
#define bannerID @"4090812164690039"
#define interstitialID @"2030814134092814"
#define nativeID @"1080215124193862"
#define splashID @"9040714184494018"
#import "GDTADTool.h"

@interface GDTADTool()<GDTMobBannerViewDelegate,GDTMobInterstitialDelegate,GDTNativeAdDelegate,GDTSplashAdDelegate>

@end
@implementation GDTADTool
static NSString *kGDTMobSDKAppId = @"1105344611";


#pragma mark-横幅广告
+(GDTMobBannerView *)GDT_setupBannerView{
    
    GDTMobBannerView * bannerView = [[GDTMobBannerView alloc] initWithAppId:kGDTMobSDKAppId placementId:bannerID];
//    bannerView.currentViewController = self;
    bannerView.interval = 10;
    bannerView.isAnimationOn = YES;
    bannerView.showCloseBtn = YES;
    bannerView.isGpsOn = YES;
//    bannerView.delegate = self;

    return bannerView;
}

#pragma mark - GDTMobBannerViewDelegate
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived{
}

// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error{
}

// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked{
}

// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication{
}


#pragma mark-插页广告
+(GDTMobInterstitial *)GDT_setupInterstitial{
    GDTMobInterstitial * interstitial = [[GDTMobInterstitial alloc] initWithAppId:kGDTMobSDKAppId placementId:interstitialID];
//    interstitial.delegate = self;
    return interstitial;
}
#pragma mark - GDTMobInterstitialDelegate
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    
}

// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial{
}

// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error{
}

// 详解: 插屏广告即将展示回调该函数
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial{
}

// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial{
}

// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial{
}


#pragma mark-原生广告
+(GDTNativeAd *)GDT_setupNativeAD{
//    if (_attached) {
//        [self.adView removeFromSuperview];
//        self.adView = nil;
//        _attached = NO;
//    }
    
    GDTNativeAd * nativeAd = [[GDTNativeAd alloc] initWithAppId:kGDTMobSDKAppId placementId:nativeID];
//    nativeAd.controller = self;
//    nativeAd.delegate = self;
    return nativeAd;
}
#pragma mark - GDTNativeAdDelegate
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
}

-(void)nativeAdFailToLoad:(NSError *)error{
}

/**原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调*/
- (void)nativeAdWillPresentScreen{
}

/**原生广告点击之后应用进入后台时回调*/
- (void)nativeAdApplicationWillEnterBackground{
    NSLog(@"%s",__FUNCTION__);
}

/**原生广告关闭*/
-(void)nativeAdClosed{
    NSLog(@"%s",__FUNCTION__);
}



#pragma mark-开屏广告
/**全屏开屏广告*/
+(GDTSplashAd *)GDT_FullSplashAD:(UIWindow *)window{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:kGDTMobSDKAppId placementId:splashID];
//        splash.delegate = self;
        UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
        if (IS_IPHONEX) {
            splashImage = [UIImage imageNamed:@"SplashX"];
        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
            splashImage = [UIImage imageNamed:@"SplashSmall"];
        }
        UIImage *backgroundImage = [[self class] imageResize:splashImage
                                                   andResizeTo:[UIScreen mainScreen].bounds.size];
        splash.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        splash.fetchDelay = 3;
        [splash loadAdAndShowInWindow:window];
        return splash;
    }
    return nil;
}
+(GDTSplashAd *)GDT_setupSplashADWithBottomView:(UIView *)bottomView  skipView:(UIView *)skipView{
    
    GDTSplashAd * splashAd = [[GDTSplashAd alloc] initWithAppId:kGDTMobSDKAppId placementId:splashID];
//    splashAd.delegate = self;
    splashAd.fetchDelay = 5;
    
    UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
    if (IS_IPHONEX) {
        splashImage = [UIImage imageNamed:@"SplashX"];
    } else if ([UIScreen mainScreen].bounds.size.height == 480) {
        splashImage = [UIImage imageNamed:@"SplashSmall"];
    }
    UIImage *backgroundImage = [[self class] imageResize:splashImage
                                               andResizeTo:[UIScreen mainScreen].bounds.size];
     splashAd.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    if (bottomView==nil) {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height * 0.25)];
        bottomView.backgroundColor = [UIColor orangeColor];
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashLogo"]];
        logo.frame = CGRectMake(0, 0, 311, 47);
        logo.center = bottomView.center;
        [bottomView addSubview:logo];
    }
    
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [splashAd loadAdAndShowInWindow:fK withBottomView:bottomView skipView:skipView];

    return splashAd;
}

+(UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark-GDTSplashAdDelegate
/**开屏成功展示*/
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
}
/**开屏展示失败*/
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
}
/**开屏点击*/
-(void)splashAdClicked:(GDTSplashAd *)splashAd{
}
/**开屏进入后台*/
-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
}

/**开屏将要关闭*/
-(void)splashAdWillClosed:(GDTSplashAd *)splashAd{
}
/**开屏关闭*/
-(void)splashAdClosed:(GDTSplashAd *)splashAd{
//    self.splashAd = nil;
}
/**将要展示全屏开屏*/
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
}
/**已经展示全屏开屏*/
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{
}
/**全屏开屏将要消失*/
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd{
}
/**全屏开屏已经消失*/
-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
}


#pragma mark-原生模板广告
+(GDTNativeExpressAd *)GDT_setupNativeExpressADWithWidth:(CGFloat)width height:(CGFloat)height Adcount:(NSInteger)adCount{
    GDTNativeExpressAd * nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:kGDTMobSDKAppId placementId:@"5030722621265924" adSize:CGSizeMake(width, height)];
//    nativeExpressAd.delegate = self;
    [nativeExpressAd loadAd:adCount];
    return nativeExpressAd;
}

#pragma mark-原生视频模板广告
+(GDTNativeExpressAd *)GDT_setupNativeVideoExpressADWithSize:(CGSize)size autoPlay:(BOOL)autoPlay videoMute:(BOOL)videoMute adCount:(NSInteger)adCount{
    
    GDTNativeExpressAd * nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:kGDTMobSDKAppId placementId:@"1020922903364636" adSize:CGSizeEqualToSize(size, CGSizeZero)?CGSizeMake(ScreenWidth,50):size];
//    nativeExpressAd.delegate = self;
    nativeExpressAd.videoAutoPlayOnWWAN = autoPlay;
    nativeExpressAd.videoMuted = videoMute;
    [nativeExpressAd loadAd:adCount];
    
    return nativeExpressAd;
}
#pragma mark - GDTNativeExpressAdDelegete
/**拉取广告成功的回调*/
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    
    //    self.expressAdViews = [NSArray arrayWithArray:views];
    //    if (self.expressAdViews.count) {
    //        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
    //            expressView.controller = self;
    //            [expressView render];
    //        }];
    //    }
    //    [self.tableView reloadData];
}

/**渲染广告失败的回调*/
- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
}

/**拉取原生模板广告失败*/
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
}
/**渲染广告成功*/
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    //    [self.tableView reloadData];
}
/**原生模板广告的点击*/
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    
}
/**原生模板广告关闭*/
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    
}

@end
