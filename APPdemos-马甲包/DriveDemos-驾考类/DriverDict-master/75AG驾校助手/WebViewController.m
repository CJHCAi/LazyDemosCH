//
//  WebViewController.m
//  75AG驾校助手
//
//  Created by again on 16/5/1.
//  Copyright © 2016年 again. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (strong,nonatomic) UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *data = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSLog(@"kai");
////        }];
        
                    [self.webView loadRequest:request];
//        [data resume];
        [self.view addSubview:self.webView];
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
    
}

@end
