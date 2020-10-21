//
//  GCUploadInfo.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCUploads : NSObject

@property (strong, nonatomic) NSString  *id;
@property (strong, nonatomic) NSArray   *existingAssets;
@property (strong, nonatomic) NSArray   *assets;

+ (instancetype)uploadsFromDictionary:(NSDictionary *)dictionary;

@end
