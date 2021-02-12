//
//  PrivacyAgreement.m
//  IMed
//
//  Created by survivors on 2018/10/15.
//  Copyright © 2018年 survivors. All rights reserved.
//

#import "PrivacyAgreement.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "YHUtility.h"

#define kDocumentPath       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)



#pragma mark - Set the local file path storage location
/** 文件存储路径*/
#define LocalFile_FilePath_IMedConfig       @"Project/BaseConfigInfo/"  // 书包配置文件目录
/** 文件名称*/
#define LocalFile_FileName_IMedConfig       @"ProjectConfigInfo.plist"

#define PrivacyAgreementState  @"PrivacyAgreementState"

@interface PrivacyAgreement () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *btnAgree;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PrivacyAgreement

+ (instancetype)shareInstance {
    static PrivacyAgreement *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PrivacyAgreement alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 在 UIApplicationDidFinishLaunching 时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:[kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", LocalFile_FilePath_IMedConfig, LocalFile_FileName_IMedConfig]]]) {
                NSMutableDictionary *configInfo = [NSMutableDictionary dictionaryWithContentsOfFile:[kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", LocalFile_FilePath_IMedConfig, LocalFile_FileName_IMedConfig]]];
                if ([[configInfo objectForKey:PrivacyAgreementState] isEqualToString:PrivacyAgreementState]) {} else {
                    // Show Privacy AgreementState View
                    [self showPrivacyAgreementStateView];
                }
            }
            else {
                // Show Privacy AgreementState View
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPrivacyAgreementStateView];
                });
            }
        }];
    }
    
    return self;
}



/**
 渲染隐私协议视图
 */
- (void)showPrivacyAgreementStateView {
    [kKeyWindow addSubview:self.backgroundView];
    [self webView];
    [self.backgroundView addSubview:self.btnAgree];
}



#pragma mark - ************************************************ UI
- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        
        _backgroundView = view;
    }
    return _backgroundView;
}

/**
 WebView 设置相关
 
 其中包含加载方式(本地文件 & 网络请求)

 @return 当前控件
 */
- (WKWebView *)webView {
    if (!_webView) {
        NSError *error;
        // 本地 url 地址设置
        NSURL *URLBase = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *URLAgreement = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:URLAgreement
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        webConfig.preferences = [[WKPreferences alloc] init];
        webConfig.preferences.javaScriptEnabled = YES;
        webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 150)
                                                configuration:webConfig];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
#pragma mark - 本地 html 文件加载方式
//        [webView loadHTMLString:html baseURL:URLBase];
#pragma mark - 网络请求加载方式
        // 隐私协议的 url 地址
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/d9fd0356f071"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0];
        [webView loadRequest:request];
        [_backgroundView addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (UIButton *)btnAgree {
    if (!_btnAgree) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetMidX(_webView.frame) - 50, CGRectGetMaxY(_webView.frame) + 10, 100, 44);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"同意" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnAgree = btn;
    }
    return _btnAgree;
}

- (void)btnClick {
//    NSMutableDictionary *configInfo = [NSMutableDictionary dictionaryWithContentsOfFile:[kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", LocalFile_FilePath_IMed, LocalFile_FileName_IMed]]];
    NSMutableDictionary *configInfo = [NSMutableDictionary dictionary];
    [configInfo setValue:PrivacyAgreementState forKey:PrivacyAgreementState];
    InsertObjectToLocalPlistFile(configInfo, LocalFile_FileName_IMedConfig, LocalFile_FilePath_IMedConfig);
    [_backgroundView removeFromSuperview];
}



@end
