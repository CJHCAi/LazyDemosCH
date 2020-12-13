//
//  YIMScrollSelectView.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YIMScrollSelectView;

@protocol YIMScrollSelectViewDatasource <NSObject>
@required
/**一共有多少个选择项*/
-(NSInteger)numberOfItems:(YIMScrollSelectView*)selectView;
/**一般状态下的选择项View*/
-(UIView*)normalView:(YIMScrollSelectView*)selectView atIndex:(NSInteger)index;
/**选中状态的选择项View*/
-(UIView*)selectedView:(YIMScrollSelectView*)selectView atIndex:(NSInteger)index;
@optional
/**选择项的大小*/
-(CGSize)itemSize:(YIMScrollSelectView*)selectView;


@end

@protocol YIMScrollSelectViewDelegate <NSObject>
@optional
/** 选中时执行 */
-(void)YIMScrollSelectView:(YIMScrollSelectView*)selectView didSelectedIndex:(NSInteger)index;
/**
 滚动时执行
 返回值决定是否要在滚动时切换选中index
 */
-(BOOL)YIMScrollSelectView:(YIMScrollSelectView*)selectView didScrollSelected:(NSInteger)index;
/**
 动画切换选择View
 在此方法内执行支持动画的属性修改将以动画展示
 
 @param selectView self
 @param oldSelectedView 旧的选中View，这个View将被此处的Normal View替换
 @param oldNormalView 旧的未选中View，这个View将被Selected View替换
 */
-(void)animation:(YIMScrollSelectView*)selectView oldSelectedView:(UIView*)oldSelectedView oldNormalView:(UIView*)oldNormalView;
@end


/**滚动选择器View*/
@interface YIMScrollSelectView : UIView

@property(nonatomic,weak)id<YIMScrollSelectViewDatasource> dataSource;
@property(nonatomic,weak)id<YIMScrollSelectViewDelegate> delegate;

/**手动选择index*/
-(void)selectedIndex:(NSInteger)index animation:(BOOL)animation;
/**刷新数据*/
-(void)reloadData;

@end
