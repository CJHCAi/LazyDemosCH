//
//  GCAlbum.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCAsset,GCResponseStatus,GCPagination,GCLinks,GCCounter,GCUser;

@interface GCAlbum : NSObject

@property (strong, nonatomic) NSNumber  *id;
@property (strong, nonatomic) NSNumber  *parentID;
@property (strong, nonatomic) GCLinks   *links;
@property (strong, nonatomic) GCCounter *counters;
@property (strong, nonatomic) NSString  *shortcut;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) GCUser    *user;
@property (assign, nonatomic) BOOL      moderateMedia;
@property (assign, nonatomic) BOOL      moderateComments;
@property (strong, nonatomic) NSDate    *createdAt;
@property (strong, nonatomic) NSDate    *updatedAt;
@property (strong, nonatomic) NSString  *description;
@property (strong, nonatomic) GCAsset   *coverAsset;
@property (strong, nonatomic) NSNumber  *imagesCount;
@property (strong, nonatomic) GCAsset   *asset;


+ (void)getAllAlbumsWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination))success failure:(void(^)(NSError *error))failure;

+ (void)getAllAlbumsWithCoverAssetWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination))success failure:(void(^)(NSError *error))failure;

- (void)getAlbumWithSuccess:(void(^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void(^)(NSError *error))failure;

+ (void)createAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;

+ (void)createAlbumWithName:(NSString *)name withCoverAssetWithID:(NSNumber *)coverAssetID moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;

- (void)updateAlbumWithName:(NSString *)_name coverAssetID:(NSNumber *)coverAssetID moderateMedia:(BOOL)_moderateMedia moderateComments:(BOOL)_moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;

- (void)updateAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;

- (void)deleteAlbumWithSuccess:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;

- (void)addAssets:(NSArray *)asssetsArray success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;

- (void)removeAssets:(NSArray *)asssetsArray success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;

- (void)getAssetWithID:(NSNumber *)assetID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

- (void)getAllAssetsWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void(^)(NSError *error))failure;

- (void)importAssetsFromURLs:(NSArray *)urls success:(void(^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void(^)(NSError *error))failure;

- (void)moveAssetWithID:(NSNumber *)assetID toAlbumWithID:(NSNumber *)destinationAlbumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

- (void)copyAssetWithID:(NSNumber *)assetID toAlbumWithID:(NSNumber *)destinationAlbumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

- (void)listAllAlbumsWithinWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *listOfAlbums))success failure:(void(^)(NSError *error))failure;

@end
