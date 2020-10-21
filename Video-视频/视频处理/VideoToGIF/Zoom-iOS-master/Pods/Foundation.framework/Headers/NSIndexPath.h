/*  NSIndexPath.h
    Copyright (c) 2003-2014, Apple Inc. All rights reserved.
*/

#import <Foundation/NSObject.h>

@interface NSIndexPath : NSObject <NSCopying, NSSecureCoding> {
	@private
	__strong NSUInteger *_indexes;
#if !__OBJC2__
	NSUInteger _hash;
#endif
	NSUInteger _length;
        void *_reserved;
}

+ (instancetype)indexPathWithIndex:(NSUInteger)index;
+ (instancetype)indexPathWithIndexes:(const NSUInteger [])indexes length:(NSUInteger)length;

- (instancetype)initWithIndexes:(const NSUInteger [])indexes length:(NSUInteger)length NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithIndex:(NSUInteger)index;


- (NSIndexPath *)indexPathByAddingIndex:(NSUInteger)index;
- (NSIndexPath *)indexPathByRemovingLastIndex;

- (NSUInteger)indexAtPosition:(NSUInteger)position;
@property (readonly) NSUInteger length;

- (void)getIndexes:(NSUInteger *)indexes;

	// comparison support
- (NSComparisonResult)compare:(NSIndexPath *)otherObject; // sorting an array of indexPaths using this comparison results in an array representing nodes in depth-first traversal order

@end

