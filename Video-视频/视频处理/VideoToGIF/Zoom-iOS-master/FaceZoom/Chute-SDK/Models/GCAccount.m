//
//  GCAccount.m
//  Chute-SDK
//
//  Created by ARANEA on 7/30/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCAccount.h"
#import "GCServiceAccount.h"
#import "GCResponseStatus.h"

@implementation GCAccount

@synthesize id, type, name, username, email, createdAt, updatedAt, shortcut, accessKey, accessSecret;

+ (void)getProfileInfoWithSuccess:(void (^)(GCResponseStatus *, NSArray *))success failure:(void (^)(NSError *))failure
{
    [GCServiceAccount getProfileInfoWithSuccess:^(GCResponseStatus *responseStatus, NSArray *accounts) {
        success(responseStatus,accounts);
    } failure:failure];
}

- (void)deleteAccountWithSuccess:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure
{
    [GCServiceAccount deleteAccountWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:failure];
}


@end
