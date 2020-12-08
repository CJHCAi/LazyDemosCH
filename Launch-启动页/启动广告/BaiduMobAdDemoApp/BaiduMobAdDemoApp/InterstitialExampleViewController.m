//
//  InterstitialExampleViewController.m
//  BaiduMobAdDemoApp
//
//  Created by LiYan on 16/6/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "InterstitialExampleViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdInterstitial.h"
@interface InterstitialExampleViewController () <BaiduMobAdInterstitialDelegate>

@property (nonatomic, retain) UITextView *textView1;
@property (nonatomic, retain) UITextView *textView2;

@property (nonatomic, retain) BaiduMobAdInterstitial *interstitialAdView;

@end

@implementation InterstitialExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化就加载广告, 需要的时候再展示.
    //本示例中是在执行"滑动到下一章"动作时展示.
    [self configAd];
    
    [self configTextView];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.interstitialAdView.delegate = nil;
    self.interstitialAdView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configAd {
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    BaiduMobAdInterstitial *ints = [[[BaiduMobAdInterstitial alloc]init]autorelease];
    ints.delegate = self;
    ints.interstitialType = BaiduMobAdViewTypeInterstitialOther;
    ints.AdUnitTag = @"2058554";
    [ints load];
    self.interstitialAdView = ints;
}

- (NSString *)publisherId {
    return @"ccb60059";
}

- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial {
    NSLog(@"load success");
}

- (void)configTextView {
    CGRect textViewRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    NSString *text1 = @"百度插屏广告使用场景示例\n\n当前为小说阅读某章最后一页, 希望在切换到下一章的时候展示插屏广告. \n需要在滚动到当页的时候执行插屏广告预加载动作, 一般来说广告加载时间＜阅读时间. 然后在切换下一章的时候检测一下广告状态, 如果isReady则直接展示出来广告, 这样可以使用户不感知广告加载造成的卡顿.\n\n同理, 插屏广告也可以使用在诸如: 应用暂停/游戏闯关、失败/图书翻页/翻图 等典型场景中. \n\n详细使用方法可参见BaiduMobAdNormalInterstitialViewController中的内容. \n\n现在你可以左滑查看下一章, 或者返回demo查看更多内容.";
    NSString *text2 = @"百度插屏广告使用场景示例\n\n当前为小说阅读的下一章. 需注意的是插屏有过期时间半小时, 如果请求超过半小时还没有展现的话则该请求失败, 需要重新请求.\n\n另外, 每次插屏展示结束后都需要重新加载, 没有轮播.\n\n现在你可以右滑返回上一页, 或者返回demo查看更多内容.";
    
    UITextView *tv1 = [[[UITextView alloc]init]autorelease];
    tv1.frame = textViewRect;
    tv1.text = text1;
    tv1.editable = NO;
    UISwipeGestureRecognizer *swipGes1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(swipe1)];
    swipGes1.direction = UISwipeGestureRecognizerDirectionLeft;
    [tv1 addGestureRecognizer:swipGes1];
    [self.view addSubview:tv1];
    self.textView1 = tv1;
    
    UITextView *tv2 = [[[UITextView alloc]init]autorelease];
    tv2.frame = textViewRect;
    tv2.text = text2;
    tv2.editable = NO;
    UISwipeGestureRecognizer *swipGes2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(swipe2)];
    swipGes2.direction = UISwipeGestureRecognizerDirectionRight;
    [tv2 addGestureRecognizer:swipGes2];
    self.textView2 = tv2;
}

- (void)swipe1 {
    NSLog(@"show ad now!");
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.textView1 removeFromSuperview];
        [self.view addSubview:self.textView2];
    }];
    
    if (self.interstitialAdView.isReady) {
        [self.interstitialAdView presentFromRootViewController:self];
    } else {
        NSLog(@"ad not ready");
        return;
    }
}

- (void)swipe2 {
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.textView2 removeFromSuperview];
        [self.view addSubview:self.textView1];
    }];
    
    [self configAd];
}

@end
