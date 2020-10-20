//
//  CHNativeView.m
//  MeiTuDemo
//
//  Created by 七啸网络 on 2018/5/23.
//  Copyright © 2018年 zhuofeng. All rights reserved.
//
#define NativeID @"ca-app-pub-3940256099942544/3986624511"
//自定义模板ID
static NSString *const TestNativeCustomTemplateID = @"10104090";

#import "CHNativeView.h"
#import "SimpleNativeAdView.h"
@interface CHNativeView()<GADUnifiedNativeAdLoaderDelegate,
GADVideoControllerDelegate,GADUnifiedNativeAdDelegate>
@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;
@property(nonatomic,strong)SimpleNativeAdView * customNativeView;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic,strong)UIButton * refreshButton;
@property(nonatomic,assign)BOOL isUnified;
@property(nonatomic,assign)BOOL isCustom;
@property(nonatomic,strong)NSMutableArray *adTypes;

@end

@implementation CHNativeView

-(instancetype)initWithFrame:(CGRect)frame UnifiedNative:(BOOL)isUnified CustomTemplate:(BOOL)isCustom {
    
    if (self=[super initWithFrame:frame]) {
        _isUnified=isUnified;
        _isCustom=isCustom;
        self.adTypes = [[NSMutableArray alloc] init];
        if (isUnified) {
            [_adTypes addObject:kGADAdLoaderAdTypeUnifiedNative];
        }
        if (isCustom) {
            [_adTypes addObject:kGADAdLoaderAdTypeNativeCustomTemplate];
        }
        
        if (!_adTypes.count) {
            NSLog(@"Error:至少选择一种广告加载.");
            return nil;
        }

        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.alpha=0;
    
    if (_isUnified) {
        NSArray * nibObjects =[[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
        [self setUnifiedAdView:[nibObjects firstObject]];

    }else if (_isCustom){
        SimpleNativeAdView *simpleNativeAdView =
        [[NSBundle mainBundle] loadNibNamed:@"SimpleNativeAdView" owner:nil options:nil].firstObject;
        [self setCustomAdView:simpleNativeAdView];

    }
    [self refreshAd:nil];

}
/**统一模板*/
- (void)setUnifiedAdView:(GADUnifiedNativeAdView *)view {

    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = view;
    view.frame=self.bounds;
    view.backgroundColor=[UIColor clearColor];
    [self addSubview:view];
    
}

/**自定义模板*/
- (void)setCustomAdView:(SimpleNativeAdView *)view {
    [self.nativeAdView removeFromSuperview];
    self.customNativeView = view;
    view.frame=self.bounds;
    view.backgroundColor=[UIColor clearColor];
    [self addSubview:view];
    
}



-(void)refreshAd:(UIButton *)Button{
    Button.enabled = NO;
    _refreshButton=Button;
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = YES;
    videoOptions.customControlsRequested=NO;
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:NativeID
                                       rootViewController:(UIViewController *)[self superclass] adTypes:_adTypes options:@[ videoOptions ]];
    
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
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


#pragma mark GADAdLoaderDelegate
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
    self.refreshButton.enabled = YES;
}

#pragma mark GADNativeCustomTemplateAdLoaderDelegate
/**自定义模板广告*/
- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
    
    self.refreshButton.enabled = YES;
    //自定义本地广告视图填充其资产。
    [_customNativeView populateWithCustomNativeAd:nativeCustomTemplateAd];
}

- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
    return @[ TestNativeCustomTemplateID ];
}

#pragma mark GADUnifiedNativeAdLoaderDelegate
/**统一原生广告*/
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd{
    
    self.refreshButton.enabled = YES;
    
    GADUnifiedNativeAdView * nativeAdView = self.nativeAdView;
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
    } else {
        nativeAdView.mediaView.hidden = YES;
        nativeAdView.imageView.hidden = NO;
        GADNativeAdImage *firstImage = nativeAd.images.firstObject;
        ((UIImageView *)nativeAdView.imageView).image = firstImage.image;
        
    }
    
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
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;

    }];
}

#pragma mark GADVideoControllerDelegate
/**视频播放结束*/
- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {

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
