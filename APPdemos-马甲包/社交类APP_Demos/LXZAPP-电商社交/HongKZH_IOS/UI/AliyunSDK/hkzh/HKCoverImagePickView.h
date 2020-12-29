//
//  HKCoverImagePickView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HKCoverImagePickConfirmBlock)(UIImage *image);    //确定
typedef void(^HKCoverImagePickCancelBlock)(void);       //取消
typedef void(^HKCoverImagePickSnapshotBlock)(void);     //截屏
typedef void(^HKCoverImagePickCellClickBlock)(void);

@interface HKCoverImagePickView : UIView

@property (nonatomic, strong) NSMutableArray<UIImage *> *images; //所有的图片

@property (nonatomic, copy) HKCoverImagePickConfirmBlock confirmblock;
@property (nonatomic, copy) HKCoverImagePickCancelBlock cancelBlock;
@property (nonatomic, copy) HKCoverImagePickSnapshotBlock snapshotBlock;

@property (nonatomic, copy) HKCoverImagePickCellClickBlock cellClickBlock;

- (void)reSetView;

@end


@class HKCellCoverImagePickCell;

@protocol HKCellCoverImagePickCellDelegate <NSObject>

@optional
-(void)cellImagePickBlock:(HKCellCoverImagePickCell*)cell;
@end
@interface HKCellCoverImagePickCell : UICollectionViewCell

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,weak) id<HKCellCoverImagePickCellDelegate> delegate;
/**
 设置button选中状态

 @param selected 是否选中
 */
- (void)setSelectItem:(BOOL)selected;

+ (CGSize)itemSize;
@end
