//
//  GCClient.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/7/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "AFHTTPClient.h"


extern NSString * const kGCClientGET;
extern NSString * const kGCClientPOST;
extern NSString * const kGCClientPUT;
extern NSString * const kGCClientDELETE;

@class GCResponse, GCUploads;

@interface GCClient : AFHTTPClient

+ (instancetype)sharedClient;

- (BOOL)isLoggedIn;
- (void)clearCookiesForChute;
- (void)setAuthorizationHeaderWithToken:(NSString *)token;
- (NSString *)authorizationToken;
- (void)request:(NSMutableURLRequest *)request factoryClass:(Class)factoryClass success:(void (^)(GCResponse *))success failure:(void (^)(NSError *))failure;
- (void)parseJSON:(id)JSON withFactoryClass:(Class)factoryClass success:(void (^)(GCResponse *))success;

@end
