//
//  GCUser.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCLinks, GCUserProfile, GCResponseStatus;

@interface GCUser : NSObject

@property (strong, nonatomic) NSNumber      *id;
@property (strong, nonatomic) GCLinks       *links;
@property (strong, nonatomic) NSString      *name;
@property (strong, nonatomic) NSString      *username;
@property (strong, nonatomic) NSString      *avatar;
@property (strong, nonatomic) GCUserProfile *profile;
@property (strong, nonatomic) NSString      *email;
@property (strong, nonatomic) NSString      *status;
@property (strong, nonatomic) NSDate        *createdAt;
@property (strong, nonatomic) NSDate        *updatedAt;

+ (void)getUserWithSuccess:(void(^)(GCUser *user))success failure:(void(^)(NSError *error))failure;

- (void)updateUserWithName:(NSString *)name title:(NSString *)title company:(NSString *)company success:(void (^)(GCResponseStatus *responseStatus, GCUser *user))success failure:(void (^)(NSError *))failure;


@end
