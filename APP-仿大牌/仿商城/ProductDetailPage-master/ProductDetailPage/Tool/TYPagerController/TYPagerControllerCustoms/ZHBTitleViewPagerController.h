//
//  ZHBTitleViewPagerController.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/20.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "TYPagerController.h"
@class ZHBTitleViewPagerController;

@protocol ZHBTitleViewPagerControllerDataSource <NSObject>

// 提供的字符串数组
- (NSArray *)arrayInZHBTitleViewPagerController;

@optional
// did select indexPath
- (void)titleViewPagerController:(ZHBTitleViewPagerController *)pagerController didSelectAtIndex:(NSInteger)index;

// did scroll to page index
- (void)titleViewPagerController:(ZHBTitleViewPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index;

@end

@interface ZHBTitleViewPagerController : TYPagerController

// alpha变化
@property (nonatomic, strong) UIView *navTitleBar; // nav视图


@property (nonatomic, strong, readonly) UIView *progressView;
// progress view
@property (nonatomic, assign) CGFloat progressHeight;
//@property (nonatomic, assign) CGFloat progressWidth; //if>0 progress width is equal,else progress width is cell width

//   animate duration
@property (nonatomic, assign) CGFloat animateDuration;
// text font
@property (nonatomic, strong) UIFont *normalTextFont;


@property (nonatomic, weak) id<ZHBTitleViewPagerControllerDataSource> titleViewDelegate;


- (void)upTransformWhenScorllToWeb;
- (void)downTransformWhenScorllToTab;
@end
