//
//  GCFormatter.m
//  Logging
//
//  Created by Aleksandar Trpeski on 10/22/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "GCLogFormatter.h"
#import "ColorLog.h"

@implementation GCLogFormatter

- (id)init
{
	if((self = [super init])) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		
		[_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
	}
	
	return self;
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel;
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR : logLevel = [NSString stringWithFormat:@"%@ERROR", (IsXcodeColorsEnabled() ? LCL_RED : @"")]; break;
        case LOG_FLAG_WARN  : logLevel = [NSString stringWithFormat:@"%@WARNING", (IsXcodeColorsEnabled() ? LCL_MAGENTA : @"")]; break;
        case LOG_FLAG_INFO  : logLevel = [NSString stringWithFormat:@"%@INFO", (IsXcodeColorsEnabled() ? LCL_BLUE : @"")]; break;
        default             : logLevel = @"VERBOSE"; break;
    }
    
    NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage->timestamp)];
    
    return  [NSString stringWithFormat:@"<Chute %@>(%@)[%@ %@/%d] >>\n\t%@%@", logLevel, dateAndTime,
			 [logMessage fileName], [logMessage methodName], logMessage->lineNumber, logMessage->logMsg, IsXcodeColorsEnabled() ? LCL_RESET : @""];
}

@end
