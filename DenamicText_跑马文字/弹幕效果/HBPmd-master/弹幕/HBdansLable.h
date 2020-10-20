//
//  HBdansLable.h
//  弹幕
//
//  Created by 伍宏彬 on 15/10/14.
//  Copyright (c) 2015年 伍宏彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WHB.h"

@class HBdansLable;

@protocol HBdansLableDelegate <NSObject>

/**判断是否滚出屏幕外面，并回准备回收实例**/
- (void)dansLable:(HBdansLable *)dansLable isOutScreen:(BOOL)isOutScreen;

@end

@interface HBdansLable : UILabel

+ (instancetype)dansLableFrame:(CGRect)frame;


@property (nonatomic, weak) id<HBdansLableDelegate>  delegate;

@property (nonatomic, assign) CGFloat roundVaule;
/**
 *  边线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  边线颜色
 */
@property (nonatomic, copy) UIColor *lineColor;

@end
