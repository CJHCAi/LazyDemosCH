//
//  BaiduMobAdNormalInterstitialViewController.h
//  XAdSDKDevSample
//
//  Created by LiYan on 16/4/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdSDK/BaiduMobAdInterstitial.h"

@interface BaiduMobAdNormalInterstitialViewController : UIViewController
<BaiduMobAdInterstitialDelegate>

@property (nonatomic, retain) BaiduMobAdInterstitial *interstitialAdView;

@end
