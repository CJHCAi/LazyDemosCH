//
//  MPGestureLayout.h
//  collectionPanViewTest
//
//  Created by ytz on 2018/1/24.
//  Copyright © 2018年 ytz. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YScreenWidth    [UIScreen mainScreen].bounds.size.width
#define YScreenHeight   [UIScreen mainScreen].bounds.size.height
@protocol MPGestureLayout <NSObject>

//移动数据源
- (void)mp_moveDataItem:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath;
//删除数据源  
- (void)mp_removeDataObjectAtIndex:(NSIndexPath *)index;
//删除区域
- (CGRect)mp_RectForDelete;
@optional
//进出删除区域的操作
- (void)mp_didMoveToDeleteArea;
- (void)mp_didLeaveToDeleteArea;
//手势状态
- (void)mp_willBeginGesture;
- (void)mp_didEndGesture;
//不可移动的item集合
- (NSArray<NSIndexPath *> *)mp_disableMoveItemArray;
//拖动区域的View，不实现则默认为window
- (UIView *)mp_moveMainView;
@end

@interface MPGestureLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<MPGestureLayout> delegate;

@end


