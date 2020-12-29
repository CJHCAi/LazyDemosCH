//
//  LJTitleBarView.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^scrollViewBlock)(NSInteger);

@interface LJTitleBarView : UIScrollView

/**scrollView里的按钮被点击的block*/
@property (nonatomic, copy) scrollViewBlock block;

/*!
 @brief 当水平scroolView滚动确定的回调方法
 @param scrollView滚动的页数
 */
- (void) scrollViewIndex:(NSInteger)index;

/*!
 @brief 初始化方法
 @param fram
 @param titles
 */
- (instancetype)initWithFrame:(CGRect)frame addTitles:(NSArray *)titles;

@end
