//
//  GCAccount.h
//  Chute-SDK
//
//  Created by ARANEA on 7/30/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus;

@interface GCAccount : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name; // To be displayed in cell
@property (strong, nonatomic) NSString *username; // displayed only for Instagram
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSNumber *uid;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSString *shortcut;
@property (strong, nonatomic) NSString *accessKey;
@property (strong, nonatomic) NSString *accessSecret;

+ (void)getProfileInfoWithSuccess:(void(^)(GCResponseStatus *responseStatus,NSArray *accounts))success failure:(void (^)(NSError *error))failure;

- (void)deleteAccountWithSuccess:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;

@end
