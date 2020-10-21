//
//  GCServiceComment.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/22/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCComment, GCPagination;

@interface GCServiceComment : NSObject

+ (void)getCommentsForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination))success failure:(void (^)(NSError *error))failure;
+ (void)createComment:(NSString *)comment forUserWithName:(NSString *)name andEmail:(NSString *)email forAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, GCComment *comment))success failure:(void (^)(NSError *error))failure;
+ (void)deleteCommentWithID:(NSNumber *)commentID success:(void (^)(GCResponseStatus *responseStatus, GCComment *comment))success failure:(void (^)(NSError *error))failure;

@end
