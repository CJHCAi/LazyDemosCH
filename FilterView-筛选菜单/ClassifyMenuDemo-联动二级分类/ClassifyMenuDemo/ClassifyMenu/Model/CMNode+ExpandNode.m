//
//  CMNode+ExpandNode.m
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMNode+ExpandNode.h"
#import <objc/runtime.h>

@implementation CMNode (ExpandNode)

- (NSMutableArray *)expandNodes {
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        array = [NSMutableArray arrayWithCapacity:2];
        [self setExpandNodes:array];
    }
    return array;
}

- (void)setExpandNodes:(NSMutableArray *)expandNodes {
    objc_setAssociatedObject(self, @selector(expandNodes), expandNodes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getSubExpandNodes {
    [self.expandNodes removeAllObjects];
    [self __computeExpandFromNode:self];
    return self.expandNodes;
}

- (void)__computeExpandFromNode:(CMNode *) node {
    NSMutableArray *result = self.expandNodes;
    if (node.expand) {
        for (CMNode *node1 in node.subNodes) {
            [result addObject:node1];
            [self __computeExpandFromNode:node1];
        }
    }
}

@end
