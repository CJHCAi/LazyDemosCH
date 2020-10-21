//
//  InstagramLoginWebViewController.h
//  Ps
//
//  Created by Deon Botha on 09/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLInstagramLoginWebViewController;

@protocol OLInstagramLoginWebViewControllerDelegate
- (void)instagramLoginWebViewControllerDidCancelLogIn:(OLInstagramLoginWebViewController *)loginController;
- (void)instagramLoginWebViewControllerDidCompleteSuccessfully:(OLInstagramLoginWebViewController *)loginController;
- (void)instagramLoginWebViewControllerDidComplete:(OLInstagramLoginWebViewController *)loginController withError:(NSError *)error;
@end

@interface OLInstagramLoginWebViewController : UIViewController
@property (nonatomic, weak) id<OLInstagramLoginWebViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *redirectURI;
- (void)startAuthenticatingUser;
@end
