//
//  ZHBGoodDetailChildDetailViewController.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/14.
//  Copyright © 2016年 zhbservice. All rights reserved.
//
//商品-详情-评价  详情页
@class ZHBGoodDetailWebView;


@interface ZHBGoodDetailChildDetailViewController : UIViewController

@property (nonatomic, strong) ZHBGoodDetailWebView *goodDetailWebView;
- (void)configureWebview:(ZHBGoodDetailWebView *)goodDetailWebView;

@end
