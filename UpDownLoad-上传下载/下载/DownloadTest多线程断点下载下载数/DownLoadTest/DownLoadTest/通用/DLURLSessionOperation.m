//
//  DLURLSessionOperation.m
//  DownloadManager
//
//  Created by 李五民 on 15/10/27.
//  Copyright © 2015年 Ideamakerz. All rights reserved.
//

#import "DLURLSessionOperation.h"
#import "NSString+hash.h"
#import "DLDownloadMagager.h"
#include <objc/objc.h>
#include <objc/runtime.h>
@interface DLURLSessionOperation ()
{
    BOOL _finished;
    BOOL _executing;
    BOOL _canceled;
}

@end

@implementation DLURLSessionOperation

- (instancetype)initWithSession:(NSURLSession *)session URLString:(NSString *)urlString {
    
    if (self = [super init]) {
        _canceled = NO;
        _executing = NO;
        _finished = NO;
        self.urlString = urlString;
        self.session = session;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        self.task = [self.session downloadTaskWithRequest:request];
        self.task.taskDescription = self.urlString;
    }
    return self;
}

- (instancetype)initWithSession:(NSURLSession *)session URLString:(NSString *)urlString ResumeData:(NSData *)resumeData{
    
    if (self = [super init]) {
        _canceled = NO;
        _executing = NO;
        _finished = NO;
        self.urlString = urlString;
        self.session = session;
        self.task = [self.session downloadTaskWithResumeData:resumeData];
        self.task.taskDescription = self.urlString;
    }
    return self;
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    if ([self isCancelled]) {
        _finished = YES;
        return;
    }
    [self setOperationStarted:YES];
    if (self.isSuspend) {
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            if(resumeData != nil) {
                self.resumeData = resumeData;
            }
        }];
        [self cancel];
        [self completeOperation];
        _alReadyStart = YES;
        self.isSuspend = NO;
        return;
    }
    self.startOperationDate = [NSDate date];
    [self.task resume];
}

- (void)suspend{
    [self.task suspend];
}

- (void)cancel {
    [super cancel];
    [self.task cancel];
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isCancelled {
    return _canceled;
}

- (void)completeOperation {
    if (![self isOperationStarted]) return;
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
