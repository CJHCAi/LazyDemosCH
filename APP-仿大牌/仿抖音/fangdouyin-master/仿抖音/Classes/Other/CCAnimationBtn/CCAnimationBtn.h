//
//  CCAnimationBtn.h
//  AnimationButton
//
//  Created by sischen on 2017/11/25.
//  Copyright © 2017年 pcbdoor.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCAnimationBtn : UIButton

/**
 线条数量，默认6
 */
@property (nonatomic, assign) NSInteger lineCount;

/**
 线条末端宽度，默认11.5
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 线条长度相对控件半个尺寸比例，默认0.75
 */
@property (nonatomic, assign) CGFloat lineLengthPercent;

/**
 中心图片相对控件尺寸比例，默认0.7
 */
@property (nonatomic, assign) CGFloat imgSizePercent;

/**
 动画总时长，默认1.1
 */
@property (nonatomic, assign) CFTimeInterval animationTime;

/**
 线条颜色，默认桃红色
 */
@property (nonatomic, strong) UIColor *lineColor;

@end

