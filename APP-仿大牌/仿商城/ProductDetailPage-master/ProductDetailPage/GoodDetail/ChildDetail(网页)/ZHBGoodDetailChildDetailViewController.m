//
//  ZHBGoodDetailChildDetailViewController.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/14.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBGoodDetailChildDetailViewController.h"
#import "ZHBGoodDetailWebView.h"

static CGFloat const  kBottomButtonViewHeight    = 50.f; // 底部视图高度（加入购物车＼立即购买）

@interface ZHBGoodDetailChildDetailViewController ()<UIScrollViewDelegate>

@end

@implementation ZHBGoodDetailChildDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    // 加载webview的view
    if (self.goodDetailWebView) {
        [self configureWebview:self.goodDetailWebView];
    }
}
- (void)configureWebview:(ZHBGoodDetailWebView *)goodDetailWebView
{
    
    self.goodDetailWebView = goodDetailWebView;
    self.goodDetailWebView.frame = CGRectMake(0, UIScreen.navigationBarHeight, kScreenWidth, self.view.height - kBottomButtonViewHeight - [UIScreen safeBottomMargin] - UIScreen.navigationBarHeight);
    // 抢过代理权,防止那边代理做事情
    self.goodDetailWebView.infoWebView.scrollView.delegate = self;
    [self.goodDetailWebView setHeaderHidden:YES];
    [self.view addSubview:self.goodDetailWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"ZHBGoodDetailChildDetailViewController dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
