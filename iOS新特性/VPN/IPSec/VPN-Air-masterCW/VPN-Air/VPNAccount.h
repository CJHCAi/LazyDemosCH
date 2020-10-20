//
//  VPNAccount.h
//  VPN-Air
//
//  Created by ZQP on 15/10/25.
//  Copyright © 2015年 ZQP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNAccount : NSObject

@property (nonatomic, retain) NSString * severAddress;
@property (nonatomic, retain) NSString * vpnUserName;
@property (nonatomic, retain) NSString * vpnUserPassword;
@property (nonatomic, retain) NSString * sharePsk;

+ (instancetype)shareManager;

@end
