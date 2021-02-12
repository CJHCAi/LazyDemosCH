//
//  CMTableView.m
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMTableView.h"
#import "CMNode+ExpandNode.h"
#import "CMenuConfig.h"

@implementation CMTableView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
    
}
- (void)reloadData {
    [super reloadData];
    
    [self.rootNode.subNodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(CMNode *)obj getSubExpandNodes];
    }];
    [super reloadData];
}

- (NSInteger)numberOfSectionsInTreeView:(CMTableView *)treeView {
    return [[self.rootNode subNodes] count];
}

- (NSInteger)treeView:(CMTableView *)treeView numberOfRowsInSection:(NSInteger)section {
    CMNode *subNode = [[self.rootNode subNodes] objectAtIndex:section];
    return [subNode.expandNodes count];
}

- (CMNode *)nodeAtIndexPath:(NSIndexPath *)indexPath {
    CMNode *subNode = [[self.rootNode subNodes] objectAtIndex:indexPath.section];// 1级
    if (indexPath.row < 0) {
        return subNode;
    }else{
        if ([subNode expandNodes].count >indexPath.row) {
            return [[subNode expandNodes] objectAtIndex:indexPath.row];
        }else{
            return subNode;
        }
    }
}

- (void)expandNodeAtIndexPath:(NSIndexPath *)indexPath {
    
    CMNode *subNode = [[self.rootNode subNodes] objectAtIndex:indexPath.section];
    CMNode *subRowNode = [self nodeAtIndexPath:indexPath];
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

- (NSArray *)getIndexPathsFromIndex:(NSIndexPath *)indexPath length:(NSUInteger)length {
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i = 0, total = length; i < total; i++) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:(indexPath.row + i + 1)
                                                     inSection:indexPath.section]];
    }
    return indexPathArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
