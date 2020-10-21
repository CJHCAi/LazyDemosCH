//
//  GCServiceFlag.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceFlag.h"
#import "GCClient.h"
#import "GCFlagCount.h"
#import "GCFlag.h"
#import "GCResponse.h"

@implementation GCServiceFlag

+ (void)getFlagCountForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCFlagCount *flagCount))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/flags", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCFlagCount class] success:^(GCResponse *response) {
        if([(GCFlagCount *)response.data count] != nil)
            success(response.response, response.data);
        else
        {
            GCFlagCount *flagCount = [GCFlagCount new];
            [flagCount setCount:@0];
            success(response.response, flagCount);
        }
    } failure:failure];
}

+ (void)flagAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCFlag *flag))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/flags", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCFlag class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)removeFlagForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCFlag *flag))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/flags", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCFlag class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}


@end
