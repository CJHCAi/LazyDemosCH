//
//  AlibabaAuthSDK.h
//  AlibabaAuthSDK
//
//  Created by Bangzhe Liu on 6/15/16.
//  Copyright © 2016 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ALBBSession.h"

#ifndef ALBBNotificationUserLoggedIn
#define ALBBNotificationUserLoggedIn                  @"ALBB_NOTIFICATION_USER_LOGGED_IN"
#endif

#ifndef ALBBNotificationUserLoggedOut
#define ALBBNotificationUserLoggedOut                 @"ALBB_NOTIFICATION_USER_LOGGED_OUT"
#endif

#ifndef ALBBNotificationUserGiveUpLogin
#define ALBBNotificationUserGiveUpLogin               @"ALBB_NOTIFICATION_USER_GIVE_UP_LOGIN"
#endif

#define ALBB_SDK_VERSION @"1.1.0.6"

/** 回调定义 */
typedef void (^loginSuccessCallback)(ALBBSession *session);
typedef void (^loginFailureCallback)(ALBBSession *session,NSError *error);
typedef void (^loginResultHandler)(ALBBSession *session);

@interface ALBBSDK : NSObject

+ (ALBBSDK *)sharedInstance;

//必须在主线程调用
- (void)ALBBSDKInit;

- (void)auth:(UIViewController *)parentController
successCallback:(loginSuccessCallback) onSuccess
failureCallback:(loginFailureCallback) onFailure;

/**
 设置总的登录成功失败回调
 @param handler 登录结果的处理handler,可以通过TaeSession isLogin判断当前登录态
 */
- (void)setLoginResultHandler:(void (^)(ALBBSession *session))loginResultHandler;

/**
 退出登录
 */
- (void)logout;

/**
 是否是登录URL
 */
- (BOOL)isLoginURL:(NSString *)url;

/**
 是否是登出URL
 */
- (BOOL)isLogoutUrl:(NSString *)url;

/**
 是否是手淘跳回url
 */
- (BOOL)isTBBackUrl:(NSString *)url;

/**
 手淘跳转回来，拿到url调用
 @return (BOOL) 调用是否成功
 */
- (void)loginByURL:(NSURL *)url;

//如果是接入的极简版本需要手动设置appkey
- (void)setAppkey : (NSString *)appKey;

@end
