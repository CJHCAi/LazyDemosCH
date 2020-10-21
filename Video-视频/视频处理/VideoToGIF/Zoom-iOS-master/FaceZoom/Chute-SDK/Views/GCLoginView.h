//
//  GCLoginView2.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPopupView.h"
#import "GCOAuth2Client.h"

@interface GCLoginView : GCPopupView <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) GCLoginType loginType;
@property (nonatomic, copy) void (^success)(void);
@property (nonatomic, copy) void (^failure)(NSError *);

+ (void)showLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure;
+ (void)showInView:(UIView *)_view withLoginType:(GCLoginType)_loginType ;
+ (void)showInView:(UIView *)_view withLoginType:(GCLoginType)_loginType  success:(void(^)(void))_success failure:(void (^)(NSError *))_failure;
+ (void)showInView:(UIView *)_view fromStartPoint:(CGPoint)startPoint withLoginType:(GCLoginType)_loginType;
+ (void)showInView:(UIView *)_view fromStartPoint:(CGPoint)startPoint withLoginType:(GCLoginType)_loginType  success:(void(^)(void))_success failure:(void (^)(NSError *))_failure;

- (id)initWithFrame:(CGRect)frame inParentView:(UIView *)parentView;

@end
