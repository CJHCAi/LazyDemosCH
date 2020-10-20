//
//  SXSubmitLoadingView.h
//  TPORoot
//
//  Created by SunX on 14-7-9.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXLoadingView : NSObject

+ (void)showAlertHUD:(NSString *)aString duration:(CGFloat)duration;
+ (void)showProgressHUD:(NSString *)aString duration:(CGFloat)duration;
+ (void)showProgressHUD:(NSString *)aString;
+ (void)hideProgressHUD;
+ (void)updateProgressHUD:(NSString*)progress;

@end
