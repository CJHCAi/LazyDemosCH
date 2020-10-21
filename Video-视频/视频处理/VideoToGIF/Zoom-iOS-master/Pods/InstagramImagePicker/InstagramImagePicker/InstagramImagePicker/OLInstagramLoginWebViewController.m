//
//  InstagramLoginWebViewController.m
//  Ps
//
//  Created by Deon Botha on 09/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import "OLInstagramLoginWebViewController.h"
#import "OLInstagramImagePickerConstants.h"
#import <NXOAuth2Client/NXOAuth2.h>

@interface OLInstagramLoginWebViewController () <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSURL *authURL;
@end

@implementation OLInstagramLoginWebViewController

- (id)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Log In", @"");
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/256.0 green:41.0/256.0 blue:41.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];

    
    self.webView.delegate = self;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onButtonCancelClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    // Hide th back button and set custom title view that looks the same as the default. The reason for this is because by default
    // when this view is pushed onto the navigation stack these items would animate, we actually don't want that behaviour as our
    // push view controller transition is a flip of the screen.
    [self.navigationItem setHidesBackButton:YES];
    UILabel *title = [[UILabel alloc] init];
    title.text = self.title;
    title.font = [UIFont boldSystemFontOfSize:title.font.pointSize];
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    self.navigationItem.titleView = title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startAuthenticatingUser];
}

- (void)startAuthenticatingUser {
    self.activityIndicator.hidden = NO;
    [self.webView loadHTMLString:@"" baseURL:nil]; // clear WebView as we may be coming back to it for a second time and don't want any content to be on display.
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"instagram"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                       self.authURL = preparedURL;
                                       [self.webView loadRequest:[NSURLRequest requestWithURL:self.authURL]];
                                   }];
}

- (void)onButtonCancelClicked {
    [self.webView stopLoading];
    [self.delegate instagramLoginWebViewControllerDidCancelLogIn:self];
}

- (NSString *)url:(NSURL *)url queryValueForName:(NSString *)name {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray *parts = [param componentsSeparatedByString:@"="];
        if([parts count] < 2) {
            continue;
        }
        
        [params setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
    }
    
    return params[name];
}

#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:self.redirectURI]) {
        [self.webView stopLoading];
        BOOL handled = [[NXOAuth2AccountStore sharedStore] handleRedirectURL:request.URL];
        if (!handled) {
            // Show the user a error message.
            NSString *errorReason = [self url:request.URL queryValueForName:@"error_reason"];
            NSString *errorCode = [self url:request.URL queryValueForName:@"error"];
            NSString *errorDescription = [self url:request.URL queryValueForName:@"error_description"];
            
            if ([errorCode isEqualToString:@"access_denied"] && [errorReason isEqualToString:@"user_denied"]) {
                errorDescription = NSLocalizedString(@"You need to authorize the app to access your Instagram account if you want to import photos from there.", @"");
            } else {
                errorDescription = [errorDescription stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                errorDescription = [errorDescription stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
            [self.delegate instagramLoginWebViewControllerDidComplete:self withError:[NSError errorWithDomain:kOLInstagramImagePickerErrorDomain code:kOLInstagramImagePickerErrorOAuthLoginFailed userInfo:@{NSLocalizedDescriptionKey: errorDescription}]];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.activityIndicator.hidden = YES;
}

@end
