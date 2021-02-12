//
//  ViewController.m
//  FuckAlbcTaobao
//
//  Created by RaulStudio on 2016/10/26.
//  Copyright © 2016年 RaulStudio. All rights reserved.
//

#import "ViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnOpenTaobao:(id)sender {
    //打开商品详情页
    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage: @"539379923863"];
    
//    //添加商品到购物车
//    id<AlibcTradePage> page = [AlibcTradePageFactory addCartPage: @"123456"];
//    
//    //根据链接打开页面
//    id<AlibcTradePage> page = [AlibcTradePageFactory page: @"http://h5.m.taobao.com/cm/snap/index.html?id=527140984722"];
//    
//    //打开店铺
//    id<AlibcTradePage> page = [AlibcTradePageFactory shopPage: @”12333333”];
//    
//    //打开我的订单页
//    id<AlibcTradePage> page = [AlibcTradePageFactory myOrdersPage:0 isAllOrder:YES];
//    
//    //打开我的购物车
//    id<AlibcTradePage> page = [AlibcTradePageFactory myCartsPage];
//
    
    //淘客信息
    AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid=@"mm_112832157_16156219_64300040"; //
    //打开方式
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = ALiOpenTypeAuto;
    
    [[AlibcTradeSDK sharedInstance].tradeService show: showParam.isNeedPush ?  self.navigationController : self page:page showParams:showParam taoKeParams: taoKeParams trackParam: nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        NSLog(@"成功:%@",result);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSLog(@"失败:%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
