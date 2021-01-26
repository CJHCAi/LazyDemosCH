//
//  CMNode+ExpandNode.h
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNode (ExpandNode)

@property (nonatomic, strong) NSMutableArray *expandNodes;      //存储当前节点之下展开的节点

- (NSArray *)getSubExpandNodes;

@end

NS_ASSUME_NONNULL_END
