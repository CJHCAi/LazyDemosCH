//
//  GCServiceVote.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCVoteCount, GCVoteCount, GCVote;

@interface GCServiceVote : NSObject

+ (void)getVoteCountForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCVoteCount *voteCount))success failure:(void (^)(NSError *error))failure;
+ (void)voteAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCVote *vote))success failure:(void (^)(NSError *error))failure;
+ (void)removeVoteForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCVote *vote))success failure:(void (^)(NSError *error))failure;

@end
