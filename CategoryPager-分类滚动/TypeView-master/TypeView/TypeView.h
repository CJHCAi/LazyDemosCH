//
//  TypeView.h
//  TypeView
//
//  Created by weizhongming on 2017/4/17.
//  Copyright © 2017年 航磊_. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 回调点击的第几个按钮
 @param page 第几个按钮
 */
typedef void(^ResendBlock)(NSInteger page);

@interface TypeView : UIView

@property (nonatomic, strong) UIScrollView *observerScrollView;

/**
 线的宽度
 */
@property (assign, nonatomic) CGFloat lineView_Width;

/**
 按钮的宽度
 */
@property (assign, nonatomic) CGFloat button_Width;

/**
 初始化时第几个按钮时被选中状态
 */
@property (nonatomic, assign) int typeIndex;

/**
 记录上一次点击的按钮
 */
@property (nonatomic, strong) UIButton *lastButton;

/**
 各个分类的父视图
 */
@property (nonatomic, strong)  UIScrollView *scrollView;

/**
 数据源
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 按钮下面的线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 点击按钮后的回调
 */
@property (nonatomic, copy) ResendBlock resendBlock;



/**
 *  记录scrollView在第几页,结束滑动时调用
 *
 *  @param number 第几页x
 */
- (void)scrollViewNumber:(int)number;

/**
 *  开始滑动时调用,记录现在的位置,然后判断srollView往那个方向滑动
 *
 *  @param begin 现在的x位置
 */
- (void)scrollViewBegin:(CGFloat)begin;


/**
 刷新view

 @param datas ...
 */
- (void)updateView:(id)datas;

@end
