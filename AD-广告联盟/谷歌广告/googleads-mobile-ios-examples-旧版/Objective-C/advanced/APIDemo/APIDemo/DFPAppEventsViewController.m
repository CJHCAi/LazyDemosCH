//
//  Copyright (C) 2015 Google, Inc.
//
//  DFPAppEventsViewController.m
//  APIDemo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

#import "DFPAppEventsViewController.h"

#import "Constants.h"

/// DFP - App Events 演示了处理GADAppEventDelegate应用事件消息发送的DFP横幅。
@interface DFPAppEventsViewController () <GADAppEventDelegate>

/// The DFP banner view.
@property(nonatomic, weak) IBOutlet DFPBannerView *bannerView;

@end

@implementation DFPAppEventsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.bannerView.adUnitID = kDFPAppEventsAdUnitID;
  self.bannerView.rootViewController = self;
  self.bannerView.appEventDelegate = self;

  DFPRequest *request = [DFPRequest request];
  [self.bannerView loadRequest:request];
}

#pragma mark - GADAppEventDelegate

/// Called when the banner receives an app event.
- (void)adView:(GADBannerView *)banner
    didReceiveAppEvent:(NSString *)name
              withInfo:(NSString *)info {
  
  if ([name isEqual:@"color"]) {
    if ([info isEqual:@"blue"]) {
      self.view.backgroundColor = [UIColor blueColor];
    } else if ([info isEqual:@"red"]) {
      self.view.backgroundColor = [UIColor redColor];
    } else if ([info isEqual:@"green"]) {
      self.view.backgroundColor = [UIColor greenColor];
    }
  }
}

@end
