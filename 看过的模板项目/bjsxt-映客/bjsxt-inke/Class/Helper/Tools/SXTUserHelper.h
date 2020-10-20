//
//  SXTUserHelper.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/7.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXTUserHelper : NSObject

@property (nonatomic, copy) NSString * iconUrl;

@property (nonatomic, copy) NSString * nickName;

+ (instancetype)sharedUser;

+ (BOOL)isAutoLogin;

+ (void)saveUser;


@end
