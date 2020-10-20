// Copyright (C) 2015 Google, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ViewController.h"

// Native Advanced ad unit ID for testing.
static NSString *const TestAdUnit = @"ca-app-pub-3940256099942544/3986624511";

@interface ViewController () <GADUnifiedNativeAdLoaderDelegate,
                              GADVideoControllerDelegate,
                              GADUnifiedNativeAdDelegate>


@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.versionLabel.text = [GADRequest sdkVersion];

  NSArray *nibObjects =
      [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
  [self setAdView:[nibObjects firstObject]];
  [self refreshAd:nil];
}

- (IBAction)refreshAd:(id)sender {
  // Loads an ad for unified native ad.
  self.refreshButton.enabled = NO;

  GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
  videoOptions.startMuted = self.startMutedSwitch.on;

  self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:TestAdUnit
                                     rootViewController:self
                                                adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                options:@[ videoOptions ]];
  self.adLoader.delegate = self;
  [self.adLoader loadRequest:[GADRequest request]];
  self.videoStatusLabel.text = @"";
}

- (void)setAdView:(GADUnifiedNativeAdView *)view {
  // Remove previous ad view.
  [self.nativeAdView removeFromSuperview];
  self.nativeAdView = view;

  // Add new ad view and set constraints to fill its container.
  [self.nativeAdPlaceholder addSubview:view];
    
    
    
  [self.nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];

  NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDictionary]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDictionary]];
}

- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
  double starRating = numberOfStars.doubleValue;
  if (starRating >= 5) {
    return [UIImage imageNamed:@"stars_5"];
  } else if (starRating >= 4.5) {
    return [UIImage imageNamed:@"stars_4_5"];
  } else if (starRating >= 4) {
    return [UIImage imageNamed:@"stars_4"];
  } else if (starRating >= 3.5) {
    return [UIImage imageNamed:@"stars_3_5"];
  } else {
    return nil;
  }
}

#pragma mark GADAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"%@ failed with error: %@", adLoader, error);
  self.refreshButton.enabled = YES;
}

#pragma mark GADUnifiedNativeAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd{
  
    self.refreshButton.enabled = YES;

  GADUnifiedNativeAdView *nativeAdView = self.nativeAdView;
   //当视频广告加载时取消设置的高度约束
  self.heightConstraint.active = NO;
  nativeAdView.nativeAd = nativeAd;
  nativeAd.delegate = self;

    //填充
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
  ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
  [((UIButton *)nativeAdView.callToActionView)setTitle:nativeAd.callToAction
                                              forState:UIControlStateNormal];
    
    //包含视频
    if (nativeAd.videoController.hasVideoContent) {
    nativeAdView.mediaView.hidden = NO;
    nativeAdView.imageView.hidden = YES;

    if (nativeAd.videoController.aspectRatio > 0) {
      self.heightConstraint =
          [NSLayoutConstraint constraintWithItem:nativeAdView.mediaView
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:nativeAdView.mediaView
                                       attribute:NSLayoutAttributeWidth
                                      multiplier:(1 / nativeAd.videoController.aspectRatio)
                                        constant:0];
      self.heightConstraint.active = YES;
    }


    nativeAd.videoController.delegate = self;
    self.videoStatusLabel.text = @"Ad contains a video asset.";
  } else {
    nativeAdView.mediaView.hidden = YES;
    nativeAdView.imageView.hidden = NO;

    GADNativeAdImage *firstImage = nativeAd.images.firstObject;
    ((UIImageView *)nativeAdView.imageView).image = firstImage.image;

    self.videoStatusLabel.text = @"Ad does not contain a video.";
  }

    //填充
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
  if (nativeAd.icon != nil) {
    nativeAdView.iconView.hidden = NO;
  } else {
    nativeAdView.iconView.hidden = YES;
  }

  ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating];
  if (nativeAd.starRating) {
    nativeAdView.starRatingView.hidden = NO;
  } else {
    nativeAdView.starRatingView.hidden = YES;
  }

  ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
  if (nativeAd.store) {
    nativeAdView.storeView.hidden = NO;
  } else {
    nativeAdView.storeView.hidden = YES;
  }

  ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
  if (nativeAd.price) {
    nativeAdView.priceView.hidden = NO;
  } else {
    nativeAdView.priceView.hidden = YES;
  }

  ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
  if (nativeAd.advertiser) {
    nativeAdView.advertiserView.hidden = NO;
  } else {
    nativeAdView.advertiserView.hidden = YES;
  }
  //为了SDK处理触摸事件,用户交互/ /应该禁用。
  nativeAdView.callToActionView.userInteractionEnabled = NO;
}

#pragma mark GADVideoControllerDelegate

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
  self.videoStatusLabel.text = @"Video playback has ended.";
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
