//
//  CXDragTableView.h
//  drawTableViewCell
//
//  Created by caixiang on 2019/9/10.
//  Copyright © 2019 蔡翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXDragTableView;

@protocol CXDragableCellTableViewDataSource <UITableViewDataSource>

@required
/**
 更新数据源 外界自己控制 业务不一样,更新操作不一样）

 @param tableView tableView
 @param sourceIndexPath 被长按cell的位置
 @param destinationIndexPath 移动后位置
 */
- (void)tableView:(CXDragTableView *)tableView newMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@protocol CXDragableCellTableViewDelegate <UITableViewDelegate>

@optional

/**
 被长按的Cell即将移动

 @param tableView tableView
 @param indexPath 被长按cell的索引
 @param cell 被长按的cell
 */
- (void)tableView:(CXDragTableView *)tableView willMoveCellAtIndexPath:(NSIndexPath *)indexPath processCell:(UITableViewCell *)cell;

/**
 被长按的Cell结束移动

 @param tableView tableView
 @param indexPath 被长按cell的索引
 @param cell 被长按的cell
 */
- (void)tableView:(CXDragTableView *)tableView endMoveCellAtIndexPath:(NSIndexPath *)indexPath processCell:(UITableViewCell *)cell;


/**
 被长按的Cell截图动画移除后

 @param tableView tableView
 @param indexPath 被长按cell的索引
 @param cell 被长按的cell
 */
- (void)tableView:(CXDragTableView *)tableView animationendMoveCellAtIndexPath:(NSIndexPath *)indexPath processCell:(UITableViewCell *)cell;

/**
  跨界判定

 @param tableView tableView
 @param sourceIndexPath 被长按cell的位置
 @param proposedDestinationIndexPath 目标位置
 @return YES or NO
 */
- (BOOL)tableView:(CXDragTableView *)tableView newTargetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

/**
 支持拖拽的indexPath

 @param tableView tableView
 @param indexPath 被长按cell的位置
 @return YES or NO
 */
- (BOOL)tableView:(CXDragTableView *)tableView newCanMoveRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CXDragTableView : UITableView

@property (nonatomic, weak) id<CXDragableCellTableViewDataSource>  dataSource;
@property (nonatomic, weak) id<CXDragableCellTableViewDelegate>    delegate;

@end
