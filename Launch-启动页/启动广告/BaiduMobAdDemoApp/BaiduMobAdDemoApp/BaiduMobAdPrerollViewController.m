//
//  BaiduMobAdPrerollViewController.m
//  XAdSDKDevSample
//
//  Created by lishan04 on 16/5/5.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaiduMobAdPrerollViewController.h"

@interface BaiduMobAdPrerollViewController ()
@property (nonatomic, retain) BaiduMobAdPreroll *prerollAd;
@property (nonatomic, retain) UIButton *button;
@end

@implementation BaiduMobAdPrerollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 330, 200, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"点击加载视频贴片广告" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.hidden = NO;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];

    self.button = button;
    [self loadAd];
}

- (void)loadAd {
    self.button.userInteractionEnabled = NO;
    UIView *baseview = [[UIView alloc]initWithFrame:CGRectMake(10, 64, 320, 240)];
    [self.view addSubview:baseview];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    self.prerollAd = [[[BaiduMobAdPreroll alloc]init]autorelease];
    self.prerollAd.publisherId = @"ccb60059";
    self.prerollAd.adId = @"2058633";//需要为视频贴片广告位
    self.prerollAd.renderBaseView = baseview;
    self.prerollAd.delegate = self;
    [self.prerollAd request];
}

-(void)dealloc {
    self.prerollAd.delegate = nil;
    self.prerollAd = nil;
    [super dealloc];
}

-(BOOL) enableLocation {
    return YES;
}

- (void)didAdReady:(BaiduMobAdPreroll *)preroll {
    NSLog(@"didAdReady");
}

- (void)didAdFailed:(BaiduMobAdPreroll *)preroll withError:(BaiduMobFailReason) reason{
    NSLog(@"didAdFailed");
    self.button.userInteractionEnabled = YES;
}

- (void)didAdStart:(BaiduMobAdPreroll *)preroll {
    NSLog(@"didAdStart");
}

- (void)didAdFinish:(BaiduMobAdPreroll *)preroll {
    NSLog(@"didAdFinish");
    self.button.userInteractionEnabled = YES;
}

- (void)didAdClicked:(BaiduMobAdPreroll *)preroll {
    NSLog(@"didAdClicked");
}

- (void)didDismissLandingPage {
    NSLog(@"didDismissLandingPage");
    
}

@end
