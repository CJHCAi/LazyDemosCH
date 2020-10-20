//
//  UIButton+CCFavoriteAnimation.h
//  AnimationButton
//
//  Created by sischen on 2018/10/4.
//  Copyright © 2018年 Xiaosao6. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (CCFavoriteAnimation)


/**
 线条数量，默认6
 */
@property (nonatomic, assign) NSInteger ccLineCount;

/**
 线条最大宽度，默认10.0
 */
@property (nonatomic, assign) CGFloat ccLineWidth;

/**
 线条长度相对整体的尺寸比例，默认0.4
 */
@property (nonatomic, assign) CGFloat ccLineLengthRatio;

/**
 中心icon相对整体的尺寸比例，默认0.7
 */
@property (nonatomic, assign) CGFloat ccImgSizeRatio;

/**
 动画时长(秒)，默认1.2
 */
@property (nonatomic, assign) CFTimeInterval ccAnimationTime;

/**
 icon与线条颜色，默认桃红色: #F44C74
 */
@property (nonatomic, strong) UIColor *ccLineColor;

/**
 未点赞时的颜色，默认白色
 */
@property (nonatomic, strong) UIColor *ccUnchosenColor;

/**
 未点赞时,样式是否为线条, 默认NO(填充)
 */
@property (nonatomic, assign) BOOL ccIsUnchosenStyleStroke;

/**
 未点赞时,线条样式宽度, 默认5
 */
@property (nonatomic, assign) CGFloat ccUnchosenStrokeWidth;


/**
 是否打开点赞icon样式, 默认NO
 */
@property (nonatomic, assign) BOOL ccIsFavoriteAnimationEnabled;



/**
 是否点赞,默认带有动画
 */
@property (nonatomic, assign) BOOL ccIsFavorite;


@end
