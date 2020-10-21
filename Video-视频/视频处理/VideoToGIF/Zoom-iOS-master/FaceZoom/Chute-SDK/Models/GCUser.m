//
//  GCUser.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCUser.h"
#import "GCServiceUser.h"
#import "GCResponseStatus.h"

@implementation GCUser

@synthesize id, links, name, username, avatar, profile, email, status, createdAt, updatedAt;

+ (void)getUserWithSuccess:(void (^)(GCUser *))success failure:(void (^)(NSError *))failure
{
    [GCServiceUser getUserWithSuccess:^(GCUser *user) {
        success(user);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)updateUserWithName:(NSString *)_name title:(NSString *)_title company:(NSString *)_company success:(void (^)(GCResponseStatus *, GCUser *))success failure:(void (^)(NSError *))failure
{
    [GCServiceUser updateUserWithID:self.id withName:_name title:_title company:_company success:^(GCResponseStatus *responseStatus, GCUser *user) {
        success(responseStatus,user);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
