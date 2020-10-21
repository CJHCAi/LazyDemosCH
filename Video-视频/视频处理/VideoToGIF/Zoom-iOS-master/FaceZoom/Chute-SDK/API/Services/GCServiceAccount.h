//
//  GCServiceAccount.h
//  Chute-SDK
//
//  Created by ARANEA on 7/30/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus;

@interface GCServiceAccount : NSObject

///-----------------------------------
/// @name Managing data from server
///-----------------------------------

/**
 Getting profile info from server. Sets the specified success and failure callbacks.
 
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes two arguments: the responseStatus received from the server response, and an array object containing accounts of type `GCAccount` from the server response data.
 
 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: `NSError` object describing the network or parsing error that occurred.
 
 @warning This method require `GCResponseStatus` class. Add an `#import "GCResponseStatus.h"` in your header/implementation file.
*/
+ (void)getProfileInfoWithSuccess:(void(^)(GCResponseStatus *responseStatus,NSArray *accounts))success failure:(void (^)(NSError *error))failure;

+ (void)deleteAccountWithID:(NSNumber *)accountID success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;


@end
