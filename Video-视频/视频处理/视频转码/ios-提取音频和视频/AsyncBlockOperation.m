

#import "AsyncBlockOperation.h"

@interface AsyncBlockOperation () {
    BOOL _finished;
    BOOL _executing;
}

@property (nonatomic, copy) AsyncBlock block;

@end


@implementation AsyncBlockOperation

+ (instancetype)asyncBlockOperationWithBlock:(AsyncBlock)block {
    return [[AsyncBlockOperation alloc] initWithAsyncBlock:block];
}

- (instancetype)initWithAsyncBlock:(AsyncBlock)block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)start {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];

    self.block(^{
        [self willChangeValueForKey:@"isExecuting"];
        _executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    });
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isAsynchronous {
    return YES;
}

@end

@implementation NSOperationQueue (AsyncBlockOperation)

- (void)addAsyncOperationWithBlock:(AsyncBlock)block {
    [self addOperation:[AsyncBlockOperation asyncBlockOperationWithBlock:block]];
}

@end
