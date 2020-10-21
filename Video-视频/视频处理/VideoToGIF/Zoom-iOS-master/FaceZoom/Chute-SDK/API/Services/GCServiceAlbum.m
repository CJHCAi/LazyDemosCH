//
//  GCServiceAlbum.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceAlbum.h"
#import "GCClient.h"
#import "GCResponseStatus.h"
#import "GCAlbum.h"
#import "GCAsset.h"
#import "GCResponse.h"

static NSString * const kGCDefaultAlbumName = @"Album";
static NSString * const kGCPerPage = @"per_page";
static NSString * const kGCDefaultPerPage = @"100";

@implementation GCServiceAlbum

+ (void)getAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure {
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@", albumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)getAlbumsWithCoverAsset:(BOOL)includeAsset success:(void (^)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = @"albums";
    
    NSDictionary *params = [[NSDictionary alloc] init];
    
    if(includeAsset)
        params = @{kGCPerPage:kGCDefaultPerPage,
                   @"include":@"asset"};
    else
        params = @{kGCDefaultPerPage:kGCDefaultPerPage};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data, response.pagination);
    } failure:failure];
}

+ (void)createAlbumWithName:(NSString *)name withCoverAssetWithID:(NSNumber *)coverAssetID moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums"];
    
    /*
     GCAlbum *album = [GCAlbum new];
     [album setName:name];
     [album setModerateMedia:moderateMedia];
     [album setModerateComments:moderateComments];
     
     DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCAlbum class]];
     
     NSDictionary *params = [mapping serializeObject:album];
     */
    
    if (moderateMedia == nil)
        moderateMedia = NO;
    if (moderateComments == nil)
        moderateComments = NO;
    if (name == nil)
        name = @"Album";
    
    NSDictionary *params = [[NSDictionary alloc] init];
    
    if(coverAssetID == nil)
        params = @{@"name":name,
                   @"moderate_media":@(moderateMedia),
                   @"moderate_comments":@(moderateComments)};
    else
        params = @{@"name":name,
                   @"moderate_media":@(moderateMedia),
                   @"moderate_comments":@(moderateComments),
                   @"cover_asset_id":coverAssetID};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}


+ (void)updateAlbumWithID:(NSNumber *)albumID name:(NSString *)name coverAssetID:(NSNumber *)coverAssetID moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@", albumID];
    
    /*
     GCAlbum *album = [GCAlbum new];
     [album setName:name];
     [album setModerateMedia:moderateMedia];
     [album setModerateComments:moderateComments];
     
     DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCAlbum class]];
     
     NSDictionary *params = [mapping serializeObject:album];
     */
    
    if (moderateMedia == nil)
        moderateMedia = NO;
    if (moderateComments == nil)
        moderateComments = NO;
    if (name == nil)
        name = kGCDefaultAlbumName;
    
    NSDictionary *params = [[NSDictionary alloc] init];
    
    if(coverAssetID != nil)
        params = @{@"name":name,
                   @"moderate_media":@(moderateMedia),
                   @"moderate_comments":@(moderateComments),
                   @"cover_asset_id":coverAssetID};
    else
        params = @{@"name":name,
                   @"moderate_media":@(moderateMedia),
                   @"moderate_comments":@(moderateComments)};
    
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)deleteAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@", albumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:failure];
}

+ (void)addAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    if ([assetsArray count] == 0) {
        return;
    }
    else if([assetsArray[0] isKindOfClass:[GCAsset class]]) {
        
        NSMutableArray *arrayWithIDs = [NSMutableArray new];
        
        [assetsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [arrayWithIDs insertObject:[obj id] atIndex:idx];
            
        }];
        
        assetsArray = arrayWithIDs;
        
    }
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/add_assets", albumID];
    
    NSDictionary *params = @{@"asset_ids":assetsArray};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];

    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:failure];
}

+ (void)removeAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure {

    GCClient *apiClient = [GCClient sharedClient];
    
    if ([assetsArray count] == 0) {
        return;
    }
    else if([assetsArray[0] isKindOfClass:[GCAsset class]]) {
        
        NSMutableArray *arrayWithIDs = [NSMutableArray new];
        
        [assetsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [arrayWithIDs insertObject:[obj id] atIndex:idx];
            
        }];
        
        assetsArray = arrayWithIDs;
    }
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/remove_assets", albumID];
    
    NSDictionary *params = @{@"asset_ids":assetsArray};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:failure];
    
}

+ (void)moveAssetWithID:(NSNumber *)assetID fromAlbumWithID:(NSNumber *)sourceAlbumID toAlbumWithID:(NSNumber *)destinationAlbumID success:(void (^)(GCResponseStatus *, GCAsset *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/move/%@", sourceAlbumID, assetID,destinationAlbumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAsset class] success:^(GCResponse *response) {
        success(response.response,response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)copyAssetWithID:(NSNumber *)assetID fromAlbumWithID:(NSNumber *)sourceAlbumID toAlbumWithID:(NSNumber *)destinationAlbumID success:(void (^)(GCResponseStatus *, GCAsset *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/copy/%@", sourceAlbumID, assetID,destinationAlbumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAsset class] success:^(GCResponse *response) {
        success(response.response,response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)listAllAlbumsWithinForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *, NSArray *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/albums",albumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
