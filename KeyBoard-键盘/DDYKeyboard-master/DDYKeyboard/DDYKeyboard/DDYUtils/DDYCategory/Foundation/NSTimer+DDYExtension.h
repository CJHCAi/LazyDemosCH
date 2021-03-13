#import <Foundation/Foundation.h>

@interface NSTimer (DDYExtension)
/** 让iOS 10 以下版本也能用block */
+ (NSTimer *)ddy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
