//
//  GCHeart.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//
/*
 
 "data": {
 "id": 341,
 "links": {
 "self": {
 "href": "http://api.getchute.com/v2/hearts/341",
 "title": "Heart Details"
 }
 },
 "created_at": "2012-12-05T14:19:21Z",
 "updated_at": "2012-12-05T14:19:21Z",
 "identifier": "riqonhnaomxnjiyorani1354717161",
 "album_id": "2331343",
 "asset_id": 79517672
 }
 
 */

#import <Foundation/Foundation.h>

@class GCLinks;

@interface GCHeart : NSObject

@property (strong, nonatomic) NSString  *id;
@property (strong, nonatomic) GCLinks   *links;
@property (strong, nonatomic) NSDate    *createdAt;
@property (strong, nonatomic) NSDate    *updatedAt;
@property (strong, nonatomic) NSString  *identifier;
@property (strong, nonatomic) NSNumber  *albumId;
@property (strong, nonatomic) NSNumber  *assetId;

@end
