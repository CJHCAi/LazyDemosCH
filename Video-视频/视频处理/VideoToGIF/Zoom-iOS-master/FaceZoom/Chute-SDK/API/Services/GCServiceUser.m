//
//  GCServiceUser.m
//  GCAPIv2TestApp
//
//  Created by ARANEA on 11/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceUser.h"
#import "GCClient.h"
#import "GCUser.h"
#import "GCResponse.h"
#import "GCResponseStatus.h"

@implementation GCServiceUser

+ (void)getUserWithSuccess:(void (^)(GCUser *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = @"me";
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCUser class] success:^(GCResponse *response) {
        success(response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)updateUserWithID:(NSNumber *)userID withName:(NSString *)name title:(NSString *)title company:(NSString *)company success:(void (^)(GCResponseStatus *, GCUser *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path =[NSString stringWithFormat:@"users/%@",userID];
    
    NSDictionary *params = @{@"name":name,
                             @"profile":@{@"title":title,
                                          @"company":company}
                             };
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCUser class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
