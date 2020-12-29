//
//  LJMultiViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJRootViewController.h"
#import "LJTitleBarView.h"
#import "LJHonrizontalViewController.h"

@interface LJMultiViewController : LJRootViewController

/**子标题视图*/
@property (nonatomic, strong) LJTitleBarView *titleBarView;

/**子视图控制器的承载控制器*/
@property (nonatomic, strong) LJHonrizontalViewController *honrizontalVC;
/*!
 @brief 初始化方法
 @param titles  子视图控制器的title

 */
- (instancetype)initWithSubTitles:(NSArray *)titles addControllers:(NSArray *)controllers;


@end
