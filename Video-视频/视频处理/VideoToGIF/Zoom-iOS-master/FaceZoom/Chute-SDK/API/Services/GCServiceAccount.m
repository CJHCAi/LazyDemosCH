//
//  GCServiceAccount.m
//  Chute-SDK
//
//  Created by ARANEA on 7/30/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceAccount.h"
#import "GCAccount.h"

#import "GCResponse.h"
#import "GCClient.h"
#import "GCResponseStatus.h"

@implementation GCServiceAccount

+ (void)getProfileInfoWithSuccess:(void (^)(GCResponseStatus *, NSArray *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"me/accounts"];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];

    [apiClient request:request factoryClass:[GCAccount class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)deleteAccountWithID:(NSNumber *)accountID success:(void(^)(GCResponseStatus *))success failure:(void(^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"me/accounts/%@",accountID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:failure];
}

@end
