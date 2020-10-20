//
//  ViewController.m
//  ScrollviewDemo
//
//  Created by webplus on 17/12/19.
//  Copyright © 2017年 李Sir灬. All rights reserved.
//

#import "ViewController.h"
#import "FJBannerScrollView.h"
#import "MacrosHeader.h"

@interface ViewController ()<BannerScrollViewDelegate>

@property (nonatomic,strong)FJBannerScrollView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bannerView];
    [self setupBannerArray];
}

#pragma mark - array
- (void)setupBannerArray{
    //图片数据
    [_bannerView setCarouseWithArray:@[@{@"image":@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg"},@{@"image":@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg"},@{@"image":@"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"}]];
}

#pragma mark - init
- (FJBannerScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[FJBannerScrollView alloc]init];
        _bannerView.frame = CGRectMake(0, 0, fj_screenWidth, 180);
        //图片宽度
        _bannerView.imgWidth = fj_screenWidth-40;
        //边距
        _bannerView.imgEdgePadding = 30;
        //两个图片间距
        _bannerView.imgMargnPadding = 10;
        //默认图
        _bannerView.defaultImg = @"moren";
        //圆角（0的时候没有圆角）
        _bannerView.imgCornerRadius = 5;
        
        _bannerView.bannerScrolldelegate = self;
    }
    return _bannerView;
}

#pragma mark - Delegate
- (void)selectedIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
