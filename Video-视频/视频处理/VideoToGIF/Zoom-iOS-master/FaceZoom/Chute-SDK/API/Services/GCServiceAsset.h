//
//  GCServiceAsset.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCPagination, GCAsset, GCCoordinate;

@interface GCServiceAsset : NSObject

+ (void)getAssetsForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *, GCPagination *))success failure:(void (^)(NSError *error))failure;

+ (void)importAssetsFromURLs:(NSArray *)urls forAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void (^)(NSError *error))failure;

+ (void)getAssetWithID:(NSNumber *)assetID fromAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure;

+ (void)updateAssetWithID:(NSNumber *)assetID andAlbumID:(NSNumber *)albumID caption:(NSString *)caption success:(void (^)(GCResponseStatus *, GCAsset *))success failure:(void (^)(NSError *))failure;


//                              THE FOLLOWING METHODS ARE DEPRECATED                            //

/*

+ (void)getAssetsWithSuccess:(void (^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void (^)(NSError *error))failure;

+ (void)getAssetWithID:(NSNumber *)assetID success:(void(^)(GCResponseStatus *responseStatus,GCAsset *asset))success failure:(void(^)(NSError *error))failure;

+ (void)updateAssetWithID:(NSNumber *)assetID caption:(NSString *)caption success:(void (^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void (^)(NSError *error))failure;

+ (void)deleteAssetWithID:(NSNumber *)assetID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;

+ (void)getGeoCoordinateForAssetWithID:(NSNumber *)assetID success:(void (^)(GCResponseStatus *responseStatus, GCCoordinate *coordinate))success failure:(void (^)(NSError *Error))failure;

+ (void)getAssetsForCentralCoordinate:(GCCoordinate *)coordinate andRadius:(NSNumber *)radius success:(void (^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void (^)(NSError *error))failure;
*/
 
@end
