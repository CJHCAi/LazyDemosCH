//
//  ALBBSession.h
//  AlibabaAuthSDK
//
//  Created by Bangzhe Liu on 6/17/16.
//  Copyright © 2016 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBUser.h"

@interface ALBBSession : NSObject
@property(nonatomic, assign)BOOL isCanceledByUser;
@property(nonatomic, copy)NSString* bindCode;

/**
 @return 返回单例
 */
+ (ALBBSession *)sharedInstance;

/**
 如果未登录或者登录态已经过期,返回NO
 @return 当前会话是否登录有效
 */
- (BOOL)isLogin;

/**
 @return 返回User对象
 */
- (ALBBUser *)getUser;

@end
