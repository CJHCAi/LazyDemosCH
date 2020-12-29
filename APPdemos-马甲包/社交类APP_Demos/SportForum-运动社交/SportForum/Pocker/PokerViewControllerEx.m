//
//  PokerViewController.m
//  Pocker
//
//  Created by zhengying on 3/13/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "PokerViewControllerEx.h"
#import "WebViewJavascriptBridge.h"
#import "DQAlertView.h"
#import "MobClick.h"

#define STRING_IS_EMPTY(str) ((str) == nil || [(str) isEqualToString:@""])
#define IOSVersionAbove(version) (([[[UIDevice currentDevice] systemVersion] intValue] >= version)? 1 : 0 )


static const NSString* kUserName = @"user_name";
static const NSString* kServer = @"ws_server";
static const NSString* kToken = @"app_token";
static const NSString* kJoinRoom = @"joinroom";

@interface PokerViewControllerEx () <UIWebViewDelegate>

@end

@implementation PokerViewControllerEx {
    WebViewJavascriptBridge* _bridge;
    NSMutableDictionary* _dictConfig;
    UIButton* _buttonQuit;
    
}

-(void)loadView {
    self.view = [[UIView alloc]init];
    
    _webView  = [[UIWebView alloc]init];
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _webView.backgroundColor = [UIColor blackColor];
    _webView.delegate = self;
    
    _buttonQuit = [[UIButton alloc]init];
    [_buttonQuit setTitle:@"退出" forState:UIControlStateNormal];
    [_buttonQuit addTarget:self action:@selector(actionQuit:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonQuit setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:_webView];
    [self.view addSubview:_buttonQuit];
    
    NSDictionary *views = @{@"selfView":self.view, @"webView":_webView, @"quitButton":_buttonQuit};
   
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[webView(selfView)]"
                               options:0
                               metrics:nil
                               views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[webView(selfView)]"
                               options:0
                               metrics:nil
                               views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-10-[quitButton]"
                               options:0
                               metrics:nil
                               views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-10-[quitButton]"
                               options:0
                               metrics:nil
                               views:views]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PokerViewControllerEx dealloc called!");
}

/*
 -(void)startWithCreateByToken:(NSString*)token FinishedBlock:(void(^)(NSString* rootID))finishBlock {
 NSAssert(STRING_IS_EMPTY(token) == false, @"token is empty");
 _token = token;
 }
 
 -(void)startWithJoinRoot:(NSString*)roomID ByToken:(NSString*)token FinishedBlock:(void(^)())finishBlock {
 NSAssert(STRING_IS_EMPTY(token) == false, @"token is empty");
 NSAssert(STRING_IS_EMPTY(roomID), @"token is empty");
 _token = token;
 _joinroom = roomID;
 }
 */

-(void)loadNativeSetting {
    //BOOL linodeEnable = [[NSUserDefaults standardUserDefaults]boolForKey:@"linode_enable"];
    NSString* userName = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_name"];
    
   // if (!userName || [userName isEqualToString:@""]) {
   //     userName = @"TestUSER";
   //     [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"user_name"];
   // }
    
    //if(!_token) {
    //    _token = userName;
   // }
    
    NSString* server = API_CFG_HTTP_REQUEST_URL;// @"172.24.222.54:8989/ws";
    NSRange range = {7, 13};
    server = [server substringWithRange:range];
    server = [server stringByAppendingString:@":8989/ws"];
    
    //if (linodeEnable) {
    //    server = @"106.187.48.51:8989/ws";
    //}
    
    if (userName) {
        _dictConfig[kUserName] = userName;
    }
    
    if (server) {
        _dictConfig[kServer] = server;
    }
    
    if (_token) {
        _dictConfig[kToken] = _token;
    }
    
    if (_joinroom) {
        _dictConfig[kJoinRoom] = _joinroom;
    }
}

-(UIView*)addMaskLayerToSelfView {
    UIView* viewMask = [[UIView alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.height, self.view.frame.size.width)];
    viewMask.backgroundColor = [UIColor colorWithRed:200 green:100 blue:100 alpha:0.0];
    [self.view addSubview:viewMask];
    [viewMask setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{@"selfView":self.view, @"maskView":viewMask};
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[maskView(selfView)]"
                               options:0
                               metrics:nil
                               views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[maskView(selfView)]"
                               options:0
                               metrics:nil
                               views:views]];
    [self.view layoutIfNeeded];
    return viewMask;
}

-(void)registerWebHandle {
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    
    __weak __typeof(self) weakSelf = self;
    
    // getNativeConfig
    [_bridge registerHandler:@"getNativeConfig" handler:^(id data, WVJBResponseCallback responseCallback) {
        __typeof(self)  strongSelf = weakSelf;
        [strongSelf loadNativeSetting];
        responseCallback(strongSelf->_dictConfig);
    }];
    
    // quitToApp
    [_bridge registerHandler:@"quitToApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        __typeof(self)  strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // pop user detail
    [_bridge registerHandler:@"showProfile" handler:^(id data, WVJBResponseCallback responseCallback) {
        // NSString* userID = data[@"userid"];
        // TODO: pop user profile window;
        //try pop a window
        /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingViewController *settings = (SettingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        
        
        [weakSelf presentViewController:settings animated:YES completion:nil];
         */
        
        __typeof(self)  strongSelf = weakSelf;
        
        if (strongSelf->_profileShowBlock) {
            NSString* userID = data[@"userid"];
            strongSelf->_profileShowBlock(userID);
        }
    }];
    
    
    // show common popup window
    [_bridge registerHandler:@"confrimPopupWindow" handler:^(id data, WVJBResponseCallback responseCallback) {
        __typeof(self)  strongSelf = weakSelf;
        
        NSString* popMessageID = data[@"id"];
        NSString* popTitle = data[@"pop_title"];
        NSString* popText = data[@"pop_text"];
        NSString* popButton1Text = data[@"pop_btn1_text"];
        DQAlertView* alertView = [[DQAlertView alloc]initWithTitle:popTitle message:popText delegate:strongSelf cancelButtonTitle:popButton1Text otherButtonTitles:nil];
        
        UIView* maskView = [strongSelf addMaskLayerToSelfView];
        
        __weak DQAlertView* alertViewSelf = alertView;
        
        alertView.cancelButtonAction = ^{
            responseCallback(@{@"buttonclick":@"popButton1"});
            [alertViewSelf.superview removeFromSuperview];
            
        };
        [alertView showInView:maskView];
    }];
    
    // show yesorno popup window
    [_bridge registerHandler:@"yesOrNoPopupWindow" handler:^(id data, WVJBResponseCallback responseCallback) {
        __typeof(self)  strongSelf = weakSelf;
        
        NSString* popMessageID = data[@"id"];
        NSString* popTitle = data[@"pop_title"];
        NSString* popText = data[@"pop_text"];
        NSString* popButton1Text = data[@"pop_btn1_text"];
        NSString* popButton2Text = data[@"pop_btn2_text"];
        //UIView* viewMask = [[UIView alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.height, self.view.frame.size.width)];
        //viewMask.center = self.view.center;
        
        UIView* maskView = [strongSelf addMaskLayerToSelfView];
        
        DQAlertView* alertView = [[DQAlertView alloc]initWithTitle:popTitle message:popText delegate:strongSelf cancelButtonTitle:popButton1Text otherButtonTitles:popButton2Text];
        
        __weak DQAlertView* alertViewSelf = alertView;
        
        alertView.cancelButtonAction = ^{
            NSLog(@"Cancel Clicked");
            responseCallback(@{@"sender":@"popButton1"});
            [alertViewSelf.superview removeFromSuperview];
        };
        alertView.otherButtonAction = ^{
            NSLog(@"OK Clicked");
            responseCallback(@{@"sender":@"popButton2"});
            [alertViewSelf dismiss];
            [alertViewSelf.superview removeFromSuperview];
        };
        [alertView showInView:maskView];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _dictConfig = [[NSMutableDictionary alloc]init];
    [self registerWebHandle];
    [self loadHTMLToWebKit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSettingUpdated:) name:@"SettingUpdate" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"德州扑克 - PokerViewControllerEx"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"德州扑克 - PokerViewControllerEx"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"德州扑克 - PokerViewControllerEx"];
    //[self clearCacheAndCookies];
}

-(void)clearCacheAndCookies
{
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //清除缓存（全）
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)loadHTMLToWebKit {
    [_webView stopLoading];
    NSString* PokerPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"Poker"];
    NSString* pokerIndex = [PokerPath stringByAppendingPathComponent:@"index.html"];
    NSString* indexPageContent = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:pokerIndex]
                                                          encoding:NSUTF8StringEncoding error:nil];
    
    indexPageContent = [indexPageContent stringByReplacingOccurrencesOfString:@"__PLAT__" withString:@"IOS"];
    
    [_webView loadHTMLString:indexPageContent baseURL:[NSURL fileURLWithPath:PokerPath]];
}


-(void)loadGame {
    //[self registerWebHandle];
    [self loadHTMLToWebKit];
}


-(void)actionSettingUpdated:(NSNotification* )notification {
    //[_bridge callHandler:@"reload"];
    [self loadGame];
}

-(IBAction)actionQuit:(id)sender {
    [_bridge callHandler:@"quitApp"];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(IBAction)actionReload:(id)sender {
    //[_bridge callHandler:@"reload"];
    [self loadGame];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)webView:(UIWebView *)webView2
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //NSLog(requestString);
    
    if ([requestString hasPrefix:@"ios-log:"]) {
        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        NSLog(@"UIWebView console: %@", logString);
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
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
