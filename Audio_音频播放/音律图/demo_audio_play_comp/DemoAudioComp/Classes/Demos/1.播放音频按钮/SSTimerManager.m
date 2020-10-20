//
//  SSTimerManager.m
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/5.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSTimerManager.h"

@interface SSTimerManager()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation SSTimerManager

+ (instancetype)instance {
    static SSTimerManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[SSTimerManager alloc] init];
    });
    return obj;
}

- (void)start {
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(couting:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)couting:(NSTimer *)timer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerCounting" object:@(timer.timeInterval)];
}

@end
