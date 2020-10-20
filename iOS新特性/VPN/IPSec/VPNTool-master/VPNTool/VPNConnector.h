//
//  VPNConnector.h
//  VPNTool
//
//  Created by Valentin Cherepyanko on 18/11/14.
//  Copyright (c) 2014 Valentin Cherepyanko. All rights reserved.
//

#define ACCOUNT @"vpnuser"
#define PASSWORD @"a3ztPw4mJdGoAffn"
#define SERVER @"207.148.89.94"
#define SECRET @"85i72626K467wwFR"

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>

@interface VPNConnector : NSObject

+ (VPNConnector *)instance;
- (void)loadConfig;
- (void)connect;

@end
