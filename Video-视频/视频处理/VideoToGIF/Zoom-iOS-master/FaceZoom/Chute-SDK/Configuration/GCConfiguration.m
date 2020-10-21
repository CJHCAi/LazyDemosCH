//
//  GCConfiguration.m
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 10/30/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "GCConfiguration.h"

static GCConfiguration *sharedData = nil;
static dispatch_queue_t serialQueue;

static NSString * const kGCSection = @"chute-sdk";
static NSString * const kGCAppId = @"app_id";
static NSString * const kGCAppSecret = @"app_secret";

@implementation GCConfiguration

@synthesize section, appId, appSecret;

#pragma mark - Singleton Design

+(id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.getchute.GCConfiguration", NULL);
        if (sharedData == nil) {
            sharedData = [super allocWithZone:zone];
        }
    });
    
    return sharedData;
}

- (id)init
{
    id __block obj;
    
    dispatch_sync(serialQueue, ^{
        
        obj = [super init];
        
        [self setSection:kGCSection];
        
        if (obj) {
            
            if ([(GCConfiguration *)obj section]) {
                
                [obj populate:[[GCConfigurationFile dictionaryRepresentation] objectForKey:kGCSection]];
            }
            
        }
    });
    
    self = obj;
    return self;
}

+ (instancetype)configuration {
    static dispatch_once_t onceToken;
    static GCConfiguration *sharedData = nil;
    
    dispatch_once(&onceToken, ^{
        sharedData = [[GCConfiguration alloc] init];
    });
    return sharedData;
}

#pragma mark - GCBaseConfigurationProtocol Methods

- (id)serialized
{
    NSMutableDictionary *stockToSave = [[NSMutableDictionary alloc] init];
    
    if ([self appId]) {
        [stockToSave setObject:self.appId forKey:kGCAppId];
    }
    if ([self appSecret])
    {
        [stockToSave setObject:self.appSecret forKey:kGCAppSecret];
    }
    
    return stockToSave;
}

- (void)populate:(NSDictionary *)configuration
{
    if ([configuration objectForKey:kGCAppId]) {
        self.appId = [configuration objectForKey:kGCAppId];
    }
    else {
        self.appId = nil;
    }
    
    if ([configuration objectForKey:kGCAppSecret]) {
        self.appSecret = [configuration objectForKey:kGCAppSecret];
    }
    else {
        self.appSecret = nil;
    }
    
    [GCConfigurationFile write:self];
}


@end
