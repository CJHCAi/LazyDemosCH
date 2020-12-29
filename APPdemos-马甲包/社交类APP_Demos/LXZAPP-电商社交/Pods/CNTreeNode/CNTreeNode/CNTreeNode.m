//
//  CNF4TreeNode.m
//
//  Created by Frank Gregor on 13.01.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2014 Frank Gregor, <phranck@cocoanaut.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


#import "CNTreeNode.h"


@interface CNTreeNode() {
    NSMutableOrderedSet *_childNodes;
}
@end

@implementation CNTreeNode

#pragma mark - Initialization

- (id)init {
	self = [super init];
	if (self) {
		_parentNode = nil;
		_expanded = YES;
		_childNodes = [[NSMutableOrderedSet alloc] init];
		_objectValue = nil;
	}
	return self;
}

#pragma mark - Child Node Collections

- (BOOL)hasChildNodes {
	return (_childNodes != nil && [_childNodes count] > 0);
}

- (NSArray *)childNodes {
    return [_childNodes array];
}

- (NSArray *)childNodesFlattened {
	__block NSMutableArray *flattenedChildren = [[NSMutableArray alloc] init];
	[flattenedChildren addObject:self];
	for (CNTreeNode *aChild in _childNodes) {
		if (aChild.isExpanded) {
			[flattenedChildren addObjectsFromArray:aChild.childNodesFlattened];
		}
	}
	return flattenedChildren;
}

- (NSUInteger)deepNumberOfChildNodes {
	NSUInteger numberOfChildren = 0;
	for (CNTreeNode *aChild in _childNodes) {
		numberOfChildren++;
		if (aChild.isExpanded) {
			numberOfChildren += aChild.deepNumberOfChildNodes;
		}
	}
	return numberOfChildren;
}

#pragma mark - Manipulating Child Node Collections

- (void)addChild:(CNTreeNode *)theChild {
	theChild.parentNode = self;
	[_childNodes addObject:theChild];
}

- (void)addChildNodes:(NSArray *)theChildNodes {
	for (CNTreeNode *aChild in theChildNodes) {
		[self addChild:aChild];
	}
}

- (void)insertChild:(CNTreeNode *)theChild atIndex:(NSUInteger)index {
	[_childNodes insertObject:theChild atIndex:index];
}

- (void)removeChild:(CNTreeNode *)theChild {
    // the node that has to be deleted is a direct child of the receiver
	if ([_childNodes containsObject:theChild]) {
		[_childNodes removeObject:theChild];
	}
    // otherwise we are looking a step deeper...
    else {
        [_childNodes enumerateObjectsUsingBlock:^(CNTreeNode *childNode, NSUInteger idx, BOOL *stop) {
            [childNode removeChild:theChild];
        }];
    }
}

- (void)removeChildAtIndex:(NSUInteger)index {
	if ([_childNodes objectAtIndex:index]) {
		[_childNodes removeObjectAtIndex:index];
	}
}

#pragma mark - Handling Child Nodes

- (CNTreeNode *)childAtIndex:(NSUInteger)index {
	__block CNTreeNode *childAtIndex = nil;
	[_childNodes enumerateObjectsUsingBlock: ^(CNTreeNode *aChild, NSUInteger idx, BOOL *stop) {
	    if (idx == index) {
	        childAtIndex = aChild;
	        *stop = YES;
		}
	}];
	return childAtIndex;
}

#pragma mark - Child Node States

- (NSUInteger)nodeLevel {
	NSUInteger level = 1;
	if (self.parentNode != nil) {
		level += self.parentNode.nodeLevel;
	}
	return level;
}

@end
