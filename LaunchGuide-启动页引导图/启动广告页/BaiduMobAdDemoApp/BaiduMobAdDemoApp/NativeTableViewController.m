//
//  ViewController.m
//  DemoNativeAd
//
//  Created by houshunwei on 15-6-9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NativeTableViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdDelegate.h"
#import "BaiduMobAdSDK/BaiduMobAdNative.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdObject.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeVideoView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeWebView.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface NativeTableViewController ()<BaiduMobAdNativeAdDelegate>
@property(nonatomic,retain)UITableView*mainTableView;
@property (nonatomic, retain) BaiduMobAdNative *native;
@property (nonatomic, retain) NSMutableArray *adViewArray;

@end

@implementation NativeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 100, WIDTH, HEIGHT-100) style:UITableViewStylePlain] autorelease];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    self.adViewArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    [self.mainTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView = self.mainTableView;
    [self pressToLoadAd:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        self.native.delegate = nil;
        self.native = nil;
}

#pragma mark - 广告相关设置
//请求广告
- (IBAction)pressToLoadAd:(UIButton *)sender
{
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    if (!self.native)
    {
        self.native = [[[BaiduMobAdNative alloc]init]autorelease];
        self.native.delegate = self;
    }
    //请求原生广告
    [self.native requestNativeAds];
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
//成功返回广告字段，BaiduMobAdNativeAdObject array
- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds{

    self.adViewArray = [NSMutableArray array];
    
    for(int i = 0; i < [nativeAds count]; i++){
        BaiduMobAdNativeAdObject *object = [nativeAds objectAtIndex:i];
        BaiduMobAdNativeAdView *view = [self createNativeAdViewWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 351) object:object];
        
        [self.adViewArray addObject:view];
        
        // 展现前检查是否过期，30分钟广告将过期，如果广告过期，请放弃展示并重新请求
        if ([object isExpired]) {
            continue;
        }
        
        //如果开启了多图模式，则可以在标准的BaiduMobAdNativeAdView上添加自定义多图
        if([object.morepics count]>0 ){
            NSLog(@"多图url array 为 %@",object.morepics);
            UIImageView *imageview = [[[UIImageView alloc]init] autorelease];
            [view addSubview:imageview];
        }
        
        __block NativeTableViewController *weakSelf = self;
        // 加载和显示广告内容
        [view loadAndDisplayNativeAdWithObject:object completion:^(NSArray *errors) {
            if (!errors) {
                // 确定视图显示在window上之后再调用trackImpression，不要太早调用
                //在tableview或scrollview中使用时尤其要注意
                [weakSelf.tableView reloadData];
            }
            
        }];
    }
    
}

//广告返回失败
-(void)nativeAdsFailLoad:(BaiduMobFailReason)reason
{
    NSLog(@"nativeAdsFailLoad,reason = %d",reason);
}

//对于视频广告，展现一张视频预览大图，点击开始播放视频
- (void)nativeAdVideoAreaClick:(BaiduMobAdNativeAdView*)nativeAdView {
    if ([nativeAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
        [(BaiduMobAdNativeVideoView *)nativeAdView.videoView play];
    }
}

//广告被点击，打开后续详情页面，如果为视频广告，可选择暂停视频
-(void)nativeAdClicked:(BaiduMobAdNativeAdView *)nativeAdView
{
    if ([nativeAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
        [(BaiduMobAdNativeVideoView *)nativeAdView.videoView pause];
    }
    NSLog(@"nativeAdClicked");
}

//广告详情页被关闭，如果为视频广告，可选择继续播放视频
-(void)didDismissLandingPage:(BaiduMobAdNativeAdView *)nativeAdView
{
    if ([nativeAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
        [(BaiduMobAdNativeVideoView *)nativeAdView.videoView play];
    }
    NSLog(@"didDismissLandingPage");
}

#pragma mark - adConfig
- (BaiduMobAdNativeAdView *)createNativeAdViewWithframe:(CGRect)frame object:(BaiduMobAdNativeAdObject *)object
{
    UILabel *brandLabel = [[[UILabel alloc]initWithFrame:CGRectMake(85, 15, 212, 20)]autorelease];
    brandLabel.font = [UIFont fontWithName:brandLabel.font.familyName size:15];
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(85, 60, 200, 10)]autorelease];//(85, 60, 200, 10)
    titleLabel.font = [UIFont fontWithName:titleLabel.font.familyName size:12];
    
    UILabel *textLabel = [[[UILabel alloc]initWithFrame:CGRectMake(85, 40, 200, 10)]autorelease];
    textLabel.font = [UIFont fontWithName:textLabel.font.familyName size:12];
    
    UIImageView *iconImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 60, 60)]autorelease];
    UIImageView *mainImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 300, 250)]autorelease];
    UIImageView *baiduLogoView = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 310, 18, 18)]autorelease];
    UIImageView *adLogoView = [[[UIImageView alloc]initWithFrame:CGRectMake(286, 318, 24, 12)]autorelease];

    
    BaiduMobAdNativeAdView *nativeAdView;
    
    if (object.materialType == VIDEO) {
                BaiduMobAdNativeVideoView *videoView = [[[BaiduMobAdNativeVideoView alloc]initWithFrame:CGRectMake(0, 80, 320, 180) andObject:object]autorelease];
        
        mainImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 300, 180)]autorelease];

        videoView.isAutoPlay = NO;
        //在大图上添加播放按钮引导用户点击视频
        UIImage *image = [self imageResoureForName:@"play_big_image"];
        UIImageView *playImage = [[UIImageView alloc ]initWithImage:image];
        playImage.alpha = 0.85;
        playImage.frame = CGRectMake(86, 40, 120, 120);
        [mainImageView addSubview:playImage];
        
        
        nativeAdView = [[[BaiduMobAdNativeAdView alloc] initWithFrame:frame
                                                            brandName:brandLabel
                                                                title:titleLabel
                                                                 text:textLabel
                                                                 icon:iconImageView
                                                            mainImage:mainImageView
                                                            videoView:videoView
                         ]autorelease];
        nativeAdView.baiduLogoImageView = baiduLogoView;
        [nativeAdView addSubview:baiduLogoView];
        nativeAdView.adLogoImageView = adLogoView;
        [nativeAdView addSubview:adLogoView];
        
    } else if (object.materialType == NORMAL) {
        nativeAdView =  [[[BaiduMobAdNativeAdView alloc]initWithFrame:frame
                                                            brandName:brandLabel
                                                                title:titleLabel
                                                                 text:textLabel
                                                                 icon:iconImageView
                                                            mainImage:mainImageView]autorelease];
        nativeAdView.baiduLogoImageView = baiduLogoView;
        [nativeAdView addSubview:baiduLogoView];
        nativeAdView.adLogoImageView = adLogoView;
        [nativeAdView addSubview:adLogoView];
        
    } else if (object.materialType == HTML) {
#warning 模板广告内部已添加百度广告logo和熊掌，开发者无需添加
        BaiduMobAdNativeWebView *webview = [[[BaiduMobAdNativeWebView alloc]initWithFrame:frame andObject:object]autorelease];
        nativeAdView = [[[BaiduMobAdNativeAdView alloc]initWithFrame:frame
                                                               webview:webview]autorelease];
    }
    
    nativeAdView.backgroundColor = [UIColor whiteColor];
    return nativeAdView;
}

- (UIImage *)imageResoureForName:(NSString*)name
{
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"baidumobadsdk" ofType:@"bundle"];
    NSBundle* b=  [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageWithContentsOfFile: [b pathForResource:name ofType:@"png"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.adViewArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (self.adViewArray.count > indexPath.row)
    {
        BaiduMobAdNativeAdView *view = [self.adViewArray objectAtIndex:indexPath.row];
        view.tag = 0;
        [[cell viewWithTag:0] removeFromSuperview];
        [cell addSubview: view];
        [self sendVisibleImpressionAtIndexPath:indexPath];
    }
    return cell;
}

- (void)sendVisibleImpressionAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visiblePath = [self.tableView indexPathsForVisibleRows];
    if ([visiblePath containsObject:indexPath]) {
        if ([self.adViewArray count]> indexPath.row) {
            BaiduMobAdNativeAdView *view = [self.adViewArray objectAtIndex:indexPath.row];
            // 确定视图显示在window上之后再调用trackImpression，不要太早调用
            //在tableview或scrollview中使用时尤其要注意
            [view trackImpression];
        }
    }
}

/**
 * 大图高度，仅用于信息流模版广告
 */
-(NSNumber*)height {
    return [NSNumber numberWithFloat:180];
}

/**
 * 大图宽度，仅用于信息流模版广告
 */
-(NSNumber*)width {
    return [NSNumber numberWithFloat:320];
}

- (BOOL)enableLocation {
    return YES;

}

- (void)dealloc {
    [_native release];
    for (UIView *adview in _adViewArray) {
        [adview removeFromSuperview];
    }
    [_adViewArray removeAllObjects];
    [_adViewArray release];
    [super dealloc];
}


@end
