//
//  SXTUserHelper.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/7.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTUserHelper.h"

@implementation SXTUserHelper

+ (instancetype)sharedUser {
    
    static SXTUserHelper * _user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[SXTUserHelper alloc] init];
    });
    return _user;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        _iconUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"iconUrl"];
        
    }
    return self;
}

+ (BOOL)isAutoLogin {
    
    if ([SXTUserHelper sharedUser].nickName.length == 0) {
        return NO;
    }
    return YES;
}

+ (void)saveUser {
    
    SXTUserHelper * user = [SXTUserHelper sharedUser];
    
    if (user.nickName.length != 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:user.nickName forKey:@"nickName"];
        [[NSUserDefaults standardUserDefaults] setObject:user.iconUrl forKey:@"iconUrl"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    
}

@end
