//
//  GCServiceTag.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/24/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCPagination;

@interface GCServiceTag : NSObject

+ (void)getTagsForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure;
+ (void)addTags:(NSArray *)tags forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure;
+ (void)replaceTags:(NSArray *)tags forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure;
+ (void)deleteTags:(NSArray *)tags forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *tags))success failure:(void (^)(NSError *error))failure;


@end
