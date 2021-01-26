//
//  CMTableView.h
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNode.h"

@class CMTableView;
@protocol CMTableViewDelegate <NSObject>

@optional

/**
 *  即将展开/关闭子节点，此代理可以动态加载子节点
 */
- (void)treeView:(CMTableView *)treeView willexpandNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  已经展开/关闭子节点，此代理可以于此进行动画效果的设置
 */
- (void)treeView:(CMTableView *)treeView didexpandNodeAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMTableView : UITableView

@property (nonatomic, readwrite, strong) CMNode *rootNode;           //根节点

@property (nonatomic, readwrite, weak) id<CMTableViewDelegate> treeViewDelegate;

/**
 *  返回根节点的子节点数，即深度为0的节点数
 *  @return 根节点的子节点数
 */
- (NSInteger) numberOfSectionsInTreeView:(CMTableView *)treeView;

/**
 *  返回深度为0的所有子孙节点数
 *  @return 深度为0的所有子孙节点数
 */
- (NSInteger)treeView:(CMTableView *)treeView numberOfRowsInSection:(NSInteger)section;

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
- (CMNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
