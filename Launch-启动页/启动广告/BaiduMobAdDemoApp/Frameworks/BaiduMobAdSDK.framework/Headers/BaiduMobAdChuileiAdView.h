//
//  BaiduMobAdChuileiAdView.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import "BaiduMobAdNativeAdView.h"
@class BaiduMobAdChuileiAdObject;

@interface BaiduMobAdChuileiAdView : BaiduMobAdNativeAdView

-(id)initWithFrame:(CGRect)frame
             title:(UILabel *) titleLabel
              mainImage:(UIImageView *) mainView;
/*
* 根据广告内容，在广告视图上缓存和展示广告,同时关联广告视图和点击展现行为
* object 包含文字内容和物料地址
*/
- (void)loadAndDisplayAdWithObject:(BaiduMobAdChuileiAdObject *)object completion:(BaiduMobAdViewCompletionBlock)completionBlock;
/**
 * 发送展现日志
 */
- (void)trackImpression;
@end
