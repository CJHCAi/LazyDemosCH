//
//  GCAsset.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/23/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCComment,GCResponseStatus,GCLinks,GCAssetDimensions,GCAssetSource,GCCoordinate,GCPagination,GCHeart,GCHeartCount, GCVote,GCVoteCount,GCFlag,GCFlagCount, GCUser;

@interface GCAsset : NSObject

@property (strong, nonatomic) NSNumber          *id;
@property (strong, nonatomic) GCLinks           *links;
@property (strong, nonatomic) NSString          *thumbnail;
@property (strong, nonatomic) NSString          *url;
@property (strong, nonatomic) NSString          *type;
@property (strong, nonatomic) NSString          *caption;
@property (strong, nonatomic) GCAssetDimensions *dimensions;
@property (strong, nonatomic) GCAssetSource     *source;
@property (strong, nonatomic) GCCoordinate      *coordinate;
@property (strong, nonatomic) GCUser            *user;
@property (strong, nonatomic) NSString          *videoUrl;
@property (strong, nonatomic) NSDate            *createdAt;
@property (strong, nonatomic) NSDate            *updatedAt;
@property (strong, nonatomic) NSString          *shortcut;
@property (strong, nonatomic) NSString          *service;
@property (strong, nonatomic) NSString          *username;


- (void)updateAssetWithCaption:(NSString *)_caption inAlbumID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

- (void)createComment:(NSString *)comment forAlbumWithID:(NSNumber *)albumID fromUserWithName:(NSString *)name andEmail:(NSString *)email success:(void (^)(GCResponseStatus *responseStatus, GCComment *comment))success failure:(void (^)(NSError *error))failure;

- (void)getCommentsForAssetInAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *comments,GCPagination *pagination))success failure:(void (^)(NSError *error))failure;

- (void)addTags:(NSArray *)tags inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void(^)(NSError *error))failure;

- (void)replaceTags:(NSArray *)tags inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void(^)(NSError *error))failure;

- (void)deleteTags:(NSArray *)tags inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure;

- (void)getTagsForAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus,NSArray *tags))success failure:(void (^)(NSError *error))failure;

- (void)heartAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus,GCHeart *heart))success failure:(void(^)(NSError *error))failure;

- (void)getHeartCountForAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCHeartCount *heartCount))success failure:(void(^)(NSError *error))failure;

- (void)unheartAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCHeart *heart))success failure:(void(^)(NSError *error))failure;

- (void)voteAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCVote *vote))success failure:(void(^)(NSError *error))failure;

- (void)getVoteCountForAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCVoteCount *voteCount))success failure:(void(^)(NSError *error))failure;

- (void)removeVoteForAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCVote *vote))success failure:(void(^)(NSError *error))failure;

- (void)flagAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlag *flag))success failure:(void(^)(NSError *error))failure;

-(void)getFlagCountForAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlagCount *flagCount))success failure:(void(^)(NSError *error))failure;

- (void)removeFlagFromAssetInAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlag *flag))success failure:(void(^)(NSError *error))failure;

@end
