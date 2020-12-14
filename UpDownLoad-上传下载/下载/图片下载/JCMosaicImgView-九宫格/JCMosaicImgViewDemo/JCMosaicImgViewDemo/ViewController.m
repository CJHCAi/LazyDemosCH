//
//  ViewController.m
//  JCMosaicImgViewDemo
//
//  Created by jimple on 14-1-9.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "ViewController.h"
#import "GlobalDefine.h"
#import "JCMosaicImgView.h"
#import "RemoteImgListOperator.h"

@interface ViewController ()

@property (nonatomic, readonly) RemoteImgListOperator *m_objImgListOper;
@property (nonatomic, readonly) JCMosaicImgView *m_mosaicImgView;

@end

@implementation ViewController
@synthesize m_objImgListOper = _objImgListOper;
@synthesize m_mosaicImgView = _mosaicImgView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 使用 JCRemoteImgListOperator 进行图片下载
    // https://github.com/jimple/RemoteImgListOperator
    _objImgListOper = [[RemoteImgListOperator alloc] init];
    
    NSArray *arrImgURL = @[@"http://ww1.sinaimg.cn/square/6deee36fgw1eby2bh3bxlj20bh0hajsu.jpg",
                           @"http://ww1.sinaimg.cn/square/6deee36fgw1eby2bhj5t2j20bh0hb0u5.jpg",
                           @"http://ww1.sinaimg.cn/square/749e7418jw1e6tiy08m52j20dc0hsgne.jpg",
                           @"http://ww1.sinaimg.cn/square/749e7418jw1e6tiy3nso4j20dc0hs3zs.jpg",
                           @"http://ww1.sinaimg.cn/square/5fae6c19jw1e6h04js4xej218g0xcju2.jpg",
                           @"http://ww1.sinaimg.cn/square/5fae6c19jw1e6h04llbhjj218g0xcgp5.jpg",
                           @"http://ww1.sinaimg.cn/square/6e109605jw1ec442eaq9nj20qo0f0q6m.jpg",
                           @"http://ww1.sinaimg.cn/square/6deee36fgw1eby2bfug1uj20bh07mmy4.jpg",
                           @"http://ww1.sinaimg.cn/small/7116d554gw1ecd41d9s9oj205k05k3ym.jpg"
                           ];
    
    CGFloat fImgHeight = [JCMosaicImgView imgHeightByImg:arrImgURL];
    CGFloat fImgWidth = [JCMosaicImgView imgWidthByImg:arrImgURL];

    // 1.创建对象   2.设置图片下载队列对象   3.输入图片URL数组。
    _mosaicImgView = [[JCMosaicImgView alloc] initWithFrame:Rect(0.0f, 20, fImgWidth, fImgHeight)];
    _mosaicImgView.backgroundColor=[UIColor redColor];
    [_mosaicImgView setImgListOper:_objImgListOper];
    [_mosaicImgView showWithImgURLs:arrImgURL];
    [self.view addSubview:_mosaicImgView];
}








@end
