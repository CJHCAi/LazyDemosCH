//
//  LXMThirdLoginManager.m
//  LXMThirdLoginManagerDemo
//
//  Created by luxiaoming on 15/5/11.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMThirdLoginManager.h"
#import "LXMSinaWeiboHelper.h"
#import "LXMWeChatHelper.h"
#import "LXMQQHelper.h"
#import "LXMThirdLoginResult.h"


@interface LXMThirdLoginManager ()

@property (nonatomic, copy, readwrite) LXMThirdLoginCompleteBlock loginCompletedBlcok;

@property (nonatomic, copy, readwrite) NSString *kSinaWeiboAppKey;
@property (nonatomic, copy, readwrite) NSString *kSinaWeiboRedirectURI;
@property (nonatomic, copy, readwrite) NSString *kWeChatAppKey;
@property (nonatomic, copy, readwrite) NSString *kWeChatAppSecret;
@property (nonatomic, copy, readwrite) NSString *kQQAppKey;


@end

@implementation LXMThirdLoginManager

+ (instancetype)sharedManager {
    static LXMThirdLoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldRequestUserInfo = YES;
    }
    return self;
    
}

- (void)setupWithSinaWeiboAppKey:(NSString *)sinaWeiboAppKey SinaWeiboRedirectURI:(NSString *)sinaWeiboRedirectURI WeChatAppKey:(NSString *)weChatAppKey WeChatAppSecret:(NSString *)weChatAppSecret QQAppKey:(NSString *)qqAppKey {
    if (sinaWeiboAppKey && sinaWeiboRedirectURI) {
        self.kSinaWeiboAppKey = sinaWeiboAppKey;
        self.kSinaWeiboRedirectURI = sinaWeiboRedirectURI;
        [LXMSinaWeiboHelper setupThirdLogin];
    }
    if (weChatAppKey && weChatAppSecret) {
        self.kWeChatAppKey = weChatAppKey;
        self.kWeChatAppSecret = weChatAppSecret;
        [LXMWeChatHelper setupThirdLogin];
    }
    if (qqAppKey) {
        self.kQQAppKey = qqAppKey;
        [LXMQQHelper setupThirdLogin];
    }
}

- (void)requestLoginWithThirdType:(LXMThirdLoginType)thirdLoginType completeBlock:(LXMThirdLoginCompleteBlock)completeBlock {
    self.loginCompletedBlcok = completeBlock;
    switch (thirdLoginType) {
        case LXMThirdLoginTypeSinaWeibo:
            [LXMSinaWeiboHelper requestLogin];
            break;
        case LXMThirdLoginTypeWeChat:
            [LXMWeChatHelper requestLogin];
            break;
        case LXMThirdLoginTypeQQ:
            [LXMQQHelper requestLogin];
            break;
        default:
            break;
    }
   

}

- (BOOL)handleOpenUrl:(NSURL *)url {
    if ([url.scheme hasSuffix:self.kSinaWeiboAppKey]) {
        return [LXMSinaWeiboHelper handleOpenUrl:url];
    } else if ([url.scheme hasSuffix:self.kWeChatAppKey]) {
        return [LXMWeChatHelper handleOpenUrl:url];
    } else if ([url.scheme hasSuffix:self.kQQAppKey]) {
        return [LXMQQHelper handleOpenUrl:url];
    } else {
        return NO;
    }
}

#pragma mark - 检查是否安装

+ (BOOL)isAppInstalled:(LXMThirdLoginType)type {
    switch (type) {
        case LXMThirdLoginTypeSinaWeibo:
            return [LXMSinaWeiboHelper isAppInstalled];
            break;
        case LXMThirdLoginTypeWeChat:
            return [LXMWeChatHelper isAppInstalled];
            break;
        case LXMThirdLoginTypeQQ:
            return [LXMQQHelper isAppInstalled];
            break;
        default:
            return NO;
            break;
    }
}

#pragma mark - network

+ (void)simpleGet:(NSString *)url completedBlock:(void(^)(id response, NSError *error))completedBlcok {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (completedBlcok) {
                completedBlcok(responseObject, connectionError);
            }
        } else {
            if (completedBlcok) {
                completedBlcok(nil, connectionError);
            }
        }
    }];
}

@end
