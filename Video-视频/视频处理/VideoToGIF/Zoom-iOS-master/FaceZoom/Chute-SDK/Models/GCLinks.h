//
//  GCLinks.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCURL;

@interface GCLinks : NSObject

@property (strong, nonatomic) GCURL *self;
@property (strong, nonatomic) GCURL *assets;
@property (strong, nonatomic) GCURL *exif;

@end
