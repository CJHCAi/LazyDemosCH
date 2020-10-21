//
//  HXPhotoView.h
//  照片选择器
//
//  Created by 洪欣 on 17/2/17.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"
#import "HXCollectionView.h"

typedef NS_ENUM(NSUInteger, HXPhotoViewPreViewShowStyle) {
    HXPhotoViewPreViewShowStyleDefault, //!< 默认
    HXPhotoViewPreViewShowStyleDark     //!< 暗黑
};

/*
 *  使用选择照片之后自动布局的功能时就创建此块View. 初始化方法传入照片管理类
 */
@class HXPhotoView, HXPhotoSubViewCell;

/**
 照片/视频发生改变时调用 - 选择、移动顺序、删除

 @param allList 所有类型的模型数组
 @param photos 照片类型的模型数组
 @param videos 视频类型的模型数组
 @param isOriginal 是否原图
 */
typedef void (^HXPhotoViewChangeCompleteBlock)(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photos, NSArray<HXPhotoModel *> *videos, BOOL isOriginal);

/**
 点击了添加cell的事件
 */
typedef void (^HXPhotoViewDidAddCellBlock)(HXPhotoView *myPhotoView);

/**
 当view高度改变时调用

 @param frame 位置大小
 */
typedef void (^HXPhotoViewUpdateFrameBlock)(CGRect frame);

/**
 点击取消时调用
 */
typedef void (^HXPhotoViewDidCancelBlock)(void);

/**
 删除网络图片时调用

 @param networkPhotoUrl 被删除的图片地址
 */
typedef void (^HXPhotoViewDeleteNetworkPhotoBlock)(NSString *networkPhotoUrl);

/**
 当前删除的模型

 @param model 模型
 @param index 下标
 */
typedef void (^HXPhotoViewCurrentDeleteModelBlock)(HXPhotoModel *model, NSInteger index);

/**
 长按手势结束时是否删除当前拖动的cell

 @param longPgr 长按手势识别器
 @param indexPath 当前拖动的cell
 @return 是否删除
 */
typedef BOOL (^HXPhotoViewShouldDeleteCurrentMoveItemBlock)(UILongPressGestureRecognizer *longPgr, NSIndexPath *indexPath);

/**
 长按手势发生改变时调用

 @param longPgr 长按手势识别器
 @param indexPath 当前拖动的cell
 */
typedef void (^HXPhotoViewLongGestureRecognizerChangeBlock)(UILongPressGestureRecognizer *longPgr, NSIndexPath *indexPath);

/**
 长按手势开始时调用

 @param longPgr 长按手势识别器
 @param indexPath 当前拖动的cell
 */
typedef void (^HXPhotoViewLongGestureRecognizerBeganBlock)(UILongPressGestureRecognizer *longPgr, NSIndexPath *indexPath);

/**
 长按手势结束时调用

 @param longPgr 长按手势识别器
 @param indexPath 当前拖动的cell
 */
typedef void (^HXPhotoViewLongGestureRecognizerEndedBlock)(UILongPressGestureRecognizer *longPgr, NSIndexPath *indexPath);

@protocol HXPhotoViewDelegate <NSObject>
@optional

/**
 照片/视频发生改变、HXPohotView初始化、manager赋值时调用 - 选择、移动顺序、删除、刷新视图
 调用 refreshView 会触发此代理
 
 @param photoView self
 @param allList 所有类型的模型数组
 @param photos 照片类型的模型数组
 @param videos 视频类型的模型数组
 @param isOriginal 是否原图
 */
- (void)photoView:(HXPhotoView *)photoView
   changeComplete:(NSArray<HXPhotoModel *> *)allList
           photos:(NSArray<HXPhotoModel *> *)photos
           videos:(NSArray<HXPhotoModel *> *)videos
         original:(BOOL)isOriginal;

- (void)photoViewChangeComplete:(HXPhotoView *)photoView
                   allAssetList:(NSArray<PHAsset *> *)allAssetList
                    photoAssets:(NSArray<PHAsset *> *)photoAssets
                    videoAssets:(NSArray<PHAsset *> *)videoAssets
                       original:(BOOL)isOriginal;

/**
 相册相片列表点击了完成按钮/删除/移动、HXPohotView初始化且有数据、manager赋值且有数据时
 调用 refreshView 不会触发此代理

 @param photoView self
 @param allList 所有类型的模型数组
 @param photos 照片类型的模型数组
 @param videos 视频类型的模型数组
 @param isOriginal 是否原图
 */
- (void)photoListViewControllerDidDone:(HXPhotoView *)photoView
                               allList:(NSArray<HXPhotoModel *> *)allList
                                photos:(NSArray<HXPhotoModel *> *)photos
                                videos:(NSArray<HXPhotoModel *> *)videos
                              original:(BOOL)isOriginal;

/**
 点击了添加cell的事件

 @param photoView self
 */
- (void)photoViewDidAddCellClick:(HXPhotoView *)photoView;

/**
 当view高度改变时调用

 @param photoView self
 @param frame 位置大小
 */
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame;

/**
 点击取消时调用

 @param photoView self
 */
- (void)photoViewDidCancel:(HXPhotoView *)photoView;

/**
 删除网络图片时调用

 @param photoView self
 @param networkPhotoUrl 被删除的图片地址
 */
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl;

/**
 当前删除的模型

 @param photoView self
 @param model 模型
 @param index 下标
 */
- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index;

/**
 长按手势结束时是否删除当前拖动的cell
 
 @param photoView self
 @return 是否删除
 */
- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView
                           gestureRecognizer:(UILongPressGestureRecognizer *)longPgr
                                   indexPath:(NSIndexPath *)indexPath;

/**
 长按手势发生改变时调用

 @param photoView self
 @param longPgr 长按手势识别器
 */
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath;

/**
 长按手势开始时调用

 @param photoView self
 @param longPgr 长按手势识别器
 */
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath;

/**
 长按手势结束时调用

 @param photoView self
 @param longPgr 长按手势识别器
 */
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath;

/**
 collectionView是否可以选择item（不包括添加按钮）

 @param photoView self
 @param indexPath 选择Cell的indexPath
 @return yes 可以选 no 不可以,点击无反应
 */
- (BOOL)photoView:(HXPhotoView *)photoView collectionViewShouldSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(HXPhotoModel *)model;

/// 当前选择的model数组，不是已经选择的model数组
/// 例: 已经选择了 照片1、视频1，再跳转相册选择了照片2、视频2，那么一共就是 照片1、视频1、照片2、视频2.那这个代理返回的数据就是 照片2、视频2
/// 只有在相册列表点了确定按钮才会触发
/// @param allList 所有类型
/// @param photos 照片类型
/// @param videos 视频类型
/// @param isOriginal 是否原图
- (void)photoViewCurrentSelected:(NSArray<HXPhotoModel *> *)allList
                          photos:(NSArray<HXPhotoModel *> *)photos
                          videos:(NSArray<HXPhotoModel *> *)videos
                        original:(BOOL)isOriginal;

/// 取消预览大图的回调
/// @param photoView self
- (void)photoViewPreviewDismiss:(HXPhotoView *)photoView;

/// 实现这个代理返回的高度就是HXPhotoView的高度，不会进行自动计算高度.
/// 每次需要更新高度的时候触发，请确保高度正确
/// @param photoView self
- (CGFloat)photoViewHeight:(HXPhotoView *)photoView;
@end

@interface HXPhotoView : UIView
#pragma mark - < init >
- (instancetype)initWithFrame:(CGRect)frame manager:(HXPhotoManager *)manager;
- (instancetype)initWithFrame:(CGRect)frame manager:(HXPhotoManager *)manager scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
- (instancetype)initWithManager:(HXPhotoManager *)manager;
- (instancetype)initWithManager:(HXPhotoManager *)manager scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
+ (instancetype)photoManager:(HXPhotoManager *)manager;
+ (instancetype)photoManager:(HXPhotoManager *)manager scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

- (NSIndexPath *)currentModelIndexPath:(HXPhotoModel *)model;
@property (weak, nonatomic) id<HXPhotoViewDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSIndexPath *currentIndexPath; // 自定义转场动画时用到的属性
@property (strong, nonatomic) HXCollectionView *collectionView;

#pragma mark - < Block >
/**  照片/视频发生改变时调用 - 选择、移动顺序、删除  */
@property (copy, nonatomic) HXPhotoViewChangeCompleteBlock changeCompleteBlock;
/**  点击了添加cell  */
@property (copy, nonatomic) HXPhotoViewDidAddCellBlock didAddCellBlock;
/**  当view高度改变时调用  */
@property (copy, nonatomic) HXPhotoViewUpdateFrameBlock updateFrameBlock;
/**  点击取消时调用  */
@property (copy, nonatomic) HXPhotoViewDidCancelBlock didCancelBlock;
/**  删除网络图片时调用  */
@property (copy, nonatomic) HXPhotoViewDeleteNetworkPhotoBlock deleteNetworkPhotoBlock;
/**  当前删除的模型  */
@property (copy, nonatomic) HXPhotoViewCurrentDeleteModelBlock currentDeleteModelBlock;
/**  长按手势结束时是否删除当前拖动的cell  */
@property (copy, nonatomic) HXPhotoViewShouldDeleteCurrentMoveItemBlock shouldDeleteCurrentMoveItemBlock;
/**  长按手势发生改变时调用  */
@property (copy, nonatomic) HXPhotoViewLongGestureRecognizerChangeBlock longGestureRecognizerChangeBlock;
/**  长按手势开始时调用  */
@property (copy, nonatomic) HXPhotoViewLongGestureRecognizerBeganBlock longGestureRecognizerBeganBlock;
/**  长按手势结束时调用  */
@property (copy, nonatomic) HXPhotoViewLongGestureRecognizerEndedBlock longGestureRecognizerEndedBlock;

#pragma mark - < Configuration >
/// default is UICollectionViewScrollDirectionVertical
/// 重新设置需要调用 refreshView 刷新界面
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
/**  是否把相机功能放在外面 默认NO  */
@property (assign, nonatomic) IBInspectable BOOL outerCamera;
/** 每行个数 默认 3
 *  cell的宽高取决于 每行个数 与 HXPhotoView 的宽度 和 item间距
 *  cell.width = (view.width - (lineCount - 1) * spacing - contentInset.left - contentInset.right) / lineCount
 *  横向布局时 cell.width -= 10
 */
@property (assign, nonatomic) NSInteger lineCount;
/**  每个item间距 默认 3  */
@property (assign, nonatomic) CGFloat spacing;
/**  隐藏cell上的删除按钮  */
@property (assign, nonatomic) BOOL hideDeleteButton;
/**  cell是否可以长按拖动编辑  */
@property (assign, nonatomic) BOOL editEnabled;
/**  是否显示添加的cell 默认 YES  */
@property (assign, nonatomic) BOOL showAddCell;
/**  预览大图时是否显示删除按钮  */
@property (assign, nonatomic) BOOL previewShowDeleteButton;
/**  添加按钮的图片  */
@property (copy, nonatomic) NSString *addImageName;
/**  删除按钮图片  */
@property (copy, nonatomic) NSString *deleteImageName;
/**  预览大图时是否禁用手势返回  默认NO  */
@property (assign, nonatomic) BOOL disableaInteractiveTransition;
/**  是否拦截添加Cell的点击事件 默认NO  */
@property (assign, nonatomic) BOOL interceptAddCellClick;
/**  删除网络图片时是否显示Alert 默认NO  */
@property (assign, nonatomic) BOOL showDeleteNetworkPhotoAlert;
/**  预览大图时的风格样式  */
@property (assign, nonatomic) HXPhotoViewPreViewShowStyle previewStyle;
/// 底部选择视图是否自适应暗黑风格
@property (assign, nonatomic) BOOL adaptiveDarkness;

/**  跳转相册 如果需要选择相机/相册时 还是需要选择  */
- (void)goPhotoViewController;
/**  跳转相册 过滤掉选择 - 不管需不需要选择 直接前往相册  */
- (void)directGoPhotoViewController;
/**  跳转相机  */
- (void)goCameraViewController;
/**  删除某个模型  */
- (void)deleteModelWithIndex:(NSInteger)index;
/**  刷新view  */
- (void)refreshView;
/**  跳转预览大图的界面  */
- (void)jumpPreviewViewControllerWithModel:(HXPhotoModel *)model;
- (void)jumpPreviewViewControllerWithIndex:(NSInteger)index;
/**  根据坐标获取cell
 *   point 传入的坐标是在HXPhotoView上的坐标,里面已经做了转换处理
 */
- (HXPhotoSubViewCell *)previewingContextViewWithPoint:(CGPoint)point;
- (HXPhotoSubViewCell *)collectionViewCellWithIndex:(NSInteger)index;
@end
