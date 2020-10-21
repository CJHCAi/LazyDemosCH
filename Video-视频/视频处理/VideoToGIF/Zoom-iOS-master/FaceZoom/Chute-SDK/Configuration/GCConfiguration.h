//
//  GCConfiguration.h
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 10/30/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "GCConfigurationFile.h"

@interface GCConfiguration : NSObject<GCConfigurationProtocol>

/**
 Application ID from Chute.
 */
@property (strong, nonatomic) NSString *appId;

/** 
 Application Secret from Chute.
 */
@property (strong, nonatomic) NSString *appSecret;

@end
