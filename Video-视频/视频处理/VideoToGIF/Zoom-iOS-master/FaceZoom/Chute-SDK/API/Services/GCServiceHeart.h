//
//  GCServiceHeart.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCHeartCount, GCHeart;

@interface GCServiceHeart : NSObject

+ (void)getHeartCountForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCHeartCount *heartCount))success failure:(void (^)(NSError *))failure;
+ (void)heartAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCHeart *heart))success failure:(void (^)(NSError *))failure;
+ (void)unheartAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCHeart *heart))success failure:(void (^)(NSError *))failure;

@end
