//
//  VPNAccount.m
//  VPN-Air
//
//  Created by ZQP on 15/10/25.
//  Copyright © 2015年 ZQP. All rights reserved.
//

#import "VPNAccount.h"

@implementation VPNAccount

+ (instancetype)shareManager
{
    static VPNAccount *vpnAccount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vpnAccount = [VPNAccount new];
    });
    
    return vpnAccount;
}

@end
