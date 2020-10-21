//
//  GCAsset.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/23/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCAsset.h"
#import "GCClient.h"
#import "GCServiceAsset.h"
#import "GCServiceComment.h"
#import "GCServiceTag.h"
#import "GCServiceHeart.h"
#import "GCServiceVote.h"
#import "GCServiceFlag.h"
#import "GCResponseStatus.h"
#import "GCPagination.h"

@implementation GCAsset

@synthesize id, links, thumbnail, url, type, caption, dimensions, source, user, videoUrl, updatedAt, createdAt, shortcut, service, username;

- (void)updateAssetWithCaption:(NSString *)_caption inAlbumID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset updateAssetWithID:self.id andAlbumID:albumID caption:_caption success:^(GCResponseStatus *responseStatus, GCAsset *asset) {
        success(responseStatus, asset);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)createComment:(NSString *)comment forAlbumWithID:(NSNumber *)albumID fromUserWithName:(NSString *)name andEmail:(NSString *)email success:(void (^)(GCResponseStatus *responseStatus, GCComment *comment))success failure:(void (^)(NSError *error))failure
{
    [GCServiceComment createComment:comment forUserWithName:name andEmail:email forAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *responseStatus, GCComment *comment) {
        success(responseStatus, comment);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getCommentsForAssetInAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *comments,GCPagination *pagination))success failure:(void (^)(NSError *error))failure
{
    [GCServiceComment getCommentsForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination) {
        success(responseStatus,comments,pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)addTags:(NSArray *)tags inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void(^)(NSError *error))failure
{
    [GCServiceTag addTags:tags forAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *responseStatus, NSArray *tags) {
        success(responseStatus, tags);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)replaceTags:(NSArray *)tags inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void(^)(NSError *error))failure
{
    [GCServiceTag replaceTags:tags forAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *responseStatus, NSArray *tags) {
        success(responseStatus,tags);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteTags:(NSArray *)tags inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure
{
    [GCServiceTag deleteTags:tags forAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *responseStatus, NSArray *tags) {
        success(responseStatus,tags);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getTagsForAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus,NSArray *tags))success failure:(void (^)(NSError *error))failure
{
    [GCServiceTag getTagsForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *responseStatus, NSArray *tags) {
        success(responseStatus,tags);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)heartAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus,GCHeart *heart))success failure:(void(^)(NSError *error))failure
{
    [GCServiceHeart heartAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCHeart *heart) {
        success(response, heart);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getHeartCountForAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCHeartCount *heartCount))success failure:(void(^)(NSError *error))failure
{
    [GCServiceHeart getHeartCountForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCHeartCount *heartCount) {
        success(response, heartCount);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)unheartAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCHeart *heart))success failure:(void(^)(NSError *error))failure
{
    [GCServiceHeart unheartAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCHeart *heart) {
        success(response,heart);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)voteAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCVote *vote))success failure:(void(^)(NSError *error))failure
{
    [GCServiceVote voteAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCVote *vote) {
        success(response,vote);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getVoteCountForAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCVoteCount *voteCount))success failure:(void(^)(NSError *error))failure
{
    [GCServiceVote getVoteCountForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCVoteCount *voteCount) {
        success(response,voteCount);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)removeVoteForAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCVote *vote))success failure:(void(^)(NSError *error))failure
{
    [GCServiceVote removeVoteForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCVote *vote) {
        success(response,vote);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)flagAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlag *flag))success failure:(void(^)(NSError *error))failure
{
    [GCServiceFlag flagAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCFlag *flag) {
        success(response, flag);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)getFlagCountForAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlagCount *flagCount))success failure:(void(^)(NSError *error))failure
{
    [GCServiceFlag getFlagCountForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCFlagCount *flagCount) {
        success(response, flagCount);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)removeFlagFromAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlag *flag))success failure:(void(^)(NSError *error))failure
{
    [GCServiceFlag removeFlagForAssetWithID:self.id inAlbumWithID:albumID success:^(GCResponseStatus *response, GCFlag *flag) {
        success(response,flag);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
 
@end
