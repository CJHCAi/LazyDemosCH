//
//  PhotoItemView.h
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/5.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "PhotoImageView.h"
#import "PhotoBroswerVC.h"

@interface PhotoItemView : UIView

/** 相册模型 */
@property (nonatomic,strong) PhotoModel *photoModel;

/** 缩放比例回归正常 */
@property (nonatomic,assign) BOOL isScaleNormal;

/** 单击 */
@property (nonatomic,copy) void (^ItemViewSingleTapBlock)();

/** 长按回调 */
@property (nonatomic, copy) void (^ItemViewLongPressBlock)();

/** 当前的页标 */
@property (nonatomic,assign) NSUInteger pageIndex;

/** 是否有图片数据 */
@property (nonatomic,assign) BOOL hasImage;

/** 当前缩放比例 */
@property (nonatomic,assign) CGFloat zoomScale;


/** 展示照片的视图 */
@property (nonatomic,strong) PhotoImageView *photoImageView;

/** type */
@property (nonatomic,assign) PhotoBroswerVCType type;


/*
 *  处理bottomView
 */
-(void)handleBotoomView;



/*
 *  保存图片及回调
 */
-(void)save:(void(^)())ItemImageSaveCompleteBlock failBlock:(void(^)())failBlock;


/** 缩回正常 */
-(void)zoomDismiss:(void(^)())compeletionBlock;



/*
 *  重置
 */
-(void)reset;


@end
