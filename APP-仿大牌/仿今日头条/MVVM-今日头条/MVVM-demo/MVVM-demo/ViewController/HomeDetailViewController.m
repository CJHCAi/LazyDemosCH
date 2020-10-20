//
//  HomeDetailViewController.m
//  MVVM-demo
//
//  Created by shen_gh on 16/4/13.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "Define.h"
#import "HomeDetailView.h"

@interface HomeDetailViewController ()
<UIWebViewDelegate>

@property (nonatomic,strong) HomeDetailView *homeDetailView;
@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:_navTitle];
    [self.view setBackgroundColor:kAppMainBgColor];
    
    [self.view addSubview:self.homeDetailView];
}

- (HomeDetailView *)homeDetailView{
    if (!_homeDetailView) {
        _homeDetailView=[[HomeDetailView alloc]initWithFrame:self.view.bounds];
        [_homeDetailView setDelegate:self];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
        [_homeDetailView loadRequest:request];
    }
    return _homeDetailView;
}

#pragma mark - UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
