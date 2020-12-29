//
//  LXMWeChatHelper.h
//  LXMThirdLoginManagerDemo
//
//  Created by luxiaoming on 15/5/11.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXMWeChatHelper : NSObject

+ (void)setupThirdLogin;

+ (void)requestLogin;

+ (BOOL)handleOpenUrl:(NSURL *)url;

+ (BOOL)isAppInstalled;

@end
