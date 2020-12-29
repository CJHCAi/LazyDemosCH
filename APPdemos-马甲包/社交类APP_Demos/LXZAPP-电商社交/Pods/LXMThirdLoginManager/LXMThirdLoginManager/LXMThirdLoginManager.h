//
//  LXMThirdLoginManager.h
//  LXMThirdLoginManagerDemo
//
//  Created by luxiaoming on 15/5/11.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LXMThirdLoginType) {
    LXMThirdLoginTypeSinaWeibo = 0,
    LXMThirdLoginTypeWeChat = 1,
    LXMThirdLoginTypeQQ = 2,
};

@class LXMThirdLoginResult;

typedef void(^LXMThirdLoginCompleteBlock)(LXMThirdLoginResult *thirdLoginResult);

@interface LXMThirdLoginManager : NSObject

@property (nonatomic, copy, readonly) NSString *kSinaWeiboAppKey;
@property (nonatomic, copy, readonly) NSString *kSinaWeiboRedirectURI;
@property (nonatomic, copy, readonly) NSString *kWeChatAppKey;
@property (nonatomic, copy, readonly) NSString *kWeChatAppSecret;
@property (nonatomic, copy, readonly) NSString *kQQAppKey;

/**
 *  是否在获取到openID和accessToken之后调用其他接口获取userInfo，default is YES;
 */
@property (nonatomic, assign) BOOL shouldRequestUserInfo;


@property (nonatomic, copy, readonly) LXMThirdLoginCompleteBlock loginCompletedBlcok;


+ (instancetype)sharedManager;

+ (BOOL)isAppInstalled:(LXMThirdLoginType)type;

- (void)setupWithSinaWeiboAppKey:(NSString *)sinaWeiboAppKey SinaWeiboRedirectURI:(NSString *)sinaWeiboRedirectURI WeChatAppKey:(NSString *)weChatAppKey WeChatAppSecret:(NSString *)weChatAppSecret QQAppKey:(NSString *)qqAppKey;


/**
 * thirdLoginResult不为nil且thirdLoginResult.thirdLoginState==0的时候成功
 */
- (void)requestLoginWithThirdType:(LXMThirdLoginType)thirdLoginType completeBlock:(LXMThirdLoginCompleteBlock)completeBlock;

- (BOOL)handleOpenUrl:(NSURL *)url;

/**
 *  简单的网络请求方法，调用第三方api可能会用到
 */
+ (void)simpleGet:(NSString *)url completedBlock:(void(^)(id response, NSError *error))completedBlcok;

@end
