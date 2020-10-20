//
//  ItemCell.h
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@class ItemCell;
@protocol ItemCellDelegate <NSObject>
- (void)rightUpperButtonDidTappedWithItemCell:(ItemCell *)selectedItemCell;

@end

@interface ItemCell : UICollectionViewCell
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, weak) id <ItemCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isEditing;
@end
