//
//  LXMSinaWeiboHelper.m
//  LXMThirdLoginManagerDemo
//
//  Created by luxiaoming on 15/5/11.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMSinaWeiboHelper.h"
#import "WeiboSDK.h"
#import "LXMThirdLoginManager.h"
#import "LXMThirdLoginResult.h"



@implementation LXMSinaWeiboHelper

+ (void)setupThirdLogin {
    [WeiboSDK registerApp:[LXMThirdLoginManager sharedManager].kSinaWeiboAppKey];
}

+ (void)requestLogin {
    WBAuthorizeRequest *authorizeRequest = [[WBAuthorizeRequest alloc] init];
    authorizeRequest.scope = @"";
    authorizeRequest.redirectURI = [LXMThirdLoginManager sharedManager].kSinaWeiboRedirectURI;
    authorizeRequest.userInfo = @{};
    authorizeRequest.shouldShowWebViewForAuthIfCannotSSO = YES;
    [WeiboSDK sendRequest:authorizeRequest];
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)self];
}

+ (BOOL)isAppInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

#pragma mark - WeiboAPI

+ (void)requestUserInfoWithLoginResult:(LXMThirdLoginResult *)result completedBlock:(LXMThirdLoginCompleteBlock)completedBlock {
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", result.accessToken, result.openId];
    [LXMThirdLoginManager simpleGet:url completedBlock:^(id response, NSError *error) {
        if (error == nil && response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)response;
            result.userName = dict[@"name"];
            result.signature = dict[@"description"];
            result.avatarUrl = dict[@"profile_image_url"];
            
            result.thirdLoginState = [dict[@"error_code"] integerValue];//错误时才有
            result.message = dict[@"error"];//错误时才有
            
            if ([dict[@"gender"] isEqualToString:@"m"]) {
                result.gender = 1;
            } else if ([dict[@"gender"] isEqualToString:@"f"]) {
                result.gender = 2;
            } else {
                result.gender = 0;
            }
            if (completedBlock) {
                completedBlock(result);
            }
            
        } else {
            if (completedBlock) {
                completedBlock(nil);//不管有什么错误，都返回nil，表示获取信息失败
            }
        }
        
    }];
}

#pragma mark - WeiboSDKDelegate

+ (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) { //登录回调
        WBAuthorizeResponse *result = (WBAuthorizeResponse *)response;
        if (result.userID
            && [result.userID isKindOfClass:[NSString class]]
            && result.userID.length > 0
            && result.accessToken
            && [result.accessToken isKindOfClass:[NSString class]]
            && result.accessToken.length > 0) {
            LXMThirdLoginResult *loginResult = [[LXMThirdLoginResult alloc] init];
            loginResult.thirdLoginType = LXMThirdLoginTypeSinaWeibo;
            loginResult.openId = result.userID;
            loginResult.accessToken = result.accessToken;
            
            if (![LXMThirdLoginManager sharedManager].shouldRequestUserInfo) {
                if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
                    [LXMThirdLoginManager sharedManager].loginCompletedBlcok(loginResult);
                }
            } else {
                //请求nickName等个人信息后返回
                [self requestUserInfoWithLoginResult:loginResult completedBlock:^(LXMThirdLoginResult *thirdLoginResult) {
                    if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
                        [LXMThirdLoginManager sharedManager].loginCompletedBlcok(thirdLoginResult);
                    }
                }];
                
            }
        } else {
            if ([LXMThirdLoginManager sharedManager].loginCompletedBlcok) {
                [LXMThirdLoginManager sharedManager].loginCompletedBlcok(nil);//nil说明是微博没有返回正确的数据
            }
        }
    }
}


@end
