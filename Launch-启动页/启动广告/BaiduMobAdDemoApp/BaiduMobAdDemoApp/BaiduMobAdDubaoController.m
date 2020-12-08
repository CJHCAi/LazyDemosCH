//
//  BaiduMobAdDubaoController.m
//  XAdSDKDevSample
//
//  Created by baidu on 16/7/28.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaiduMobAdDubaoController.h"
#import "BaiduMobAdSDK/BaiduMobAdDubao.h"

@interface BaiduMobAdDubaoController()
@property(nonatomic, retain) UIButton *closeButton;
@end

@implementation BaiduMobAdDubaoController

-(void) dealloc
{
    _dubao = nil;
    [_dubao release];
    
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    _dubao = [[BaiduMobAdDubao alloc]init];
    [_dubao setPosition:BaiduMobAdDubaoPositionLeft marginPercent:0.5];
    
    //创建后获得的悬浮前链代码位id
    #warning - 上线前请换为自己的id
    _dubao.AdUnitTag = @"2761579";
    
    _dubao.delegate = self;
    [_dubao showAd];
    
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeButton.frame = CGRectMake(10, 100, 200, 50);
    [self.closeButton setTitle:@"关闭度宝" forState:UIControlStateNormal];
    
    [self.closeButton addTarget:self action:@selector(closeDubao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
}

- (void)closeDubao
{
    [_dubao closeAd];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_dubao closeAd];
}

//创建后获得的应用id
#warning - 上线前请换为自己的id
- (NSString *)publisherId
{
    return  @"ccb60059";
}

-(BOOL) enableLocation
{
    //启用location会有一次alert提示
    return YES;
}

- (void)duBaoDidDismissScreen
{
    [_dubao release];
    _dubao = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    NSLog(@"warning1");
}


@end

