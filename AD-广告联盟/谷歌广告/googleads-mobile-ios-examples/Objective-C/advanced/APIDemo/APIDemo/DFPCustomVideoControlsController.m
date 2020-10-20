//
//  Copyright (C) 2018 Google, Inc.
//
//  DFPCustomVideoControlsController.m
//  APIDemo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "DFPCustomVideoControlsController.h"

static NSString *const TestAdUnit = @"/6499/example/native-video";
static NSString *const TestNativeCustomTemplateID = @"10104090";

@interface DFPCustomVideoControlsController () <GADUnifiedNativeAdLoaderDelegate,
                                                GADNativeCustomTemplateAdLoaderDelegate>

@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong) UIView *nativeAdView;

@end

@implementation DFPCustomVideoControlsController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.versionLabel.text = [GADRequest sdkVersion];
  [self refreshAd:nil];
}

- (IBAction)refreshAd:(id)sender {
  NSMutableArray *adTypes = [[NSMutableArray alloc] init];
  if (self.unifiedNativeAdSwitch.on) {
    [adTypes addObject:kGADAdLoaderAdTypeUnifiedNative];
  }
  if (self.customNativeAdSwitch.on) {
    [adTypes addObject:kGADAdLoaderAdTypeNativeCustomTemplate];
  }

  if (!adTypes.count) {
    NSLog(@"Error: You must specify at least one ad type to load.");
    return;
  }

  GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
  videoOptions.startMuted = self.startMutedSwitch.on;
  videoOptions.customControlsRequested = self.requestCustomControlsSwitch.on;

  self.refreshButton.enabled = NO;
  self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:TestAdUnit
                                     rootViewController:self
                                                adTypes:adTypes
                                                options:@[ videoOptions ]];
    //自定义控制器视图
  [self.customControlsView resetWithStartMuted:videoOptions.startMuted];
    
  self.adLoader.delegate = self;
  [self.adLoader loadRequest:[DFPRequest request]];
}

- (void)setAdView:(UIView *)view {
  // Remove previous ad view.
  [self.nativeAdView removeFromSuperview];
  self.nativeAdView = view;

  [self.placeholderView addSubview:view];
    
    
  [self.nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
  NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
  [self.placeholderView
      addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
                                                             options:0
                                                             metrics:nil
                                                               views:viewDictionary]];
  [self.placeholderView
      addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
                                                             options:0
                                                             metrics:nil
                                                               views:viewDictionary]];
}

#pragma mark GADAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"%@ failed with error: %@", adLoader, [error localizedDescription]);
  self.refreshButton.enabled = YES;
}

#pragma mark GADNativeCustomTemplateAdLoaderDelegate
- (void)adLoader:(GADAdLoader *)adLoader
    didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {

    self.refreshButton.enabled = YES;
 //创建并将广告视图层次结构。
  SimpleNativeAdView *simpleNativeAdView =
      [[NSBundle mainBundle] loadNibNamed:@"SimpleNativeAdView" owner:nil options:nil].firstObject;
  [self setAdView:simpleNativeAdView];
   //自定义本地广告视图填充其资产。
  [simpleNativeAdView populateWithCustomNativeAd:nativeCustomTemplateAd];

  self.customControlsView.controller = nativeCustomTemplateAd.videoController;
}

- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
  return @[ TestNativeCustomTemplateID ];
}

#pragma mark GADUnifiedNativeAdLoaderDelegate
/**统一原生广告*/
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {

    self.refreshButton.enabled = YES;
  //创建并将广告视图层次结构。
  GADUnifiedNativeAdView *nativeAdView =
      [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil].firstObject;
  [self setAdView:nativeAdView];

  nativeAdView.nativeAd = nativeAd;
  //填充本地广告视图与本地广告资产
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
  ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
  [((UIButton *)nativeAdView.callToActionView)setTitle:nativeAd.callToAction
                                              forState:UIControlStateNormal];

  if (nativeAd.videoController.hasVideoContent) {
    nativeAdView.mediaView.hidden = NO;
    nativeAdView.imageView.hidden = YES;

   //这个程序使用一个固定宽度GADMediaView和改变它的高度/ /匹配长宽比的视频显示。
    if (nativeAd.videoController.aspectRatio > 0) {
      NSLayoutConstraint *heightConstraint =
          [NSLayoutConstraint constraintWithItem:nativeAdView.mediaView
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:nativeAdView.mediaView
                                       attribute:NSLayoutAttributeWidth
                                      multiplier:(1 / nativeAd.videoController.aspectRatio)
                                        constant:0];
      heightConstraint.active = YES;
    }
  } else {
    nativeAdView.mediaView.hidden = YES;
    nativeAdView.imageView.hidden = NO;

    GADNativeAdImage *firstImage = nativeAd.images.firstObject;
    ((UIImageView *)nativeAdView.imageView).image = firstImage.image;
  }
  self.customControlsView.controller = nativeAd.videoController;

    //这些资产不能保证,首先,应该检查。
  ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
  nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

  ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating];
  nativeAdView.starRatingView.hidden = nativeAd.starRating ? NO : YES;

  ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
  nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;

  ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
  nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;

  ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
  nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;
 //为了SDK处理触摸事件,用户交互/ /应该禁用。
  nativeAdView.callToActionView.userInteractionEnabled = NO;
}
//返回nil如果评级小于3.5星。
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

@end
