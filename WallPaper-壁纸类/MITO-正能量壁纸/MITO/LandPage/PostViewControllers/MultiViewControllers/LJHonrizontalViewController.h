//
//  LJHonrizontalViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^scrollViewblock)(NSInteger);

@interface LJHonrizontalViewController : UIViewController

/**scrollView滚动回调的block*/
@property (nonatomic, copy) scrollViewblock block;

/*!
 @brief 当点击按钮后的scrollView随之滚动的回调方法

 */
- (void) scrollViewIndex:(NSInteger)index;

/*!
 @brief 初始化方法

 */
- (instancetype)initWithControllers:(NSArray *)controllers;

@end
