//
//  VPNConnector.m
//  VPNTool
//
//  Created by Valentin Cherepyanko on 18/11/14.
//  Copyright (c) 2014 Valentin Cherepyanko. All rights reserved.
//

#import "VPNConnector.h"

@implementation VPNConnector

+ (VPNConnector *)instance {
    static VPNConnector *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VPNConnector new];
    });
    return instance;
}

- (void)loadConfig {
    NEVPNManager *manager = [NEVPNManager sharedManager];
    NSLog(@"Hi!");
    [manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Load error: %@", error);
        } else {
            [manager setProtocol:[self getProtocol]];
            [manager setOnDemandEnabled:NO];
            [manager setEnabled:YES];
            [manager setLocalizedDescription:@"Valentin's VPN"];
            
            [manager saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                }
                else {
                    NSLog(@"Saved!");
                }
            }];
        }
    }];
}

- (NEVPNProtocolIPSec*)getProtocol {
    NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
    p.username = ACCOUNT;
    p.passwordReference = [PASSWORD dataUsingEncoding:NSUTF8StringEncoding];
    p.serverAddress = SERVER;
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    p.sharedSecretReference = [SECRET dataUsingEncoding:NSUTF8StringEncoding];
    p.localIdentifier = @"[VPN local identifier]";
    p.remoteIdentifier = @"[VPN remote identifier]";
    p.useExtendedAuthentication = YES;
    p.disconnectOnSleep = NO;
    return p;
}

- (void)connect {
    NSError *startError;
    [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
    
    if(startError) {
        NSLog(@"Start error: %@", startError.localizedDescription);
    } else {
        NSLog(@"Connection established!");
    }
}

@end
