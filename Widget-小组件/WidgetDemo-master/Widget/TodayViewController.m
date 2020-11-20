//
//  TodayViewController.m
//  Widget
//
//  Created by 汪继峰 on 2016/11/3.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#define THIRD_BUTTON_WIDTH 45
#define THIRD_BUTTON_DISTINCE 30
#define kWidgetWidth ([UIScreen mainScreen].bounds.size.width - 16)
#define isIOS10 [[UIDevice currentDevice].systemVersion doubleValue] >= 10.0

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *redButton;
@property (nonatomic, strong) UIButton *greenButton;
@property (nonatomic, strong) UIButton *qqLoginButton;
@property (nonatomic, strong) UIButton *wechatLoginButton;
@property (nonatomic, strong) UIButton *weiboLoginButton;
@property (nonatomic, copy) NSString *contentStr;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (isIOS10)
    {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
    self.preferredContentSize = CGSizeMake(kWidgetWidth, 110);
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
    self.contentStr = [userDefaults objectForKey:@"widget"];
    
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.redButton];
    [self.view addSubview:self.greenButton];
    [self.view addSubview:self.wechatLoginButton];
    [self.view addSubview:self.qqLoginButton];
    [self.view addSubview:self.weiboLoginButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - --- Customed Methods ---

- (void)redButtonPressed:(UIButton *)button
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"WidgetDemo://red"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}

- (void)greenButtonPressed:(UIButton *)button
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"WidgetDemo://green"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}

- (void)wechatLoginButtonPressed
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"wechat://"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}

- (void)qqLoginButtonPressed
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"mqq://"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}

- (void)weiboLoginButtonPressed
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"weibo://"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    NSLog(@"maxWidth %f maxHeight %f",maxSize.width,maxSize.height);
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    }
    else
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - --- Getters ---

- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kWidgetWidth, 25)];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        
        if (self.contentStr.length > 0)
        {
            _messageLabel.text = self.contentStr;
        }
        else
        {
            _messageLabel.text = @"当前内容为空";
        }
    }
    
    return _messageLabel;
}

- (UIButton *)redButton
{
    if (!_redButton)
    {
        _redButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _redButton.frame = CGRectMake(0, 0, 80, 30);
        _redButton.center = CGPointMake(kWidgetWidth * 0.25, 75);
        [_redButton setBackgroundColor:[UIColor redColor]];
        [_redButton setTitle:@"Red" forState:UIControlStateNormal];
        [_redButton addTarget:self action:@selector(redButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _redButton;
}

- (UIButton *)greenButton
{
    if (!_greenButton)
    {
        _greenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _greenButton.frame = CGRectMake(0, 0, 80, 30);
        _greenButton.center = CGPointMake(kWidgetWidth * 0.75, 75);
        [_greenButton setBackgroundColor:[UIColor greenColor]];
        [_greenButton setTitle:@"Green" forState:UIControlStateNormal];
        [_greenButton addTarget:self action:@selector(greenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _greenButton;
}

- (UIButton *)wechatLoginButton
{
    if (!_wechatLoginButton)
    {
        float precent;
        
        if ([UIScreen mainScreen].bounds.size.height == 480)
        {
            precent = 0.9;
        }
        else
        {
            precent = 0.8;
        }
        
        UIImage *wechatImage = [UIImage imageNamed:@"login_wechat"];
        
        _wechatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatLoginButton.frame = CGRectMake(0, 0, THIRD_BUTTON_WIDTH, THIRD_BUTTON_WIDTH);
        _wechatLoginButton.center = CGPointMake(kWidgetWidth / 2, 150);
        [_wechatLoginButton setImage:wechatImage forState:UIControlStateNormal];
        [_wechatLoginButton setImage:wechatImage forState:UIControlStateHighlighted];
        [_wechatLoginButton addTarget:self action:@selector(wechatLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wechatLoginButton;
}

- (UIButton *)qqLoginButton
{
    if (!_qqLoginButton)
    {
        UIImage *qqImage = [UIImage imageNamed:@"login_QQ"];
        
        _qqLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qqLoginButton.frame = CGRectMake(0, 0, THIRD_BUTTON_WIDTH, THIRD_BUTTON_WIDTH);
        _qqLoginButton.center = CGPointMake(kWidgetWidth / 2 + THIRD_BUTTON_WIDTH + THIRD_BUTTON_DISTINCE, _wechatLoginButton.center.y);
        [_qqLoginButton setImage:qqImage forState:UIControlStateNormal];
        [_qqLoginButton setImage:qqImage forState:UIControlStateHighlighted];
        [_qqLoginButton addTarget:self action:@selector(qqLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qqLoginButton;
}

- (UIButton *)weiboLoginButton
{
    if (!_weiboLoginButton)
    {
        UIImage *weiboImage = [UIImage imageNamed:@"login_weibo"];
        
        _weiboLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiboLoginButton.frame = CGRectMake(0, 0, THIRD_BUTTON_WIDTH, THIRD_BUTTON_WIDTH);
        _weiboLoginButton.center = CGPointMake(kWidgetWidth / 2 - THIRD_BUTTON_WIDTH - THIRD_BUTTON_DISTINCE, _wechatLoginButton.center.y);
        [_weiboLoginButton setImage:weiboImage forState:UIControlStateNormal];
        [_weiboLoginButton setImage:weiboImage forState:UIControlStateHighlighted];
        [_weiboLoginButton addTarget:self action:@selector(weiboLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _weiboLoginButton;
}

- (BOOL)saveDataByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xxx"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
    NSString *value = @"asdfasdfasf";
    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result)
    {
        NSLog(@"%@",err);
    }
    else
    {
        NSLog(@"save value:%@ success.",value);
    }
    return result;
}

- (NSString *)readDataByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xxx"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding: NSUTF8StringEncoding error:&err];
    return value;
}

@end
