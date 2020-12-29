
#import "NSArray+SafeAccess.h"

@implementation NSArray (SafeAccess)

- (id)objectAtIndexOrNil:(NSUInteger)index {
    return (index < [self count]) ? self[index] : nil;
}

@end
