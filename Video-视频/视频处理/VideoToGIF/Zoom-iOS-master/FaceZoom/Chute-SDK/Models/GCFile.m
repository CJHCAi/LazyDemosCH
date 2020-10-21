//
//  GCFile.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCFile.h"
#include "GCMD5Hash.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCObjectMapping.h"
#import "GCFileManager.h"
#import "GCImageData.h"

@implementation GCFile

+ (instancetype)fileAtPath:(NSString *)filePath
{
    return [[GCFile alloc] initWithFileAtPath:filePath];
}

- (instancetype)initWithFileAtPath:(NSString *)filePath
{

    self = [super init];
    if (self) {
        
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
        
        self.fileName = filePath; //[fileManager displayNameAtPath:filePath];
        self.fileSize = [attributes objectForKey:NSFileSize];
        self.MD5Hash = CFBridgingRelease(GCCreateMD5HashWithPath(CFBridgingRetain(filePath))); //[@(arc4random()) stringValue];
        
    }
    return self;
}

+ (instancetype)fileWithUIImage:(UIImage *)image
{
    GCImageData *imageData = [GCImageData dataWithUIImage:image];
    NSString *filePath = [GCFileManager createTempFileWithData:imageData.data extension:imageData.extension];
    
    return [GCFile fileAtPath:filePath];
}

- (NSDictionary *)serialize
{
    DCParserConfiguration *configuration= [DCParserConfiguration configuration];
    DCObjectMapping *fileNameMapper = [DCObjectMapping mapKeyPath:@"filename" toAttribute:@"fileName" onClass:[GCFile class]];
    DCObjectMapping *fileSizeMapper = [DCObjectMapping mapKeyPath:@"size" toAttribute:@"fileSize" onClass:[GCFile class]];
    DCObjectMapping *fileMD5Mapper = [DCObjectMapping mapKeyPath:@"md5" toAttribute:@"MD5Hash" onClass:[GCFile class]];
    [configuration addObjectMapping:fileNameMapper];
    [configuration addObjectMapping:fileSizeMapper];
    [configuration addObjectMapping:fileMD5Mapper];
    
    DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCFile class] andConfiguration:configuration];
    NSDictionary *fileDictionary = [mapping serializeObject:self];
    
    return fileDictionary;
}

@end
