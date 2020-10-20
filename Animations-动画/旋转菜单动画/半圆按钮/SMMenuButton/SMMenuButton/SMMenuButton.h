//
//  SMMenuButton.h
//  SMMenuButton
//
//  Created by 朱思明 on 14/1/5.
//  Copyright (c) 2015年 朱思明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMMenuButton;
@protocol SMMenuButtonDelegate <NSObject>

/*
 *  点击菜单子按钮协议事件
 */
- (void)menuButton:(SMMenuButton *)menuButton clickedMenuButtonAtIndex:(NSInteger)buttonIndex;

/*
 *  将要打开菜单按钮事件
 */
- (void)menuButtonWillOpen:(SMMenuButton *)menuButton;

/*
 *  将要关闭菜单按钮事件
 */
- (void)menuButtonWillClose:(SMMenuButton *)menuButton;
@end

@interface SMMenuButton : UIButton

@property (nonatomic,copy) NSString *bgImageName;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *subButtonbgImageName;
@property (nonatomic,strong) NSArray *subButtonImageNames;

/*
 *  第一个按钮的弧度（方向）
 *  default 0 方向为水平方向向左
 */
@property (nonatomic,assign) double start_pi; // default 0

// 第一个按钮到最后一个按钮之间的弧度
@property (nonatomic,assign) double center_pi; // default M_PI_2

// 当前按钮的状态 YES:打开 NO:关闭
@property (nonatomic,assign) BOOL isOpen;

// 保存所有子试图按钮
@property (nonatomic,strong) NSArray *subButtons;

// 设置菜单按钮视图的大小
@property (nonatomic,assign) CGSize subButton_size; // default {44,44}

// 弹出按钮的距离
@property (nonatomic,assign) double lenght; // default 100px;

// 代理对象
@property (nonatomic,weak) id<SMMenuButtonDelegate> delegate;

/**
 *  自定义动画按钮
 *
 *  @param bgImageName          自身背景图片的名字
 *  @param imageName            自身标题图片的名字
 *  @param subButtonbgImageName 所有子视图背景图片的名字
 *  @param subButtonImageNames  所有子视图标题图片的名字（有几个图片就有几个按钮）
 *  @param frame                自身的大小
 *
 *  @return 自定义动画按钮对象
 */
- (id)initWithBackgroudImageName:(NSString *)bgImageName
                       imageName:(NSString *)imageName
     subButtonBackgroudImageName:(NSString *)subButtonbgImageName
             subButtonImageNames:(NSArray *)subButtonImageNames
                           Frame:(CGRect)frame;
/*
 *  打开菜单按钮
 */
- (void)openMenuButton;

/*
 *  关闭菜单按钮
 */
- (void)closeMenuButton;


@end
