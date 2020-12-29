//
//  HKCellImagePickView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteNetImageBlock)(HKEditResumeDataImgs *imageData);

@interface HKCellImagePickView : UIView

@property (nonatomic, assign) CGFloat leftMargin;   //collectionView 距离左边距离
@property (nonatomic, strong) NSMutableArray *images; //所有的图片

@property (nonatomic, weak) UIViewController *delegate;

- (instancetype)initWithImages:(NSMutableArray *)images  leftMargin:(CGFloat)leftMargin delegate:(UIViewController *)delegate;

+ (instancetype)cellImagePickViewWithImages:(NSMutableArray *)images leftMargin:(CGFloat)leftMargin delegate:(UIViewController *)delegate;

//获得选择的图片
//- (NSMutableArray<UIImage *> *)pickImages;

@property (nonatomic,copy) void (^CellPickImageBlock)(NSMutableArray<UIImage *> *pickImages);

@property (nonatomic, copy) DeleteNetImageBlock deleteNetImageBlock;

@end


//collection view cell
@interface HKCellImagePickCell : UICollectionViewCell
@property (nonatomic,copy) void (^deleteButtonClicked)(UIImage *image, HKEditResumeDataImgs *imageData);

@property (nonatomic,strong) UIImageView *imgView; // 显示图片

@property (nonatomic, strong) HKEditResumeDataImgs *imageData; //网络图片

@property (nonatomic,strong) UIButton *btnClose; // 删除

@property (nonatomic,assign) BOOL canEdit; // 是否可以删除

+ (CGSize)itemSize;
@end
