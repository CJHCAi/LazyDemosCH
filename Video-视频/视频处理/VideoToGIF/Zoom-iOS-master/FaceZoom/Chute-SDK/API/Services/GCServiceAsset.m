//
//  GCServiceAsset.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceAsset.h"
#import "GCClient.h"
#import "GCAsset.h"
#import "GCResponse.h"

@implementation GCServiceAsset

static NSString * const kGCPerPage = @"per_page";
static NSString * const kGCDefaultPerPage = @"100";

+ (void)getAssetsForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets", albumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:@{kGCPerPage:kGCDefaultPerPage}];
    
    [apiClient request:request factoryClass:[GCAsset class] success:^(GCResponse *response) {
        success(response.response, response.data, response.pagination);
    } failure:failure];
}

+ (void)getAssetWithID:(NSNumber *)assetID fromAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void (^)(NSError *error))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAsset class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)importAssetsFromURLs:(NSArray *)urls forAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *repsonseStatus, NSArray *assets, GCPagination *pagination))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path;
    
    path = [NSString stringWithFormat:@"albums/%@/assets/import", albumID];
    
    NSDictionary *params = @{@"urls":urls};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCAsset class] success:^(GCResponse *response) {
        success(response.response, response.data, response.pagination);
    } failure:failure];
}

+ (void)updateAssetWithID:(NSNumber *)assetID andAlbumID:(NSNumber *)albumID caption:(NSString *)caption success:(void (^)(GCResponseStatus *, GCAsset *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@",albumID, assetID];
    
    NSDictionary *param = @{@"caption":caption};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:path parameters:param];
    
    [apiClient request:request factoryClass:[GCAsset class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

@end
