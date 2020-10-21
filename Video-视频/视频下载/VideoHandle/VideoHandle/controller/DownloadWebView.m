//
//  DownloadWebView.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/6.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "DownloadWebView.h"
#import "DownloadViewController.h"
#import "WebProgressView.h"
#import "DownloadTool.h"
#import "VideoModel.h"

@interface DownloadWebView () <UIWebViewDelegate,UITextFieldDelegate>
{
    BOOL _finishLoad;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic,strong) WebProgressView *progressView;

@end

@implementation DownloadWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.progressView = [[WebProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 2)];
    self.progressView.lineColor = COLOR(29, 184, 255, 1);
    [self.view addSubview:self.progressView];
    
    _webView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor lightGrayColor];
    _webView.delegate = self;
    
    [self customNaviItem];
    
    [self reachability];
}
//定制navigationItem
-(void)customNaviItem{
    
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 150, 26)];
    textF.textColor = COLOR(48, 48, 48, 1);
    textF.backgroundColor = COLOR(255, 255, 255, 1);
    textF.textAlignment = NSTextAlignmentCenter;
    textF.font = [UIFont systemFontOfSize:15.0];
    textF.text = self.url;
    textF.tintColor = COLOR(29, 184, 255, 1);
    textF.layer.cornerRadius = 2.0f;
    textF.layer.masksToBounds = YES;
    textF.delegate = self;
    textF.returnKeyType = UIReturnKeyGo;
    self.navigationItem.titleView = textF;
    
    //自定义返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftBtn.frame = CGRectMake(0, 0, 50, 44);
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"p_top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xzym_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshPage)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//检测网络状态
- (void)reachability{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变了, 就会调用这个block
        if (status == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络似乎出了点错误，请检查网络..." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            //断网的时候任务状态全部为失败
            DownloadTool *tool = [DownloadTool sharedInstance];
            for (MyDownloadTask *task in tool.taskArr) {
                task.status = DownloadTaskStatusFailed;
            }
        }
    }];
    //开始监控
    [mgr startMonitoring];
}


#pragma mark - UITextFieldDelegate
#pragma mark -
//
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:textField.text]]];
    
    return YES;
}


#pragma mark - UIWebViewDelegate
#pragma mark -
//
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_progressView startLoadingAnimation];
}
//
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [_progressView endLoadingAnimation];
    _finishLoad = 1;
}
//
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [_progressView endLoadingAnimation];
}
//当网页端发起一个请求的时候,UIWebView是可以截获这个请求的动作的
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}


#pragma mark - 各种事件
#pragma mark -
//
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)downloadAction:(UIButton *)sender {
    
    sender.backgroundColor = COLOR(16, 142, 233, 1);
    
    NSString *JSStr = @"(document.getElementsByTagName(\"video\")[0]).src";
    NSString *videoUrl = [_webView stringByEvaluatingJavaScriptFromString:JSStr];
    
    if (_finishLoad) {
        
        if (![videoUrl isEqualToString:@""] && videoUrl) {  //秒拍  快手
            
            NSLog(@"videoUrl == %@",videoUrl);
            
            NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择视频源" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                DownloadViewController *ctl = [DownloadViewController new];
                
                ctl.index = 1;
                
                [self downloadWithNetFrom:videoUrl and:title and:ctl];
            }];
            
            [alert addAction:cancel];
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{  //抖音  火山
            
            JSStr = @"document.documentElement.innerHTML";
            NSString *htmlStr = [_webView stringByEvaluatingJavaScriptFromString:JSStr];
            
            //匹配得到的下标
            NSRange range1 = [htmlStr rangeOfString:@"<div class=\"player\""];
            if (range1.length > 0) {
                htmlStr = [htmlStr substringFromIndex:range1.location];
                NSRange range2 = [htmlStr rangeOfString:@"</div>"];
                if (range2.length > 0) {
                    htmlStr = [htmlStr substringToIndex:range2.location];
                }
            }else{
                htmlStr = @"";
            }
            
            videoUrl = [self urlValidation:htmlStr];
            
            NSLog(@"videoUrl == %@",videoUrl);
            
            NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            
            if (![videoUrl isEqualToString:@""]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择视频源" preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    DownloadViewController *ctl = [DownloadViewController new];
                    
                    ctl.index = 1;
                    
                    [self downloadWithNetFrom:videoUrl and:title and:ctl];
                }];
                
                [alert addAction:cancel];
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else{
            
                HUDTEXT(@"此页面没有视频", self.view);
            }
        }
    }
}
//根据网络状况判断是否下载
-(void)downloadWithNetFrom:(NSString *)url and:(NSString *)title and:(DownloadViewController *)ctl{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    if ([mgr isReachableViaWiFi]) {
        //WIFI下直接下载
        DownloadTool *tool = [DownloadTool sharedInstance];
        
        [tool downFileFromServer:url and:title andCtl:ctl];
        
        [self.navigationController pushViewController:ctl animated:YES];
        
    }else if ([mgr isReachableViaWWAN]){
        //非WIFI情况下提醒用户
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前网络不是WIFI，确定要继续下载？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            DownloadTool *tool = [DownloadTool sharedInstance];
            
            [tool downFileFromServer:url and:title andCtl:ctl];
            
            [self.navigationController pushViewController:ctl animated:YES];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (![mgr isReachable]){
        //没网提醒用户
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络似乎出了点错误，请检查网络..." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 * 网址正则验证
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为匹配之后的字符串
 */
- (NSString *)urlValidation:(NSString *)string {
    
    if (string) {
        
        NSError *error;
        //正则
        NSString *regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            
            NSString *substringForMatch = [string substringWithRange:match.range];
            
            return substringForMatch;
        }
    }
    
    return @"";
}
//
- (IBAction)touchDown:(UIButton *)sender {
    
    sender.backgroundColor = COLOR(18, 132, 214, 1);
}
//
- (IBAction)touchUpOut:(UIButton *)sender {
    
    sender.backgroundColor = COLOR(16, 142, 233, 1);
}
//刷新网页(重新加载)
-(void)refreshPage{
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

@end
