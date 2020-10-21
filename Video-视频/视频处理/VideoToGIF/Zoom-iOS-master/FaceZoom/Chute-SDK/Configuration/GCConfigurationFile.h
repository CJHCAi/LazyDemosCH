//
//  GCConfiguration.h
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 8/10/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCOAuth2Client.h"

@protocol GCConfigurationProtocol <NSObject>

@required

@property (strong, nonatomic) NSString *section;

/**
 Creates a singleton object for the configuration.
 */
+ (instancetype) configuration;

- (void)populate:(NSDictionary *)configuration;
- (id)serialized;

@end

@class GCAccount;

@interface GCConfigurationFile : NSObject

/**
 Abstract variable, name of the section in the main GCConfiguration.plist
 */
//@property (strong, nonatomic) NSString *section;


///--------------------------------
/// @name Creating Singleton object
///--------------------------------

+ (NSDictionary *)dictionaryRepresentation;
+ (void)write:(id<GCConfigurationProtocol>)configuration;

@end
