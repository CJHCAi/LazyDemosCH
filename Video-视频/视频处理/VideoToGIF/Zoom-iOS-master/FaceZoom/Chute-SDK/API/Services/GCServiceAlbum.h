//
//  GCServiceAlbum.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCAlbum, GCPagination,GCAsset;

@interface GCServiceAlbum : NSObject

+ (void)getAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (void)getAlbumsWithCoverAsset:(BOOL)includeAsset success:(void (^)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination))success failure:(void (^)(NSError *error))failure;
+ (void)createAlbumWithName:(NSString *)name withCoverAssetWithID:(NSNumber *)coverAssetID moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (void)updateAlbumWithID:(NSNumber *)albumID name:(NSString *)name coverAssetID:(NSNumber *)coverAssetID moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (void)deleteAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;
+ (void)addAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;
+ (void)removeAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;

+ (void)moveAssetWithID:(NSNumber *)assetID fromAlbumWithID:(NSNumber *)sourceAlbumID toAlbumWithID:(NSNumber *)destinationAlbumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

+ (void)copyAssetWithID:(NSNumber *)assetID fromAlbumWithID:(NSNumber *)sourceAlbumID toAlbumWithID:(NSNumber *)destinationAlbumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

+ (void)listAllAlbumsWithinForAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, NSArray *listOfAlbums))success failure:(void(^)(NSError *error))failure;


@end
