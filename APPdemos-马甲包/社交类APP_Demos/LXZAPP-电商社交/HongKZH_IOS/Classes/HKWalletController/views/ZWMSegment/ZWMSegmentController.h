//
//  ZWMSegmentController.h
//  ZWMSegmentController
//
//  Created by 伟明 on 2017/11/23.
//  Copyright © 2017年 伟明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMSegmentView.h"
#import "UIView+ZWMBadge.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZWMSegmentController : UIViewController<UIScrollViewDelegate>

/// initial
+ (__nullable instancetype)segmentControllerWithTitles:(NSArray <NSString *>*)titles;
- (__nullable instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@property (nonatomic, strong) NSArray <UIViewController *>*viewControllers;
@property (nonatomic, strong, readonly) ZWMSegmentView *segmentView;
@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, strong, readonly) UIScrollView *containerView;
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, getter=isPagingEnabled) BOOL pagingEnabled;
@property (nonatomic, getter=isBounces) BOOL bounces;

/// index
- (void)selectedAtIndex:(void(^)(NSUInteger index, UIButton *button, UIViewController *viewController))indexBlock;
- (void)setSelectedAtIndex:(NSUInteger)index;

/// number badge
- (void)enumerateBadges:(NSArray <NSNumber *>*)badges;
- (void)reduceCurrentBadgeByNumber_1;
- (void)addCurrentBadgeByNumber_1;
- (void)clearCurrentBadge;
- (void)clearAllBadges;

@end

@interface UIViewController (ZWMSegment)
@property (nonatomic, strong, readonly, nullable) ZWMSegmentController *segmentController;
- (void)addSegmentController:(ZWMSegmentController *)segment;
@end

NS_ASSUME_NONNULL_END
