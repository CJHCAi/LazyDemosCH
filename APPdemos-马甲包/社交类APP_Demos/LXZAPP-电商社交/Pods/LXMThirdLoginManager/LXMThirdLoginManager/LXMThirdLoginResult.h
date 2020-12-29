//
//  LXMThirdLoginResult.h
//  LXMThirdLoginManagerDemo
//
//  Created by luxiaoming on 15/5/11.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXMThirdLoginManager.h"

@interface LXMThirdLoginResult : NSObject

@property (nonatomic, assign) NSInteger thirdLoginState;//0成功，其他失败
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) LXMThirdLoginType thirdLoginType;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *unionid; //微信特有
@property (nonatomic, assign) NSTimeInterval expires_in;
@property (nonatomic, copy) NSString *refresh_token;


@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger gender;//0未知，1男，2女，这是统一后的结果
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) NSTimeInterval *birthday;
@property (nonatomic, copy) NSString *avatarUrl;


@end
