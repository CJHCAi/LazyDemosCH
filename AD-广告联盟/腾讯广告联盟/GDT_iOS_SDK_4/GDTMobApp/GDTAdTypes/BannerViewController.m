//
//  BannerViewController.m
//  GDTTestDemo
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import "BannerViewController.h"
#import "GDTMobBannerView.h"
#import "GDTAppDelegate.h"

@interface BannerViewController() <GDTMobBannerViewDelegate>

@property (nonatomic, strong) GDTMobBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITextField *placementIdText;
@property (weak, nonatomic) IBOutlet UITextField *refreshIntervalText;
@property (weak, nonatomic) IBOutlet UISwitch *gpsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *closeBtnSwitch;

@end

@implementation BannerViewController

#pragma mark - lifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self clickLoadAd:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - property getter
- (GDTMobBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[GDTMobBannerView alloc] initWithAppId:kGDTMobSDKAppId placementId:self.placementIdText.text];
        _bannerView.currentViewController = self;
        _bannerView.interval = [self.refreshIntervalText.text intValue];
        _bannerView.isAnimationOn = self.animationSwitch.on;
        _bannerView.showCloseBtn = self.closeBtnSwitch.on;
        _bannerView.isGpsOn = self.gpsSwitch.on;
        _bannerView.delegate = self;
    }
    return _bannerView;
}

#pragma mark - event repsonse
- (IBAction)clickLoadAd:(id)sender {
    [self clickRemoveAd:nil];
    [self.view addSubview:self.bannerView];
    //使用 Auto Layout 布局，也可使用 frame 布局。
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.bannerView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:IS_IPHONEX?88:64],
                           [NSLayoutConstraint constraintWithItem:self.bannerView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:self.bannerView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:0]
                           ]];
    [self.bannerView addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:50]];
    [self.bannerView loadAdAndShow];
}

- (IBAction)clickRemoveAd:(id)sender {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}


#pragma mark - GDTMobBannerViewDelegate
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"banner Received");
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    NSLog(@"banner failed to Received : %@",error);
}

// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked
{
    NSLog(@"banner clicked");
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"banner leave application");
}


-(void)bannerViewDidDismissFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewWillDismissFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewWillPresentFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewDidPresentFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

@end
