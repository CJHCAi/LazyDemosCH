//
//  EmptyViewController.m
//  GDTTestDemo
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import "InterstitialViewController.h"
#import "GDTAppDelegate.h"
#import "GDTMobInterstitial.h"

@interface InterstitialViewController() <GDTMobInterstitialDelegate>

@property (nonatomic, strong) GDTMobInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UITextField *positionID;
@property (weak, nonatomic) IBOutlet UILabel *interstitialStateLabel;

@end

@implementation InterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


#pragma mark - event response
- (IBAction)loadAd:(id)sender {
    NSLog(@"load");
    if(self.interstitial) {
        self.interstitial.delegate = nil;
    }
    self.interstitial = [[GDTMobInterstitial alloc] initWithAppId:kGDTMobSDKAppId placementId:self.positionID.text];
    self.interstitial.delegate = self;
    
    [self.interstitial loadAd];

}

- (IBAction)showAd:(id)sender
{
    [self.interstitial presentFromRootViewController:self];
}

#pragma mark - GDTMobInterstitialDelegate
// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Loaded." ];
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@,Error : %@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded.",error ];
    NSLog(@"interstitial fail to load, Error : %@",error);
}

// 插屏广告将要展示回调
//
// 详解: 插屏广告即将展示回调该函数
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present." ];
}

// 插屏广告视图展示成功回调
//
// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." ];
}

// 插屏广告展示结束回调
//
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented." ];
}

// 应用进入后台时回调
//
// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background." ];
}



@end
