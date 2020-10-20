//
//  SXTCacheHelper.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/6.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTCacheHelper.h"

#define advertiseImage @"adImage"

@implementation SXTCacheHelper

+ (NSString *)getAdvertise {
    
   return [[NSUserDefaults standardUserDefaults] objectForKey:advertiseImage];
}

+ (void)setAdvertise:(NSString *)adImage {
    
    [[NSUserDefaults standardUserDefaults] setObject:adImage forKey:advertiseImage];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
