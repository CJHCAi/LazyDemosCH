//
//  GCServiceComment.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/22/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceComment.h"
#import "GCClient.h"
#import "GCComment.h"
#import "GCResponse.h"

static NSString * const kGCCommentText = @"comment_text";
static NSString * const kGCCommentName = @"name";
static NSString * const kGCCommentEmail = @"email";

@implementation GCServiceComment

+ (void)getCommentsForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/comments", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCComment class] success:^(GCResponse *response) {
            success(response.response, response.data, response.pagination);
    } failure:failure];
    
}

+ (void)createComment:(NSString *)comment forUserWithName:(NSString *)name andEmail:(NSString *)email forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, GCComment *comment))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    NSParameterAssert(comment);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/comments", albumID, assetID];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:comment forKey:kGCCommentText];
    
    if (name)
        [params setObject:name forKey:kGCCommentName];
    if (email)
        [params setObject:email forKey:kGCCommentEmail];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCComment class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)deleteCommentWithID:(NSNumber *)commentID  success:(void (^)(GCResponseStatus *responseStatus, GCComment *comment))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(commentID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"comments/%@", commentID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];

    [apiClient request:request factoryClass:[GCComment class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
    
}

@end
