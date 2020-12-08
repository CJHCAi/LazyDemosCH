//
//  BaiduMobAdChuileiController.m
//  XAdSDKDevSample
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaiduMobAdChuileiController.h"
#import "BaiduMobAdSDK/BaiduMobAdChuileiAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdChuileiAdObject.h"

@implementation BaiduMobAdChuileiController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    if (!self.chuilei)
    {
        self.chuilei = [[[BaiduMobAdChuilei alloc]init]autorelease];
        self.chuilei.delegate = self;
    }
    //请求广告
    [self.chuilei requestAds];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.adViewArray removeAllObjects];
    self.adViewArray = nil;
    self.chuilei.delegate = nil;
    self.chuilei = nil;
    [super viewWillDisappear:animated];
}
//创建后获得的应用id
#warning - 上线前请换为自己的id
-(NSString*)publisherId
{
    return self.toBeChangedPublisherId;
}

//创建后获得的信息流广告位id
#warning - 上线前请换为自己的id
-(NSString*)apId
{
    return self.toBeChangedApid; //普通信息流, 3条
}

//广告返回成功
- (void)onAdObjectsSuccessLoad:(NSArray*)nativeAds{
    self.adViewArray = [NSMutableArray array];
    
    for(int i = 0; i < [nativeAds count]; i++){
        BaiduMobAdChuileiAdObject *object = [nativeAds objectAtIndex:i];
        BaiduMobAdChuileiAdView *view = [self createChuileiAdViewWithframe:CGRectMake(0 + 50 * i, 100, 50, 50) object:object];
        [self.adViewArray addObject:view];
        __block BaiduMobAdChuileiController *weakSelf = self;
        // 加载和显示广告内容
        [view loadAndDisplayAdWithObject:object completion:^(NSArray *errors) {
            if (!errors) {
                [weakSelf.view addSubview:view];
                [view trackImpression];
            }
        }];
    }
}

- (BaiduMobAdChuileiAdView *)createChuileiAdViewWithframe:(CGRect)frame object:(BaiduMobAdChuileiAdObject *)object
{
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(5, 40, 40, 10)]autorelease];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:titleLabel.font.familyName size:8];
    
    UIImageView *mainImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 38, 38)]autorelease];
    
    BaiduMobAdChuileiAdView *adView;
    adView =  [[[BaiduMobAdChuileiAdView alloc]initWithFrame:frame
                                                       title:titleLabel
                                                   mainImage:mainImageView]autorelease];
    
    adView.backgroundColor = [UIColor whiteColor];
    return adView;
}

//广告返回失败
-(void)onAdsFailLoad:(BaiduMobFailReason)reason
{
    NSLog(@"onAdsFailLoad,reason = %d",reason);
}


//广告被点击，打开后续详情页面
-(void)onAdClicked:(BaiduMobAdChuileiAdView *)adView
{
    NSLog(@"onAdClicked");
}

//广告详情页被关闭
-(void)didDismissLandingPage:(BaiduMobAdChuileiAdView *)adView
{
    NSLog(@"didDismissLandingPage");
}
@end
