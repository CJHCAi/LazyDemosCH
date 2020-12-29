//
//  HelpUsedViewController.m
//  SportForum
//
//  Created by liyuan on 2/10/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "HelpUsedViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "MobClick.h"

@interface HelpUsedViewController ()

@end

@implementation HelpUsedViewController
{
    UIWebView * _helpWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"任务系统新手指南" IsNeedBackBtn:YES];
    
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

    _helpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    _helpWebView.backgroundColor = APP_MAIN_BG_COLOR;
    _helpWebView.scalesPageToFit = YES;
    _helpWebView.opaque = NO;
    [viewBody addSubview:_helpWebView];
    
    [self loadDocument:_helpWebView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HelpUsedViewController"];
    
    if (_taskInfo != nil) {
        e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:_taskInfo.task_status];
        
        if (eTaskStatus == e_task_normal) {
            [[SportForumAPI sharedInstance]tasksExecuteByTaskId:_taskInfo.task_id TaskPics:nil FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect){
                
                if (errorCode == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
                    
                    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                    
                    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                     }];
                }
                else
                {
                    [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                }
            }];
        }
    }
}

-(void)loadDocument:(UIWebView*)webView
{
    /*NSString *filePath = [[NSBundle mainBundle]pathForResource:@"task-tutorial" ofType:@"html" inDirectory:@"TaskTutoriai"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:htmlString baseURL:baseURL];*/
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"task-tutorial" ofType:@"html" inDirectory:@"TaskTutoriai"];
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
    NSLog(@"HelpUsedViewController dealloc.");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HelpUsedViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"HelpUsedViewController"];
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
