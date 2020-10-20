//
//  Copyright (C) 2018 Google, Inc.
//
//  CustomControlsView.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import GoogleMobileAds;
 //自定义的视频控件
@interface CustomControlsView : UIView<GADVideoControllerDelegate>
//重置控制状态,并让控制视图初始静音状态。
- (void)resetWithStartMuted:(BOOL)startMuted;

@property(nonatomic, weak) GADVideoController *controller;

@end
