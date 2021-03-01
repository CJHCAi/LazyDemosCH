//
//  BUTimer.h
//  BUAdSDK
//
//  Created by 李盛 on 2018/6/20.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUTimer : NSObject

@property (nonatomic, copy) NSString *runLoopMode;

+ (BUTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                            target:(id)target
                          selector:(SEL)aSelector
                           repeats:(BOOL)repeats;

- (BOOL)isValid;
- (void)invalidate;
- (BOOL)isScheduled;
- (BOOL)scheduleNow;
- (BOOL)pause;
- (BOOL)resume;
- (NSTimeInterval)initialTimeInterval;

@end
