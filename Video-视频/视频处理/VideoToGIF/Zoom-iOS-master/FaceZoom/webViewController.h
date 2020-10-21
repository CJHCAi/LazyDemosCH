//
//  webViewController.h
//  FaceZoom
//
//  Created by Ben Taylor on 5/14/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface webViewController : UIViewController <MFMessageComposeViewControllerDelegate>



//@property (strong, nonatomic) UIWebView *myWebView;
@property(strong, nonatomic)UIImageView *myWebView;
@property(weak, nonatomic) NSURL *myString;
@property (nonatomic, strong) MFMessageComposeViewController *messageController;


@end
