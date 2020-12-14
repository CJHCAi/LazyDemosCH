//
//  ARBookstoreViewController.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/25.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARBookstoreViewController.h"
#import "MBProgressHUD.h"
#import "ARSearchViewController.h"

@interface ARBookstoreViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *bookstoreWebView;

- (IBAction)searchBtnClick:(id)sender;

@end

@implementation ARBookstoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bookstoreWebView.delegate = self;
    self.bookstoreWebView.scrollView.bounces = NO;
    self.bookstoreWebView.backgroundColor = [UIColor whiteColor];
    [self bookStoreWebViewRequest];}

- (void)bookStoreWebViewRequest{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://k.sogou.com/abs/ios/v3/girl?gender=1"]];
    [self.bookstoreWebView loadRequest:request];
}

- (IBAction)searchBtnClick:(id)sender {
    [ARNavAnimation NavPushAnimation:self.navigationController.view];
    ARSearchViewController *searchVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchVC"];
    
    [[self navigationController] pushViewController:searchVC animated:NO];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
