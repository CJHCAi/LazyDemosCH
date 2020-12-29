//
//  LXMQQHelper.m
//  LXMThirdLoginManagerDemo
//
//  Created by luxiaoming on 15/5/11.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMQQHelper.h"
#import <TencentOAuth.h>
#import "LXMThirdLoginManager.h"
#import "LXMThirdLoginResult.h"

@interface LXMQQHelper ()<TencentSessionDelegate>

@end

static TencentOAuth *tencentOAuth;

@implementation LXMQQHelper

+ (void)setupThirdLogin {
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:[LXMThirdLoginManager sharedManager].kQQAppKey andDelegate:(id<TencentSessionDelegate>)self];
}

+ (void)requestLogin {
    NSArray *permissions = @[kOPEN_PERMISSION_GET_INFO,
                             kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
    [tencentOAuth authorize:permissions inSafari:NO];
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}

+ (BOOL)isAppInstalled {
    return [TencentOAuth iphoneQQInstalled];
}

#pragma mark - TencentLoginDelegate

+ (void)tencentDidLogin {
    [self createThirdLoginResult];
}

+ (void)tencentDidNotLogin:(BOOL)cancelled {
    [self createThirdLoginResult];
}

+ (void)tencentDidNotNetWork {
    [self createThirdLoginResult];
}

+ (void)getUserInfoResponse:(APIResponse*) response {
    if ([LXMThirdLoginManager sharedManager].shouldRequestUserInfo) {
        if (response.detailRetCode == 0 && response.retCode == 0) {
            LXMThirdLoginResult *loginResult = [[LXMThirdLoginResult alloc] init];
            loginResult.accessToken = tencentOAuth.accessToken;
            loginResult.openId = tencentOAuth.openId;
            loginResult.thirdLoginType = LXMThirdLoginTypeQQ;
            loginResult.expires_in = [tencentOAuth.expirationDate timeIntervalSince1970];
            
            NSDictionary *dict = (NSDictionary *)response.jsonResponse;
            loginResult.userName = dict[@"nickname"];
            loginResult.avatarUrl = dict[@"figureurl_2"];
            if ([dict[@"gender"] isEqualToString:@"男"]) {
                loginResult.gender = 1;
            } else if ([dict[@"gender"] isEqualToString:@"女"]) {
                loginResult.gender = 2;
            }
            
            if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
                [LXMThirdLoginManager sharedManager].loginCompletedBlcok(loginResult);
            }
            
            
        } else {
            if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
                [LXMThirdLoginManager sharedManager].loginCompletedBlcok(nil);//错误
            }
        }
        
        
        
        
    }
}

#pragma mark - privateMethod

+ (void)createThirdLoginResult {
    if (tencentOAuth.accessToken && tencentOAuth.accessToken.length > 0) {
        LXMThirdLoginResult *loginResult = [[LXMThirdLoginResult alloc] init];
        loginResult.accessToken = tencentOAuth.accessToken;
        loginResult.openId = tencentOAuth.openId;
        loginResult.thirdLoginType = LXMThirdLoginTypeQQ;
        loginResult.expires_in = [tencentOAuth.expirationDate timeIntervalSince1970];
        
        if (![LXMThirdLoginManager sharedManager].shouldRequestUserInfo) {
            if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
                [LXMThirdLoginManager sharedManager].loginCompletedBlcok(loginResult);
            }
        } else {
            //这个获取信息貌似是获取qq空间的信息
            [tencentOAuth getUserInfo];
        }

    } else {
        if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
            [LXMThirdLoginManager sharedManager].loginCompletedBlcok(nil);//nil是没有有效数据
        }
    }
}



@end
