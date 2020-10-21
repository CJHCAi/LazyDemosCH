//
//  DPWkWebViewController.h
//
//  Created by dp on 17/3/20.
//  Copyright © 2017年 DP. All rights reserved.
//
#define isiOS8 [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0
//获取屏幕 宽度、高度
#define DPMYSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DPMYSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "DPWkWebViewController.h"
#import "ZLCWebView.h"
typedef enum{
    loadWebURLString = 0,
    loadWebHTMLString,
    POSTWebURLString,
}wkWebLoadType;
static void *XFWkwebBrowserContext = &XFWkwebBrowserContext;
@interface DPWkWebViewController ()<ZLCWebViewDelegate>
@property (nonatomic,strong) ZLCWebView *webView;
@property (nonatomic,strong)UIBarButtonItem* customBackBarItem;
@property (nonatomic,strong)UIBarButtonItem* closeButtonItem;
@end

@implementation DPWkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }

    
    self.extendedLayoutIncludesOpaqueBars=YES;  //解决隐藏导航栏问题
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    

    
    //添加右边刷新按钮
    UIBarButtonItem *roadLoad = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(roadLoadClicked)];
    self.navigationItem.rightBarButtonItem = roadLoad;
    
}
- (void)roadLoadClicked{
    if (isiOS8) {
        [self.webView.wkWebView reload];
    }else{
        [self.webView.uiWebView reload];
    }
    
}

-(void)loadWebURLSring:(NSString *)string{
    [self.webView loadURLString:string];
    [self.view addSubview:self.webView];
    
    
}
-(void)loadWebUrl:(NSURL *)url{
    [self.webView loadURL:url];
    [self.view addSubview:self.webView];
}
#pragma mark-懒加载================================
-(ZLCWebView *)webView{
    if (_webView==nil) {
        _webView= [[ZLCWebView alloc]initWithFrame:CGRectMake(0, 64, DPMYSCREEN_WIDTH, DPMYSCREEN_HEIGHT-64)];
        _webView.delegate = self;
    }
    return _webView;
}
-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"backItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"backItemImage-hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}
-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

#pragma mark ================ 自定义返回/关闭按钮 ================

-(void)updateNavigationItems{
    if (isiOS8) {
        if (self.webView.wkWebView.canGoBack) {
            UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spaceButtonItem.width = -6.5;
            
            [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
        }else{
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        }
    }else{
        if (self.webView.uiWebView.canGoBack) {
            UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spaceButtonItem.width = -6.5;
            
            [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
        }else{
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        }
    }
}
-(void)customBackItemClicked{
    if (isiOS8) {
        if (self.webView.wkWebView.canGoBack) {
            [self.webView.wkWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (self.webView.uiWebView.canGoBack) {
            [self.webView.uiWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)zlcwebViewDidStartLoad:(ZLCWebView *)webview
{
    NSLog(@"页面开始加载");
    
}

- (void)zlcwebView:(ZLCWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}
- (void)zlcwebView:(ZLCWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"页面加载完成");
    [self updateNavigationItems];
    
}

- (void)zlcwebView:(ZLCWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
}



@end
