//
//  MTreeView.h
//  MTreeViewFramework
//
//  Created by Micker on 16/3/30.
//  Copyright © 2016年 micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTreeNode.h"

@protocol MTreeViewDelegate;
@class MTreeView;

@protocol MTreeViewDelegate <NSObject>

@optional

/**
 *  即将展开/关闭子节点，此代理可以动态加载子节点
 */
- (void) treeView:(MTreeView *)treeView willexpandNodeAtIndexPath:(NSIndexPath *)indexPath;


/**
 *  已经展开/关闭子节点，此代理可以于此进行动画效果的设置
 */
- (void) treeView:(MTreeView *)treeView didexpandNodeAtIndexPath:(NSIndexPath *)indexPath;

@end




@interface MTreeView : UITableView

@property (nonatomic, readwrite, strong) MTreeNode *rootNode;           //根节点

@property (nonatomic, readwrite, weak) id<MTreeViewDelegate> treeViewDelegate;


/**
 *  返回根节点的子节点数，即深度为0的节点数
 *  @return 根节点的子节点数
 */
- (NSInteger) numberOfSectionsInTreeView:(MTreeView *)treeView;

/**
 *  返回深度为0的所有子孙节点数
 *  @return 深度为0的所有子孙节点数
 */
- (NSInteger)treeView:(MTreeView *)treeView numberOfRowsInSection:(NSInteger)section;

/**
 *  展开或者折叠当前节点
 *  @param  indexPath   当row为负数时，则表示展开一级节点，即对应的Section点击事件处理
 */
- (void)expandNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取指定path对应的节点
 *  @param  indexPath   当row为负数时，则表示获取一级节点
 *  @return 对应的节点
 * */
- (MTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;

@end


