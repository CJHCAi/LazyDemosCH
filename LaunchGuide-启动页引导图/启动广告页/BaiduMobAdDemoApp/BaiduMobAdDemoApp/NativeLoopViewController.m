//
//  NativeLoopViewController.m
//  BaiduMobAdDemoApp
//
//  Created by LiYan on 16/6/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "NativeLoopViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdDelegate.h"
#import "BaiduMobAdSDK/BaiduMobAdNative.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdObject.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeVideoView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeWebView.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

#define FRAME0 CGRectMake(0, 0, WIDTH, WIDTH*0.5)
#define FRAME1 CGRectMake(WIDTH, 0, WIDTH, WIDTH*0.5)
#define FRAME2 CGRectMake(WIDTH*2, 0, WIDTH, WIDTH*0.5)

@interface NativeLoopViewController ()<BaiduMobAdNativeAdDelegate, UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) BaiduMobAdNative *native;
@property (nonatomic, retain) BaiduMobAdNativeAdView *adView;
@property (nonatomic, retain) NSMutableArray *scrollViewObjectArray;
@end

@implementation NativeLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadAd];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                  target:self
                                                selector:@selector(timeToScroll)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self.timer invalidate];
    self.adView = nil;
    self.native.delegate = nil;
    self.native = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timeToScroll {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (contentOffsetX == 2*WIDTH) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(contentOffsetX+=WIDTH, 0);
    }
}

- (void)loadAd {
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    if (!self.native) {
        self.native = [[[BaiduMobAdNative alloc]init]autorelease];
        self.native.delegate = self;
    }
    [self.native requestNativeAds];
}

- (void)configScrollView {
    UIScrollView *scrollView = [[[UIScrollView alloc]init]autorelease];
    scrollView.frame = CGRectMake(0, 64, WIDTH, WIDTH*0.5);
    scrollView.bounces = NO;
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.contentSize = CGSizeMake(WIDTH*3, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *imageView1 = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mssp_1"]]autorelease];
    imageView1.contentMode = UIViewContentModeScaleToFill;
    imageView1.frame = FRAME0;
    UIImageView *imageView2 = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mssp_2"]]autorelease];
    imageView2.contentMode = UIViewContentModeScaleToFill;
    imageView2.frame = FRAME1;
    [_scrollViewObjectArray addObject:imageView1];
    [_scrollViewObjectArray addObject:imageView2];
    for (int i = 0; i<3; i++) {
        [self.scrollView addSubview:_scrollViewObjectArray[i]];
    }
}

- (void)configPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = 3;
    CGFloat centerX = WIDTH*0.5;
    CGFloat centerY = 64+self.scrollView.frame.size.height-20;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 20);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];

}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)pageDouble;
//    NSLog(@"intpage %d", pageInt);
    self.pageControl.currentPage = pageInt;
    if (pageInt == 2) {
        NSLog(@"cur page is nativeAdView");
        //展示到信息流的时候发展现, 勿忘
        [self.adView trackImpression];
    }
}


#pragma mark - native delegate
- (NSString *)publisherId {
    return @"ccb60059";
}

- (NSString *)apId {
    return @"2058621";
}

- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds {
    self.scrollViewObjectArray = [NSMutableArray array];
    //取一个object的imageview做展示
    BaiduMobAdNativeAdObject *object = [nativeAds firstObject];
    UIImageView *mainImageView = [[[UIImageView alloc]initWithFrame:FRAME0]autorelease];
    if (object.materialType != NORMAL) {
        NSLog(@"非普通广告类型, 请参考NativeTableViewController进行设置");
        return;
    }
    BaiduMobAdNativeAdView *adView = [[[BaiduMobAdNativeAdView alloc]initWithFrame:FRAME2
                                                                      brandName:nil
                                                                          title:nil
                                                                           text:nil
                                                                           icon:nil
                                                                      mainImage:mainImageView]autorelease];

    self.adView = adView;
    self.adView.backgroundColor = [UIColor whiteColor];
    
    if ([object isExpired]) {
        return;
    }
    
    __block NativeLoopViewController *weakSelf = self;
    
    [self.adView loadAndDisplayNativeAdWithObject:object completion:^(NSArray *errors) {
        if (!errors) {
            [_scrollViewObjectArray addObject:weakSelf.adView];
            [weakSelf configScrollView];
            [weakSelf configPageControl];
        }
    }];
}

- (void)nativeAdClicked:(BaiduMobAdNativeAdView *)nativeAdView {
    NSLog(@"ad clicked");
}

@end
