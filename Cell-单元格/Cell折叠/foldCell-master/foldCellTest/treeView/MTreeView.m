//
//  MTreeView.m
//  MTreeViewFramework
//
//  Created by Micker on 16/3/30.
//  Copyright © 2016年 micker. All rights reserved.
//

#import "MTreeView.h"
#import "MTreeNode+ExpandNode.h"
#import "wjFirstFoldView.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height


@implementation MTreeView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:248/255.0 alpha:1.0];
        self.frame = CGRectMake(0, 0, screenW, screenH);
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
    
}
- (void)reloadData {
    [super reloadData];

    [self.rootNode.subNodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(MTreeNode *)obj getSubExpandNodes];
    }];
    [super reloadData];
}

- (NSInteger)numberOfSectionsInTreeView:(MTreeView *)treeView {
    return [[self.rootNode subNodes] count];
}

- (NSInteger)treeView:(MTreeView *)treeView numberOfRowsInSection:(NSInteger)section {
    MTreeNode *subNode = [[self.rootNode subNodes] objectAtIndex:section];
    return [subNode.expandNodes count];
}

- (MTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath {
    MTreeNode *subNode = [[self.rootNode subNodes] objectAtIndex:indexPath.section];
    return (indexPath.row < 0) ? subNode : [[subNode expandNodes] objectAtIndex:indexPath.row];
}

- (void) expandNodeAtIndexPath:(NSIndexPath *)indexPath {
    
    MTreeNode *subNode = [[self.rootNode subNodes] objectAtIndex:indexPath.section];
    MTreeNode *subRowNode = [self nodeAtIndexPath:indexPath];
    NSArray *expandNodes = [[subRowNode getSubExpandNodes] copy];
    
    if (self.treeViewDelegate && [self.treeViewDelegate respondsToSelector:@selector(treeView:willexpandNodeAtIndexPath:)]) {
        [self.treeViewDelegate treeView:self willexpandNodeAtIndexPath:indexPath];
    }
    
    // 是否展开
    [subRowNode toggle];
    [subNode getSubExpandNodes];
    if (subRowNode.expand) {
        [self insertRowsAtIndexPaths:[self getIndexPathsFromIndex:indexPath length:[[subRowNode getSubExpandNodes] count]]
                    withRowAnimation:UITableViewRowAnimationNone];
        
    } else {
        [self deleteRowsAtIndexPaths:[self getIndexPathsFromIndex:indexPath length:[expandNodes count]]
                    withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (self.treeViewDelegate && [self.treeViewDelegate respondsToSelector:@selector(treeView:didexpandNodeAtIndexPath:)]) {
        [self.treeViewDelegate treeView:self didexpandNodeAtIndexPath:indexPath];
    }
}


- (NSArray *)getIndexPathsFromIndex:(NSIndexPath *) indexPath length:(NSUInteger) length {
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i = 0, total = length; i < total; i++) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:(indexPath.row + i + 1)
                                                     inSection:indexPath.section]];
    }
    return indexPathArray;
}

@end
