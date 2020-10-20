//
//  GDTNativeViewController.m
//  GDTMobApp
//
//  Created by michaelxing on 2016/11/2.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "NativeViewController.h"
#import "GDTNativeAd.h"
#import "GDTAppDelegate.h"

@interface NativeViewController ()<GDTNativeAdDelegate>
{
    // 业务相关
    BOOL _attached;
}

@property (nonatomic, strong) GDTNativeAd *nativeAd;
@property (nonatomic, strong) NSArray *adArray;
@property (nonatomic, strong) GDTNativeAdData *currentAdData;
@property (nonatomic, strong) UIView *adView;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UITextField *posTextField;

@end

@implementation NativeViewController


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - event response
- (IBAction)loadAd:(id)sender {
    if (_attached) {
        [self.adView removeFromSuperview];
        self.adView = nil;
        _attached = NO;
    }
    
    /*
     * 创建原生广告
     * "appId" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
     * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
     *
     * 本原生广告位ID在联盟系统中创建时勾选的详情图尺寸为1280*720，开发者可以根据自己应用的需要
     * 创建对应的尺寸规格ID
     *
     * 这里详情图以1280*720为例
     */
    
    self.nativeAd = [[GDTNativeAd alloc] initWithAppId:kGDTMobSDKAppId placementId:_posTextField.text];
    self.nativeAd.controller = self;
    self.nativeAd.delegate = self;
    
    /*
     * 拉取广告,传入参数为拉取个数。
     * 发起拉取广告请求,在获得广告数据后回调delegate
     */
    [self.nativeAd loadAd:1]; //这里以一次拉取一条原生广告为例
    
}


- (IBAction)attach:(id)sender {
    
    if (self.adArray.count > 0 && !_attached) {
        /*选择展示广告*/
        self.currentAdData = self.adArray[0];
        
        /*广告详情图*/
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 70, 316, 176)];
        [self.adView addSubview:imgV];
        NSURL *imageURL = [NSURL URLWithString:[self.currentAdData.properties objectForKey:GDTNativeAdDataKeyImgUrl]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgV.image = [UIImage imageWithData:imageData];
            });
        });
        
        /*广告Icon*/
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        [self.adView addSubview:iconV];
        NSURL *iconURL = [NSURL URLWithString:[self.currentAdData.properties objectForKey:GDTNativeAdDataKeyIconUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                iconV.image = [UIImage imageWithData:imageData];
            });
        });
        
        /*广告标题*/
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 35)];
        txt.text = [self.currentAdData.properties objectForKey:GDTNativeAdDataKeyTitle];
        [self.adView addSubview:txt];
        
        /*广告描述*/
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 220, 20)];
        desc.text = [self.currentAdData.properties objectForKey:GDTNativeAdDataKeyDesc];
        [self.adView addSubview:desc];
        
        CGRect adviewFrame = self.adView.frame;
        adviewFrame.origin.x = [[UIScreen mainScreen] bounds].size.width + adviewFrame.origin.x;
        self.adView.frame = adviewFrame;
        [self.view addSubview:self.adView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self.adView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.adView.center = self.responseTextView.center;
        } completion:nil];
        
        /*
         * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
         */
        [self.nativeAd attachAd:self.currentAdData toView:self.adView];
        
        _attached = YES;
        
    } else if (_attached){
        self.responseTextView.text = @"Already attached";
    } else {
        self.responseTextView.text = @"原生广告数据拉取失败，无法Attach";
    }

}

- (void)viewTapped:(UITapGestureRecognizer *)gr {
    /*点击发生，调用点击接口*/
    [self.nativeAd clickAd:self.currentAdData];
}

#pragma mark - GDTNativeAdDelegate
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    NSLog(@"%s",__FUNCTION__);
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
        
        self.responseTextView.text = result;
    });
}

-(void)nativeAdFailToLoad:(NSError *)error
{
    NSLog(@"%@",error);
    /*广告数据拉取失败*/
    self.currentAdData = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.responseTextView.text = [NSString stringWithFormat:@"原生广告数据拉取失败, %@\n",error];
    });
}

/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  原生广告点击之后应用进入后台时回调
 */
- (void)nativeAdApplicationWillEnterBackground
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeAdClosed
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - property getter
- (UIView *)adView
{
    if (!_adView) {
        _adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _adView.center = self.responseTextView.center;
        _adView.layer.borderWidth = 1;
        _adView.backgroundColor = [UIColor whiteColor];
    }
    return _adView;
}
@end
