//
//  Copyright (C) 2015 Google, Inc.
//
//  DFPFluidAdSizeViewController.m
//  APIDemo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

#import "DFPFluidAdSizeViewController.h"

#import "Constants.h"

/// DFP - Fluid Ad Size
//演示了使用液体广告——广告大小横跨全宽的容器,/ / /一个高度动态取决于广告。
@interface DFPFluidAdSizeViewController ()

@property(nonatomic, weak) IBOutlet DFPBannerView *bannerView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *bannerViewWidthConstraint;
@property(nonatomic, weak) IBOutlet UILabel *bannerWidthLabel;
@property(nonatomic, strong) NSArray<NSNumber *> *bannerWidths;

/// Current array index.
@property(nonatomic, assign) NSInteger currentIndex;

@end

@implementation DFPFluidAdSizeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.bannerWidths = @[ @200, @250, @320 ];
  self.currentIndex = 0;

  self.bannerView.adUnitID = kDFPFluidAdSizeAdUnitID;
  self.bannerView.rootViewController = self;
  self.bannerView.adSize = kGADAdSizeFluid;
  [self.bannerView loadRequest:[DFPRequest request]];
}


- (IBAction)changeBannerWidth:(id)sender {
  CGFloat newWidth = self.bannerWidths[self.currentIndex % self.bannerWidths.count].floatValue;
  self.currentIndex += 1;
  self.bannerViewWidthConstraint.constant = newWidth;
  self.bannerWidthLabel.text = [[NSString alloc] initWithFormat:@"%.0f points", newWidth];
}

@end
