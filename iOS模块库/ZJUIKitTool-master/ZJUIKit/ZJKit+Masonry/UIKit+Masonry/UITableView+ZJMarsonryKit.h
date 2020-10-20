//
//  UITableView+ZJMarsonryKit.h
//  ZJUIKit
//
//  Created by dzj on 2018/1/17.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//



@interface UITableView (ZJMarsonryKit)

/**
 *
 *    创建一个表视图，如果superview不是nil，它将被添加约束。它的边将永远等于超级视图。.
 *
 *    @param superView    The super view for table view.
 *
 *    @return The table view instance.
 */
+ (instancetype)zj_tableViewWithSuperview:(UIView *)superView;

/**
 *
 *    创建一个表视图，如果superview是nil，约束将被忽略。.
 *
 *    @param superView        The super view for table view.
 *    @param constraints    Make constraints for table view.
 *
 *    @return The table view instance.
 */
+ (instancetype)zj_tableViewWithSuperview:(UIView *)superView
                               constraints:(ZJConstrainMaker)constraints;

/**
 *
 *    创建一个表视图，如果superview不是nil，它将被添加约束。它的边缘将永远等于超级视图。
 *
 *    @param superView    The super view for table view.
 *    @param delegate   Delgate and dataSource.
 *
 *    @return The table view instance.
 */
+ (instancetype)zj_tableViewWithSuperview:(UIView *)superView delegate:(id)delegate;

/**
 *
 *    创建一个表视图，如果superview是nil，约束将被忽略。
 *
 *    @param superView        The super view for table view.
 *    @param delegate     Delgate and dataSource.
 *    @param constraints    Make constraints for table view.
 *
 *    @return The table view instance.
 */
+ (instancetype)zj_tableViewWithSuperview:(UIView *)superView
                                  delegate:(id)delegate
                               constraints:(ZJConstrainMaker)constraints;

/**
 *
 *    创建一个表视图，如果superview是nil，约束将被忽略。可以指定表格视图的风格。
 *
 *    @param superView        The super view for table view.
 *    @param delegate     Delgate and dataSource.
 *    @param style         UITableViewStyle.
 *    @param constraints    Make constraints for table view.
 *
 *    @return The table view instance.
 */
+ (instancetype)zj_tableViewWithSuperview:(UIView *)superView
                                  delegate:(id)delegate
                                     style:(UITableViewStyle)style
                               constraints:(ZJConstrainMaker)constraints;

@end
