//
//  GCConfiguration.m
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 8/10/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "GCConfigurationFile.h"
#import "GCAccount.h"
#import "DCKeyValueObjectMapping.h"
#import "GetChute.h"

static NSString * const kGCConfiguration = @"GCConfiguration";
static NSString * const kGCExtension = @"plist";

static NSSet *sGCLocalFeatures;
static NSDictionary *sGCServiceFeatures;

@implementation GCConfigurationFile

+ (NSDictionary *)dictionaryRepresentation
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kGCConfiguration, kGCExtension]];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:kGCConfiguration ofType:kGCExtension];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        if ([fileManager fileExistsAtPath:bundlePath]) {
            NSData *stockData = [[NSData alloc] initWithContentsOfFile:bundlePath];
            [stockData writeToFile:path atomically:YES];
        }
        else {
            GCLogError(@"Configuration.plist missing!");
        }
    }
    GCLogVerbose(@"Read configuration Path: %@", path);
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}

+ (void)write:(id<GCConfigurationProtocol>)configuration
{
    if (![configuration section]) return;
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kGCConfiguration, kGCExtension]];
    
    NSMutableDictionary *stockToSave = [NSMutableDictionary new];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [[NSBundle mainBundle] pathForResource:kGCConfiguration ofType:kGCExtension];
        stockToSave = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else {
        stockToSave = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    
        [stockToSave setObject:[configuration serialized] forKey:[configuration section]];
        
        [stockToSave writeToFile:path atomically:YES];
        GCLogVerbose(@"Write Configuration at path: %@", path);
}

@end
