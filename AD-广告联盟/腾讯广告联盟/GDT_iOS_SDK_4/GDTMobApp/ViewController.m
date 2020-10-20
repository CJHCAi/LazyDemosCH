//
//  ViewController.m
//  GDTTestDemo
//
//  Created by 高超 on 13-10-31.
//  Copyright (c) 2013年 高超. All rights reserved.
//
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <objc/runtime.h>

#import "BannerViewController.h"
#import "InterstitialViewController.h"
#import "SplashViewController.h"
#import "NativeViewController.h"
#import "NativeExpressAdViewController.h"
#import "NativeExpressVideoAdViewController.h"
#import "GDTADTool.h"
#import "CHNativeAdView.h"
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface ViewController ()<GDTMobBannerViewDelegate,GDTMobInterstitialDelegate,GDTNativeAdDelegate,GDTSplashAdDelegate,GDTNativeExpressAdDelegete,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIStoryboard *storyBoard;
@property (nonatomic, strong) NSArray *demoArray;
@property (nonatomic, strong) NSDictionary *demoDict;
@property(nonatomic,strong)GDTMobBannerView * bannerView;
@property(nonatomic,strong)GDTMobInterstitial * interstitial;
//原生广告
@property (nonatomic, strong) NSArray *adArray;
@property (nonatomic, strong) GDTNativeAdData *currentAdData;
@property (nonatomic, strong) GDTNativeAd *nativeAd;
@property(nonatomic,strong)CHNativeAdView * adView;
@property(nonatomic,assign)BOOL attached;
//原生模板广告
@property(nonatomic,strong)UITableView * nativeADTable;
@property (nonatomic, strong) NSArray *expressAdViews;
@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    NSArray * buttonArr=@[@"横幅",@"插屏",@"原生",@"开屏",@"原生模板",@"原生视频模板",@"IDFA"];
    
    CGFloat margin=5;
    CGFloat btnW=(SCREEN_WIDTH-margin*8)/7;
    for (int i=0; i<7; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(margin+(btnW+margin)*i, SCREEN_HEIGHT-64-100, btnW, 50);
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [button setBackgroundColor:[UIColor redColor]];
        button.tag=i;
        [button addTarget:self action:@selector(showGDTMobAD:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    //插屏广告
    self.interstitial=[GDTADTool GDT_setupInterstitial];
    self.interstitial.delegate=self;
    [self.interstitial loadAd];
    //原生广告
    [self setupNativeAD];
    
}
#pragma mark-横幅广告
-(void)showGDTMobAD:(UIButton *)button{
    
    if (button.tag==0) {
        //横幅广告
        if (self.bannerView) {
            [self.bannerView removeFromSuperview];
            self.bannerView=nil;
        }
        GDTMobBannerView * bannerView=[GDTADTool GDT_setupBannerView];
        bannerView.frame=CGRectMake(0, SCREEN_HEIGHT-50,SCREEN_WIDTH, 50);
        bannerView.currentViewController=self;
        bannerView.delegate=self;
        bannerView.backgroundColor=[UIColor redColor];
        [self.view addSubview:bannerView];
        [bannerView loadAdAndShow];
        self.bannerView=bannerView;
    }else if (button.tag==1){
        //插屏
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
        }
        
    }else if (button.tag==2){
        //原生广告
        [self AttachNativeAD];
        
    }else if (button.tag==3){
        //开屏广告
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        view.backgroundColor=[UIColor redColor];
        GDTSplashAd * splashAd=[GDTADTool GDT_setupSplashADWithBottomView:nil skipView:view];
        splashAd.delegate=self;
        
    }else if (button.tag==4){
        if (_attached==NO) {
            //原生模板广告
            GDTNativeExpressAd * nativeExpressAD=[GDTADTool GDT_setupNativeExpressADWithWidth:100 height:50 Adcount:5];
            nativeExpressAD.delegate=self;
            [self nativeADTable];
            
        }else{
            [ self.nativeADTable removeFromSuperview];
            self.nativeADTable=nil;
            _attached=NO;
        }

        
    }else if (button.tag==5){
        //原生视频模板广告
        GDTNativeExpressAd * nativeVideoExpressAd=[GDTADTool GDT_setupNativeVideoExpressADWithSize:CGSizeZero autoPlay:YES videoMute:YES adCount:5];
        nativeVideoExpressAd.delegate=self;
        [self nativeADTable];
        
    }else{
      //获取IDFA
        NSString * IDFA=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:nil message:IDFA delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(UITableView *)nativeADTable{
    if (!_nativeADTable) {
        _nativeADTable=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 200) style:UITableViewStylePlain];
        _nativeADTable.delegate=self;
        _nativeADTable.dataSource=self;
        _nativeADTable.backgroundColor=[UIColor redColor];
        _nativeADTable.hidden=YES;
        [self.view addSubview:_nativeADTable];
        
        [_nativeADTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nativeexpresscell"];
        [_nativeADTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"splitnativeexpresscell"];
    }
    return _nativeADTable;
}

#pragma mark-GDTMobBannerViewDelegate
-(void)bannerViewClicked{
    NSLog(@"横幅广告点击");
}

#pragma mark-GDTMobInterstitialDelegate
/**插页广告消失*/
-(void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    if (self.interstitial) {
        self.interstitial.delegate=nil;
    }
    self.interstitial=[GDTADTool GDT_setupInterstitial];
    self.interstitial.delegate=self;
    [self.interstitial loadAd];

}



#pragma mark-原生广告
-(void)setupNativeAD{
    GDTNativeAd * nativeAD=[GDTADTool GDT_setupNativeAD];
    nativeAD.controller=self;
    nativeAD.delegate=self;
    [nativeAD loadAd:1];
}
/**原生广告渲染*/
-(void)AttachNativeAD{
    
    if (self.adArray.count > 0 && !_attached) {
        self.currentAdData = self.adArray[0];
        CHNativeAdView * adView = [[CHNativeAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        adView.currentAdData=self.currentAdData;
        adView.center = self.view.center;
        adView.layer.borderWidth = 1;
        adView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:adView];
        self.adView=adView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [adView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.5 animations:^{
            _adView.center = self.view.center;
        } completion:nil];
        // 广告数据渲染完毕即将展示时调用方法
        [self.nativeAd attachAd:self.currentAdData toView:self.adView];
        _attached = YES;
        
    } else if (_attached){
        [self.adView removeFromSuperview];
        self.adView=nil;
        _attached=NO;
    } else {
        NSLog(@"原生广告数据拉取失败，无法Attach");
    }
    
}

/*点击发生，调用点击接口*/
- (void)viewTapped:(UITapGestureRecognizer *)gr {
    [self.nativeAd clickAd:self.currentAdData];
}

#pragma mark - GDTNativeAdDelegate
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
    /*广告数据拉取成功，存储并展示*/
    self.adArray = nativeAdDataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *result = [NSMutableString string];
        [result appendString:@"原生广告返回数据:\n"];
        for (GDTNativeAdData *data in nativeAdDataArray) {
            NSData *d = [[data.properties description] dataUsingEncoding:NSUTF8StringEncoding];
            NSString *decodevalue = [[NSString alloc] initWithData:d encoding:NSNonLossyASCIIStringEncoding];;
            [result appendFormat:@"%@",decodevalue];
            [result appendFormat:@"\nisAppAd:%@",data.isAppAd ? @"YES":@"NO"];
            [result appendFormat:@"\nisThreeImgsAd:%@",data.isThreeImgsAd ? @"YES":@"NO"];
            [result appendString:@"\n------------------------"];
        }
    });
}
/*原生广告数据拉取失败*/
-(void)nativeAdFailToLoad:(NSError *)error{
    self.currentAdData = nil;
}




#pragma mark-原生模板广告
#pragma mark - GDTNativeExpressAdDelegete
/**拉取广告成功的回调*/
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    
        self.expressAdViews = [NSArray arrayWithArray:views];
        if (self.expressAdViews.count) {
            [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
                expressView.controller = self;
                [expressView render];
            }];
        }
        self.nativeADTable.hidden=NO;
        _attached=YES;
        [self.nativeADTable reloadData];
}



#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.nativeADTable) {
        return self.expressAdViews.count * 2;
    }else{
        return self.demoArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.nativeADTable) {
        UITableViewCell *cell = nil;
        if (indexPath.row % 2 == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"nativeexpresscell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
            if ([subView superview]) {
                [subView removeFromSuperview];
            }
            UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
            view.tag = 1000;
            [cell.contentView addSubview:view];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"splitnativeexpresscell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor grayColor];
        }
        return cell;
        
    }else{
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        cell.textLabel.text = self.demoArray[indexPath.row];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.nativeADTable) {
        if (indexPath.row % 2 == 0) {
            UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
            return view.bounds.size.height;
        }
        else {
            return 44;
        }
    }else{
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==self.tableView) {
        id item = self.demoDict[self.demoArray[indexPath.row]];
        if (class_isMetaClass(object_getClass(item))) {
            UIViewController *vc = [self.storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass(item)];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:idfa delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

    }
}



#pragma mark - property getter
- (UIStoryboard *)storyBoard
{
    if (!_storyBoard) {
        _storyBoard = [UIStoryboard storyboardWithName:@"GDTStoryboard" bundle:nil];
    }
    return _storyBoard;
}

- (NSArray *)demoArray
{
    if (!_demoArray) {
        _demoArray = @[@"Banner",
                       @"插屏",
                       @"原生广告",
                       @"开屏广告",
                       @"原生模板广告",
                       @"原生视频模板广告",
                       @"获取IDFA"];
    }
    return _demoArray;
}

- (NSDictionary *)demoDict
{
    if (!_demoDict) {
        _demoDict = @{@"Banner": [BannerViewController class],
                      @"插屏": [InterstitialViewController class],
                      @"原生广告": [NativeViewController class],
                      @"开屏广告": [SplashViewController class],
                      @"原生模板广告": [NativeExpressAdViewController class],
                      @"原生视频模板广告": [NativeExpressVideoAdViewController class],
                      @"获取IDFA": @"",
                      };
    }
    return _demoDict;
}

@end
