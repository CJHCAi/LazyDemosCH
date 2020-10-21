//
//  GCResponseStatus.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/27/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCApiLimits;

@interface GCResponseStatus : NSObject

@property (strong, nonatomic) NSString      *title;
@property (assign, nonatomic) NSNumber      *version;
@property (assign, nonatomic) NSNumber      *code;
@property (strong, nonatomic) NSString      *href;
@property (strong, nonatomic) GCApiLimits   *apiLimits;

@property (strong, nonatomic) NSString      *error;

@end
