//
//  BaiduMobAdNativeWebView.h
//  BaiduMobNativeSDK
//
//  Created by lishan04 on 15/11/17.
//  Copyright © 2015年 lishan04. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaiduMobAdNativeAdObject;
@interface BaiduMobAdNativeWebView : UIWebView
- (instancetype)initWithFrame:(CGRect)frame andObject:(BaiduMobAdNativeAdObject *)object;

@end
