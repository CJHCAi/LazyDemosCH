//
//  GCAssetSource.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAssetSource : NSObject

@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSNumber *sourceId;
@property (strong, nonatomic) NSString *sourceUrl;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) NSNumber *importId;
@property (strong, nonatomic) NSString *importUrl;
@property (strong, nonatomic) NSString *originalUrl;


@end
