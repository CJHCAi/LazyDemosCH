//
//  CYCropView.h
//  CYImageCrop
//
//  Created by Cyrus on 16/6/9.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYCropScaleType) {
    CYCropScaleTypeCustom,
    CYCropScaleTypeOriginal,
    CYCropScaleType1To1,
    CYCropScaleType3To2,
    CYCropScaleType2To3,
    CYCropScaleType4To3,
    CYCropScaleType3To4,
    CYCropScaleType16To9,
    CYCropScaleType9To16,
};

@interface CYCropView : UIView

#pragma mark - 功能

/** 裁剪框的 frame */
@property (nonatomic, assign, readonly)CGRect cropFrame;

/** 裁剪框占据整个视图的位置比例（0，0，0，0）是左上角 （1，1，1，1）是右下角*/
@property (nonatomic, assign, readonly)CGRect cropFrameRatio;

/** 设置缩放的长宽比 */
@property (nonatomic, assign)CYCropScaleType scaleType;

/** 设置缩放的长宽比，以及是否进行动画 */
- (void)setScaleType:(CYCropScaleType)scaleType animated:(BOOL)animated;

/** 每次拖动裁剪框后的回调 */
@property (nonatomic, copy)void (^completionHandler) ();

#pragma mark - 外观

/** 裁剪框边框粗细 */
@property (nonatomic, assign)CGFloat borderWidth;
/** 遮罩层颜色 */
@property (nonatomic, strong)UIColor *maskColor;
/** 裁剪框最小边长 */
@property (nonatomic, assign)CGFloat minLenghOfSide;


@end