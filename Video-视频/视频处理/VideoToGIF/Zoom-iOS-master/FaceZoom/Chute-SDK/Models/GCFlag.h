//
//  GCFlag.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//
/*
 "data": {
     "id": 1,
     "links": {
         "self": {
             "href": "http://api.getchute.com/v2/flags/1",
             "title": "Flag Details"
         }
     },
     "created_at": "2012-12-05T15:07:39Z",
     "updated_at": "2012-12-05T15:07:39Z",
     "identifier": "zrysgfiurqmqwygnezqo1354720059",
     "album_id": 2331370,
     "asset_id": 79517672
 }
 */

#import <Foundation/Foundation.h>

@class GCLinks;

@interface GCFlag : NSObject

@property (strong, nonatomic) NSString  *id;
@property (strong, nonatomic) GCLinks   *links;
@property (strong, nonatomic) NSDate    *createdAt;
@property (strong, nonatomic) NSDate    *updatedAt;
@property (strong, nonatomic) NSString  *identifier;
@property (strong, nonatomic) NSNumber  *albumId;
@property (strong, nonatomic) NSNumber  *assetId;

@end
