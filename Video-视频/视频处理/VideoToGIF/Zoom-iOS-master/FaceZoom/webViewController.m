//
//  webViewController.m
//  FaceZoom
//
//  Created by Ben Taylor on 5/14/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "webViewController.h"
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+animatedGIF.h"
#import "CRGradientNavigationBar.h"

@implementation webViewController

@synthesize myString;
@synthesize myWebView;
@synthesize messageController;

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.messageController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.84375 blue:0.28125 alpha:1];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        self.navigationController.navigationBar.translucent = YES;
        //self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        //self.tabBarController.tabBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        //self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
    }
    
    self.messageController = [[MFMessageComposeViewController alloc] init];
    self.messageController.messageComposeDelegate = self;
    
    CGFloat xorigin = ([UIScreen mainScreen].bounds.size.width - 300)/2;
    
    //myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(xorigin, 30, 300, 300)];
    
    myWebView = [[UIImageView alloc]initWithFrame:CGRectMake(xorigin, self.navigationController.navigationBar.bounds.size.height + 50, 300, 300)];
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    //imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSLog(@"this is image path: %@", imagePath);
    
    NSString *HTMLData = @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;'/><html style='height:300px; width:300px'><img src='animated.gif' alt=''style='width:300px; height:300px; margin-top:-8px; margin-left:-8px;' /></html>";

    //[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

    
    //[myWebView loadHTMLString:HTMLData baseURL:[NSURL URLWithString: [NSString stringWithFormat:@"file:/%@//",imagePath]]];
    
    NSString *mypath = @"";
    
    mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    NSLog(@"this is my path: %@", mypath);
    
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:mypath];
    
    UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
    
    myWebView.image = mygif;
    
    [self.view addSubview:myWebView];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
    
}



@end