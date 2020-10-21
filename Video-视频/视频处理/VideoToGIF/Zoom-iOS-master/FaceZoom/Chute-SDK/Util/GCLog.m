//
//  GCLog.m
//  Logging
//
//  Created by Aleksandar Trpeski on 10/22/13.
//  Copyright (c) 2013 Aranea Apps. All rights reserved.
//

#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDASLLogger.h>

#import "GCLog.h"
#import "GCLogFormatter.h"

int gcLogLevel;

@interface GCLog () <DDRegisteredDynamicLogging>

@end

@implementation GCLog

+ (void)initialize
{
    GCLogFormatter *formatter = [GCLogFormatter new];
	
	[[DDASLLogger sharedInstance] setLogFormatter:formatter];
	[[DDTTYLogger sharedInstance] setLogFormatter:formatter];
	
	[GCLog addLogger:[DDASLLogger sharedInstance]];
	[GCLog addLogger:[DDTTYLogger sharedInstance]];
    
    gcLogLevel = LOG_LEVEL_WARN;

}

+ (int)logLevel
{
     return gcLogLevel;
}

+ (void)setLogLevel:(int)logLevel
{
     gcLogLevel = logLevel;
}

#pragma mark - DDRegisteredDynamicLogging Delegate Methods

+ (int)ddLogLevel
{
    return gcLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel
{
    gcLogLevel = logLevel;
}

@end
