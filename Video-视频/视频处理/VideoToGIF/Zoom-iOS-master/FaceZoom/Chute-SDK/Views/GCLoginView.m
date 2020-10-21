//
//  GCLoginView2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCLoginView.h"
#import <QuartzCore/QuartzCore.h>
//#import "MBProgressHUD.h"
#import "NSDictionary+QueryString.h"
#import "AFJSONRequestOperation.h"
#import "GCClient.h"
#import "GCOAuth2Client.h"
#import "GCLog.h"

@implementation GCLoginView

@synthesize webView, loginType, success, failure;

- (id)initWithFrame:(CGRect)frame inParentView:(UIView *)parentView
{
    self = [super initWithFrame:frame inParentView:parentView];
    if (self) {
        
        self.webView = [[UIWebView alloc] initWithFrame:contentView.frame];
        [self.webView setDelegate:self];
        [self.webView setScalesPageToFit:YES];
        [self.webView sizeToFit];
        [contentView addSubview:self.webView];
        
    }
    return self;
}

+ (void)showLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [self showInView:window withLoginType:_loginType success:_success failure:_failure];
}

+ (void)showInView:(UIView *)_view withLoginType:(GCLoginType)_loginType
{
        
    [self showInView:_view fromStartPoint:_view.layer.position withLoginType:_loginType success:nil failure:nil];
}

+ (void)showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint withLoginType:(GCLoginType)_loginType
{
    
    [self showInView:_view fromStartPoint:_startPoint withLoginType:_loginType success:nil failure:nil];

}

+ (void)showInView:(UIView *)_view withLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure
{
    
    [self showInView:_view fromStartPoint:_view.layer.position withLoginType:_loginType success:_success failure:_failure];
}

+ (void) showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint withLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure {
    
    CGRect popupFrame = [self popupFrameForView:_view withStartPoint:_startPoint];
    
    GCLoginView *popup = [[GCLoginView alloc] initWithFrame:popupFrame inParentView:_view];
    
    popup.loginType = _loginType;
    popup.success = _success;
    popup.failure = _failure;
    
    [_view addSubview:popup];
    
    [popup showPopupWithCompletition:^{
        [popup.webView loadRequest:[[GCOAuth2Client sharedClient] requestAccessForLoginType:_loginType]];
    }];
    
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[webView setFrame:contentView.bounds];
}

#pragma mark - UIPopoverView Methods

- (void)closePopupWithCompletition:(void (^)(void))completition
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [super closePopupWithCompletition:completition];
}

#pragma mark - UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
// Gaurav's code

    NSLog(@"\n Request URL: %@",[[request URL] absoluteString]);
    
 if ([[[request URL] path] isEqualToString:@"/oauth/callback"]) {
        NSString *_code = [[NSDictionary dictionaryWithFormEncodedString:[[request URL] query]] objectForKey:@"code"];
    
    if (_code && [_code length] > 0) {
        [[GCOAuth2Client sharedClient] verifyAuthorizationWithAccessCode:_code success:^{
            [self closePopupWithCompletition:^{
                if (success)
                    success();
            }];
        } failure:^(NSError *error) {
            if([error code] == 302){
                [self closePopupWithCompletition:^{
                    failure(error);
                }];
            }
            else if (failure)
                failure(error);
            else
                NSAssert(!error, [error localizedDescription]);
        }];
        return NO;
    }
 }
 else if ([[[request URL] absoluteString] isEqualToString:@"http://getchute.com/v2/oauth/failure"]) {
     
     GCLogWarning(@"The user canceled the approval of the Chute App.");
     [self closePopupWithCompletition:^{
         if (failure) {
             failure([NSError errorWithDomain:@"Chute" code:400 userInfo:nil]);
         }
     }];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [MBProgressHUD showHUDAddedTo:contentView animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [MBProgressHUD hideHUDForView:contentView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [MBProgressHUD hideHUDForView:contentView animated:YES];
    
    if (error.code == NSURLErrorCancelled) return;
    
    if (![[error localizedDescription] isEqualToString:@"Frame load interrupted"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reload", nil] show];
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reload"])
        [self.webView loadRequest:[[GCOAuth2Client sharedClient] requestAccessForLoginType:self.loginType]];
}


@end
