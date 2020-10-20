//
//  YGLoadingView.h
//  AnimationOneDemo
//
//  Created by 数联通 on 2019/3/29.
//  Copyright © 2019年 dothisday. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGLoadingView : UIView

/** 创建视图中心加载loading（有黑色半透明背景）*/
-(instancetype)initCenterLoadingWithSuperView:(UIView *)superView;
/** 创建下拉视图的loading，*/
-(instancetype)initPullLoadingWithScrollerView:(UIScrollView *)scrollerView refreshingBlock:(void(^)(YGLoadingView *refreshView))refreshingBlcok;

/** 开始loading（下拉刷新请勿主动调用）*/
-(void)startLoading;
/** 结束loading*/
-(void)hideLoading;

@end

NS_ASSUME_NONNULL_END
