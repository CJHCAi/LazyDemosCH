//
//  BaiduMobAdNormalInterstitialViewController.m
//  XAdSDKDevSample
//
//  Created by LiYan on 16/4/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaiduMobAdNormalInterstitialViewController.h"
#define kScreenWidth self.view.frame.size.width
#define kCustomIntWidth 300
#define kCustomIntHeight 300
@interface BaiduMobAdNormalInterstitialViewController ()
@property (nonatomic, assign) int curType;
@property (nonatomic, retain) UIView *customAdView;
@property (nonatomic, retain) UIButton *loadButton;
@property (nonatomic, retain) UIButton *showButton;
@property (nonatomic, retain) UIButton *loadCustomButtonWithCount;
@property (nonatomic, retain) UIButton *loadCustomButtonWithNoCount;
@property (nonatomic, retain) UIButton *loadDirectlyButton;

@end

@implementation BaiduMobAdNormalInterstitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _curType = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadBtn.frame = CGRectMake(20, 100, 200, 50);
    [loadBtn setTitle:@"请求全屏插屏" forState:UIControlStateNormal];
    loadBtn.tag = 101;
    [loadBtn addTarget:self action:@selector(pressToLoadAd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    self.loadButton = loadBtn;
    
    UIButton *loadCustomButtonWithCount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadCustomButtonWithCount.frame = CGRectMake(20, 200, 200, 50);
    [loadCustomButtonWithCount setTitle:@"请求前贴插屏" forState:UIControlStateNormal];
    loadCustomButtonWithCount.tag = 102;
    [loadCustomButtonWithCount addTarget:self action:@selector(pressToLoadAd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadCustomButtonWithCount];
    self.loadCustomButtonWithCount = loadCustomButtonWithCount;
    
    UIButton *loadCustomButtonWithNoCount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadCustomButtonWithNoCount.frame = CGRectMake(20, 300, 200, 50);
    [loadCustomButtonWithNoCount setTitle:@"请求暂停插屏" forState:UIControlStateNormal];
    loadCustomButtonWithNoCount.tag = 103;
    [loadCustomButtonWithNoCount addTarget:self action:@selector(pressToLoadAd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadCustomButtonWithNoCount];
    self.loadCustomButtonWithNoCount = loadCustomButtonWithNoCount;
    
}

- (void)pressToLoadAd:(UIButton *)btn {
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    self.interstitialAdView = [[[BaiduMobAdInterstitial alloc]init]autorelease];
    self.interstitialAdView.AdUnitTag = @"2058554";
    self.interstitialAdView.delegate = self;
    switch (btn.tag) {
        case 101:
            self.interstitialAdView.interstitialType = BaiduMobAdViewTypeInterstitialOther;
            [self.interstitialAdView load];
            _curType = 1;
            break;
        case 102:
            self.interstitialAdView.interstitialType = BaiduMobAdViewTypeInterstitialBeforeVideo;
            [self.interstitialAdView loadUsingSize:CGRectMake(0, 0, kCustomIntWidth, kCustomIntHeight)];
            _curType = 2;
            break;
        case 103:
            self.interstitialAdView.interstitialType = BaiduMobAdViewTypeInterstitialPauseVideo;
            [self.interstitialAdView loadUsingSize:CGRectMake(0, 0, kCustomIntWidth, kCustomIntHeight)];
            _curType = 3;
            break;
        default:
            break;
    }
}

- (void)pressToShowAd:(UIButton *)btn {
    if (self.interstitialAdView.isReady) {
        if (_curType == 1) {
            [self.interstitialAdView presentFromRootViewController:self];
        } else {
            UIView *customAdView = [[[UIView alloc]initWithFrame:CGRectMake(0, 150, kCustomIntWidth, kCustomIntHeight)] autorelease];
            customAdView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:customAdView];
            [self.interstitialAdView presentFromView:customAdView];
            self.customAdView = customAdView;
        }
    } else {
        NSLog(@"not ready yet");
    }
}

- (NSString *)publisherId {
    return @"ccb60059";
}

- (BOOL) enableLocation {
    return NO;
}

- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial {
    NSLog(@"load ready!");
    if (_curType != 4) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"加载成功"
                                                     message:@"点击显示广告"
                                                    delegate:self
                                           cancelButtonTitle:@"ok"
                                           otherButtonTitles: nil];
        [alv show];
        [alv release];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self pressToShowAd:nil];
    
}/**
  *  广告预加载失败
  */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial {
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"加载失败"
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:@"ok"
                                       otherButtonTitles: nil];
    [alv show];
    [alv release];}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial {
    NSLog(@"will show");
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial {
    NSLog(@"succ show");
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason {
    NSLog(@"fail rea %d", reason);
}

/**
 *  广告展示被用户点击时的回调
 */
- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial {
    NSLog(@"did click");
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial{
    NSLog(@"succ dismiss");
    if (_curType == 2 || _curType == 3) {
        [self.customAdView removeFromSuperview];
    }
    self.interstitialAdView = nil;
}

/**
 *  广告详情页被关闭
 */
- (void)interstitialDidDismissLandingPage:(BaiduMobAdInterstitial *)interstitial {
    NSLog(@"succ close lp");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _interstitialAdView.delegate = nil;
    [_interstitialAdView release];
    _interstitialAdView = nil;
    if (_customAdView) {
        [_customAdView removeFromSuperview];
    }
    [super dealloc];
}


@end
