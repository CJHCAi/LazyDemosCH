//
//  GCLog.h
//  Logging
//
//  Created by Aleksandar Trpeski on 10/22/13.
//  Copyright (c) 2013 Aranea Apps. All rights reserved.
//

#import "DDLog.h"

extern int gcLogLevel;

#define GC_LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
    [GCLog log:isAsynchronous                                             \
         level:lvl                                                        \
          flag:flg                                                        \
       context:ctx                                                        \
          file:__FILE__                                                   \
      function:fnct                                                       \
          line:__LINE__                                                   \
           tag:atag                                                       \
        format:(frmt), ##__VA_ARGS__]

#define GC_LOG_OBJC_MAYBE(async, lvl, flg, ctx, frmt, ...) \
    GC_LOG_MAYBE(async, lvl, flg, ctx, sel_getName(_cmd), frmt, ##__VA_ARGS__)

#define GC_LOG_MAYBE(async, lvl, flg, ctx, fnct, frmt, ...) \
    do { if(lvl & flg) GC_LOG_MACRO(async, lvl, flg, ctx, nil, fnct, frmt, ##__VA_ARGS__); } while(0)

#define GC_ASYNC_LOG_OBJC_MAYBE(lvl, flg, ctx, frmt, ...) \
    GC_LOG_OBJC_MAYBE(YES, lvl, flg, ctx, frmt, ##__VA_ARGS__)

#define GCLogError(frmt, ...)   GC_ASYNC_LOG_OBJC_MAYBE(gcLogLevel, LOG_FLAG_ERROR, 0, frmt, ##__VA_ARGS__)
#define GCLogWarning(frmt, ...)   GC_ASYNC_LOG_OBJC_MAYBE(gcLogLevel, LOG_FLAG_WARN, 0, frmt, ##__VA_ARGS__)
#define GCLogInfo(frmt, ...)   GC_ASYNC_LOG_OBJC_MAYBE(gcLogLevel, LOG_FLAG_INFO, 0, frmt, ##__VA_ARGS__)
#define GCLogVerbose(frmt, ...)   GC_ASYNC_LOG_OBJC_MAYBE(gcLogLevel, LOG_FLAG_VERBOSE, 0, frmt, ##__VA_ARGS__)

@interface GCLog : DDLog

+ (int)logLevel;
+ (void)setLogLevel:(int)logLevel;

@end