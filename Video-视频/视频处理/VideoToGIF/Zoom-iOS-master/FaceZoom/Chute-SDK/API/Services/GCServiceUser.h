//
//  GCServiceUser.h
//  GCAPIv2TestApp
//
//  Created by ARANEA on 11/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCUser, GCResponseStatus;

@interface GCServiceUser : NSObject

+ (void)getUserWithSuccess:(void(^)(GCUser *user))success failure:(void(^)(NSError *error))failure;

+ (void)updateUserWithID:(NSNumber *)userID withName:(NSString *)name title:(NSString *)title company:(NSString *)company success:(void(^)(GCResponseStatus *responseStatus, GCUser *user))success failure:(void(^)(NSError *error))failure;

@end
