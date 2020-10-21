//
//  GCServiceFlag.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCVoteCount, GCFlagCount, GCFlag;

@interface GCServiceFlag : NSObject

+ (void)getFlagCountForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCFlagCount *flagCount))success failure:(void (^)(NSError *error))failure;
+ (void)flagAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCFlag *flag))success failure:(void (^)(NSError *error))failure;
+ (void)removeFlagForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCFlag *flag))success failure:(void (^)(NSError *error))failure;

@end
