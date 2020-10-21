//
//  GCFormatter.h
//  Logging
//
//  Created by Aleksandar Trpeski on 10/22/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/DDLog.h>

@interface GCLogFormatter : NSObject <DDLogFormatter> {
    NSDateFormatter *_dateFormatter;
}

@end
