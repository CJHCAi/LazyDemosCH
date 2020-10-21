//
//  GCResponse.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/3/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCPagination;

@interface GCResponse : NSObject

@property (strong, nonatomic) GCResponseStatus  *response;
@property (strong, nonatomic) id                data;
@property (strong, nonatomic) GCPagination      *pagination;

@end
