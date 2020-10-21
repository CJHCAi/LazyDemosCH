

#import <Foundation/Foundation.h>

typedef void(^AsyncBlock)(dispatch_block_t completionHandler);

@interface AsyncBlockOperation : NSOperation

@property (nonatomic, readonly, copy) AsyncBlock block;

+ (instancetype)asyncBlockOperationWithBlock:(AsyncBlock)block;

- (instancetype)initWithAsyncBlock:(AsyncBlock)block;

@end


@interface NSOperationQueue (AsyncBlockOperation)

- (void)addAsyncOperationWithBlock:(AsyncBlock)block;

@end
