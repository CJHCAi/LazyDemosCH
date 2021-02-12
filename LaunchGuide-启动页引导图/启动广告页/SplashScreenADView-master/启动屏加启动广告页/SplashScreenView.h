//
//  SplashScreenView.h
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/9.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adImageUrl";
static NSString *const adDeadline = @"adDeadline";
@interface SplashScreenView : UIView

/** 显示广告页面方法*/
- (void)showSplashScreenWithTime:(NSInteger )ADShowTime;

/** 广告图的显示时间*/
@property (nonatomic, assign) NSInteger ADShowTime;

/** 图片路径*/
@property (nonatomic, copy) NSString *imgFilePath;

/** 图片对应的url地址*/
@property (nonatomic, copy) NSString *imgLinkUrl;

/** 广告图的有效时间*/
@property (nonatomic, copy) NSString *imgDeadline;
@end
