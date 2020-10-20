//
//  HBdansView.h
//  弹幕
//
//  Created by 伍宏彬 on 15/10/14.
//  Copyright (c) 2015年 伍宏彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WHB.h"

@interface HBdansView : UIView
/**
 *  使用此方法传入弹幕内容数组，需自行调用starDans方法
 *
 *  @param frame    frame
 *  @param contents 弹幕内容数组,必须包含的是字符串
 *
 *  @return HBdansView
 */
- (instancetype)initDansViewFrame:(CGRect)frame contents:(NSMutableArray *)contents;
/**
 *  启动弹幕
 */
- (void)starDans;
/**
 *  下一条文字
 */
- (void)addRandomText:(NSString *)randomText;
/**
 *  屏幕内最多显示的条数(最小值为1（默认值） 最大10)
 */
@property (nonatomic, assign) NSInteger countInScreen;
/**
 *  圆角值
 */
@property (nonatomic, assign) CGFloat roundVaule;
/**
 *  边线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  边线颜色
 */
@property (nonatomic, copy) UIColor *lineColor;
/**
 *  文字颜色
 */
@property (nonatomic, copy) UIColor *textColor;
/**
 *  文字背景颜色
 */
@property (nonatomic, copy) UIColor *textBackColor;

@end
