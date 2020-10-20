//
//  Copyright (C) 2018 Google, Inc.
//
//  SimpleNativeAdView.m
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

#import "SimpleNativeAdView.h"

static NSString *const SimpleNativeAdViewHeadlineKey = @"Headline";

static NSString *const SimpleNativeAdViewMainImageKey = @"MainImage";

static NSString *const SimpleNativeAdViewCaptionKey = @"Caption";

@interface SimpleNativeAdView ()

@property(nonatomic, strong) GADNativeCustomTemplateAd *customNativeAd;

@end

@implementation SimpleNativeAdView

- (void)awakeFromNib {
  [super awakeFromNib];

  [self.headlineView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performClickOnHeadline)]];
  self.headlineView.userInteractionEnabled = YES;
}

- (void)performClickOnHeadline {
  [self.customNativeAd performClickOnAssetWithKey:SimpleNativeAdViewHeadlineKey];
}

- (void)populateWithCustomNativeAd:(GADNativeCustomTemplateAd *)customNativeAd {
  self.customNativeAd = customNativeAd;
    
    __weak typeof(self) weakSelf = self;
  [self.customNativeAd setCustomClickHandler:^(NSString *assetID) {
    [[[UIAlertView alloc] initWithTitle:@"Custom Click"
                                message:@"You just clicked on the headline!"
                               delegate:weakSelf
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  }];
   //填充自定义本地广告资产。
  self.headlineView.text = [customNativeAd stringForKey:SimpleNativeAdViewHeadlineKey];
  self.captionView.text = [customNativeAd stringForKey:SimpleNativeAdViewCaptionKey];

  for (UIView *subview in self.mainPlaceholder.subviews) {
    [subview removeFromSuperview];
  }

  UIView *mainView = nil;
  if (customNativeAd.videoController.hasVideoContent) {
    mainView = customNativeAd.mediaView;
  } else {
    UIImage *image = [customNativeAd imageForKey:SimpleNativeAdViewMainImageKey].image;
    mainView = [[UIImageView alloc] initWithImage:image];
  }
   mainView.frame=self.bounds;
  [self.mainPlaceholder addSubview:mainView];

  
}

@end
