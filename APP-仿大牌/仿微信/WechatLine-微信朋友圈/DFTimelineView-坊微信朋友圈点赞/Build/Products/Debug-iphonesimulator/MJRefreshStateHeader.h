//
//  MJRefreshStateHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshStateHeader : MJRefreshHeader
#pragma mark - 刷新时间相关
/** 利用这个block来决定显示的更新时间文字 */
@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
/** 显示上一次刷新时间的label */
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark - 状态相关
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com