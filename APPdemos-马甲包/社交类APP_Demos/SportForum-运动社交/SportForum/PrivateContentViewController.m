//
//  PrivateContentViewController.m
//  SportForum
//
//  Created by liyuan on 4/27/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "PrivateContentViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "MobClick.h"

@interface PrivateContentViewController ()

@end

@implementation PrivateContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:_bAuthDetail ? @"认证规范" : @"用户协议" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    if(_bAuthDetail)
    {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
        scrollView.backgroundColor = [UIColor clearColor];
        [viewBody addSubview:scrollView];
        
        UIImage *imgAuth = [UIImage imageNamed:@"certifcatedesc.jpg"];
        UIImageView *imgAuthDetail = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(scrollView.frame) / 2 - imgAuth.size.width / 2, 0, imgAuth.size.width, imgAuth.size.height)];
        [imgAuthDetail setImage:imgAuth];
        [scrollView addSubview:imgAuthDetail];
        
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(viewBody.frame), CGRectGetMaxY(imgAuthDetail.frame));
    }
    else
    {
        UIWebView *helpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
        helpWebView.backgroundColor = APP_MAIN_BG_COLOR;
        helpWebView.scalesPageToFit = YES;
        helpWebView.opaque = NO;
        [viewBody addSubview:helpWebView];
        
        [self loadDocument:@"Service Agreement and Privacy Policy.doc" inView:helpWebView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PrivateContentViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"PrivateContentViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PrivateContentViewController"];
}

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(void)loadDocument:(UIWebView*)webView
{
    /*NSString *filePath = [[NSBundle mainBundle]pathForResource:@"task-tutorial" ofType:@"html" inDirectory:@"TaskTutoriai"];
     NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
     NSString *path = [[NSBundle mainBundle] bundlePath];
     NSURL *baseURL = [NSURL fileURLWithPath:path];
     [webView loadHTMLString:htmlString baseURL:baseURL];*/
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"private" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PrivateContentViewController dealloc.");
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
