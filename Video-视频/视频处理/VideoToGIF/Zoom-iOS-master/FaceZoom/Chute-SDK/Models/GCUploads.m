//
//  GCUploadInfo.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCUploads.h"
#import "DCObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCArrayMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "GCUploadingAsset.h"
#import "DCParserConfiguration.h"

@implementation GCUploads

@synthesize id, existingAssets, assets;

+ (instancetype)uploadsFromDictionary:(NSDictionary *)dictionary
{
    
    DCObjectMapping *newAssetsToAssets = [DCObjectMapping mapKeyPath:@"new_assets" toAttribute:@"assets" onClass:[GCUploads class]];
    DCObjectMapping *existingAssetsToAssets = [DCObjectMapping mapKeyPath:@"existing_assets" toAttribute:@"existingAssets" onClass:[GCUploads class]];

    DCArrayMapping *newAssetsMapper = [DCArrayMapping mapperForClass:[GCUploadingAsset class] onMapping:newAssetsToAssets];
    DCArrayMapping *existingAssetsMapper = [DCArrayMapping mapperForClass:[GCUploadingAsset class] onMapping:existingAssetsToAssets];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addArrayMapper:newAssetsMapper];
    [configuration addArrayMapper:existingAssetsMapper];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[GCUploads class]  andConfiguration:configuration];
    GCUploads *uploads = [parser parseDictionary:dictionary];
    
    return uploads;
}

@end
