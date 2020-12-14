//
//  YTBookstoreViewController.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTBookstoreViewController.h"
#import "YTSearchViewController.h"
#import "AppDelegate.h"
@interface YTBookstoreViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *failImgView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;

- (IBAction)refreshBtnClick:(id)sender;
- (IBAction)searchBtnClick:(id)sender;
- (IBAction)iconBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *bookstoreWebView;



@end

@implementation YTBookstoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.failImgView.hidden = YES;
    self.failLabel.hidden = YES;
    self.refreshBtn.hidden = YES;
    
    self.bookstoreWebView.delegate = self;
    self.bookstoreWebView.scrollView.bounces = NO;
    self.bookstoreWebView.backgroundColor = [UIColor whiteColor];
    [self bookStoreWebViewRequest];
  
    

    
}

- (void)bookStoreWebViewRequest{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://k.sogou.com/abs/ios/v3/girl?gender=1"]];
    [self.bookstoreWebView loadRequest:request];
}
/**刷新*/
- (IBAction)refreshBtnClick:(id)sender {
    [self bookStoreWebViewRequest];
}

/**搜索按钮的点击*/
- (IBAction)searchBtnClick:(id)sender {
    
    [YTNavAnimation NavPushAnimation:self.navigationController.view];
    YTSearchViewController *searchVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"searchVC"];
    
    [[self navigationController] pushViewController:searchVC animated:NO];

}
/**头像的点击*/
- (IBAction)iconBtnClick:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    NSLog(@"open left");
    
}



#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LBProgressHUD showHUDto:self.view animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.failImgView.hidden = YES;
    self.failLabel.hidden = YES;
    self.refreshBtn.hidden = YES;
    [LBProgressHUD hideAllHUDsForView:self.view animated:NO];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [LBProgressHUD hideAllHUDsForView:self.view animated:NO];
    self.failImgView.hidden = NO;
    self.failLabel.hidden = NO;
    self.refreshBtn.hidden = NO;
}
@end
