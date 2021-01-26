//
//  CMNode.m
//  明医智
//
//  Created by LiuLi on 2019/1/15.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMNode.h"

@implementation CMNode

- (instancetype)init {
    [NSException raise:@"init error" format:@"use - (instancetype)initWithDepth:(NSUInteger)depth parent:(CMNode *) parent method to init"];
    return nil;
}

- (instancetype)initWithParent:(CMNode *) parent expand:(BOOL) expand {
    self = [super init];
    if (self) {
        self.subNodes = [NSMutableArray arrayWithCapacity:2];
        self.threeNodes = [NSMutableArray arrayWithCapacity:2];
        self.expand = expand;
        self.parentNode = parent;
    }
    return self;
}

+ (instancetype)initWithParent:(CMNode *)parent expand:(BOOL) expand {
    return [[CMNode alloc] initWithParent:parent expand:expand] ;
}

- (void)setParentNode:(CMNode *)parentNode {
    if (_parentNode != parentNode) {
        _parentNode = parentNode;
        [self __computeDepth];
    }
}

- (void)toggle {
    _expand = !_expand;
}

#pragma mark --
#pragma mark interneal

- (void) __computeDepth {
    NSInteger length = -1;
    CMNode *parent = _parentNode;
    while (parent) {
        parent = parent.parentNode;
        length++;
    }
    _depth = length;
}


@end
