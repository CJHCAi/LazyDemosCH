//
//  GCServiceTag.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/24/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceTag.h"
#import "GCClient.h"
#import "GCResponse.h"

static NSString * const kGCTags = @"tags";

@implementation GCServiceTag

+ (void)getTagsForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure
{
    
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/tags", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];

    
}

+ (void)addTags:(NSArray *)tags forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(tags);
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/tags", albumID, assetID];
    NSDictionary *params = @{kGCTags: tags};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)replaceTags:(NSArray *)tags forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(tags);
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/tags", albumID, assetID];
    NSDictionary *params = @{kGCTags: tags};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:path parameters:params];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)deleteTags:(NSArray *)tags forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(tags);
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *stringTags = [tags componentsJoinedByString:@","];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/tags/%@", albumID, assetID, stringTags];
    //    NSDictionary *params = @{kGCTags: tags};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];

}

@end
