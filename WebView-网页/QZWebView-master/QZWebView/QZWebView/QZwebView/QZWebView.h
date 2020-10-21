//
//  QZWebView.h
//  QZWebView
//
//  Created by 曲终叶落 on 2017/7/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZWebViewDelegate <NSObject>

@optional

/**
 页面开始加载时调用
 */
- (void)didStartProvisional;

/**
 开始获取到网页内容时返回
 */
- (void)didCommit;

/**
 加载完成
 */
- (void)didFinish;

/**
 加载失败
 */
- (void)didFailProvisional;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging;
- (void)webViewTitle:(NSString *)title;

@end

/**
 WebView封装：
 iOS7 : UIWebView
 iOS8 : WKWebView
 */
@interface QZWebView : UIView
@property (nonatomic,weak) id<QZWebViewDelegate>deleget;

/**
 通过网页链接初始化
 
 @param frame frame
 @param url 网页链接
 @return webView
 */
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;


/**
 通过本地链接初始化
 @param frame frame
 @param filePath 本地链接
 @return webView
 */
- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *)filePath;

/**
 加载JSON数据(需要在webView加载完成后使用)
 @param json json数据
 */
- (void)loadingWithJSON:(NSString *)json;


@end
