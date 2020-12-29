//
//  ZWMSegmentController.m
//  ZWMSegmentController
//
//  Created by 伟明 on 2017/11/23.
//  Copyright © 2017年 伟明. All rights reserved.
//

#import "ZWMSegmentController.h"

#define kSCREENBOUNDS [[UIScreen mainScreen] bounds]
typedef NS_ENUM(NSUInteger, ZWMScrollRectPosition) {
    ZWMScrollRectPositionOrigin, // 在原始位置
    ZWMScrollRectPositionAcross, // 在中间段位置
    ZWMScrollRectPositionTarget, // 到达目标位置
};
typedef void(^ZWMViewControllerIndexBlock)(NSUInteger, UIButton *, UIViewController *);

@interface ZWMSegmentController ()
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
@property (nonatomic, strong, readwrite) ZWMSegmentView *segmentView;
@property (nonatomic, strong, readwrite) UIScrollView *containerView;
@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint viewOrigin; // 记录原始位置
@property (nonatomic, assign) CGSize offsetSize;  /**< 这个属性是用在badge上的偏移，width是_buttonSpace,height是titleLabel的y*/
@property (nonatomic, copy) ZWMViewControllerIndexBlock indexBlock;
@end

@implementation ZWMSegmentController

+ (instancetype)segmentControllerWithTitles:(NSArray<NSString *> *)titles {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, kSCREENBOUNDS.size.width, kSCREENBOUNDS.size.height) titles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super init];
    if (!self || titles.count == 0) {
        return nil;
    }
    
    _titles = titles;
    _size = frame.size;
    _viewOrigin = frame.origin;
    _pagingEnabled = YES;
    _bounces = NO;
    self.view.frame = frame;
    
    [self segmentPageSetting];
    [self containerViewSetting];
    
    return self;
}

- (void)segmentPageSetting {
    _segmentView = [[ZWMSegmentView alloc] initWithFrame:CGRectMake(0, 0, _size.width, 36) titles:_titles];
    _segmentView.backgroundColor=[UIColor whiteColor];
    @weakify(self)
    [_segmentView selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        @strongify(self)
        [self moveToViewControllerAtIndex:index];
    }];
    [self.view addSubview:_segmentView];
    
    UIButton *button = _segmentView.buttons.firstObject;
    _offsetSize = CGSizeMake(_segmentView.buttonSpace, (ZWMSegmentHeight - [@"ZWM" sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}].height) / 2);
}

- (void)containerViewSetting {
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ZWMSegmentHeight, _size.width, _size.height - ZWMSegmentHeight)];
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.delegate = self;
    _containerView.pagingEnabled = _pagingEnabled;
    _containerView.bounces = _bounces;
#pragma mark 禁止滑动
    _containerView.scrollEnabled = NO;
    [self.view addSubview:_containerView];
}

#pragma mark ---- scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _containerView) {
        NSInteger index = round(scrollView.contentOffset.x / _size.width);
        
        // 移除不足一页的操作
        if (index != self.index) {
            [self setSelectedAtIndex:index];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _containerView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        
        [_segmentView adjustOffsetXToFixIndicatePosition:offsetX];
    }
}

#pragma mark ---- index

- (void)setSelectedAtIndex:(NSUInteger)index {
    [_segmentView setSelectedAtIndex:index];
}

- (void)moveToViewControllerAtIndex:(NSUInteger)index {
    [self scrollContainerViewToIndex:index];
    
    UIViewController *targetViewController = self.viewControllers[index];
    if ([self.childViewControllers containsObject:targetViewController] || !targetViewController) {
        return;
    }
    
    [self updateFrameChildViewController:targetViewController atIndex:index];
}

- (void)selectedAtIndex:(void (^)(NSUInteger, UIButton * _Nonnull, UIViewController * _Nonnull))indexBlock {
    if (indexBlock) {
        _indexBlock = indexBlock;
    }
}

- (void)updateFrameChildViewController:(UIViewController *)childViewController atIndex:(NSUInteger)index {
    childViewController.view.frame = CGRectOffset(CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height), index * _size.width, 0);
    
    [_containerView addSubview:childViewController.view];
    [self addChildViewController:childViewController];
}

#pragma mark ---- scroll

- (void)scrollContainerViewToIndex:(NSUInteger)index {
//    [UIView animateWithDuration:_segmentView.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self->_containerView setContentOffset:CGPointMake(index * _size.width, 0) animated:NO];
//    } completion:^(BOOL finished) {
//        if (self->_indexBlock) {
//            self->_indexBlock(index, _segmentView.selectedButton, self.currentViewController);
//        }
//    }];
    
      [self->_containerView setContentOffset:CGPointMake(index * _size.width, 0) animated:NO];
    if (self->_indexBlock) {
        self->_indexBlock(index, _segmentView.selectedButton, self.currentViewController);
    }
}
#pragma mark ---- set

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    _containerView.contentSize = CGSizeMake(viewControllers.count * _size.width, _size.height - ZWMSegmentHeight);
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    _pagingEnabled = pagingEnabled;
    
    self.containerView.pagingEnabled = pagingEnabled;
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    
    self.containerView.bounces = bounces;
}

#pragma mark ---- get

- (NSUInteger)index {
    return self.segmentView.index;
}

- (UIViewController *)currentViewController {
    return self.viewControllers[self.index];
}

#pragma mark ---- 分类(UIView)

- (void)enumerateBadges:(NSArray<NSNumber *> *)badges {
    [badges enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = self.segmentView.buttons[idx];
        [button addNumberBadge:obj.integerValue badgeOffsetSize:_offsetSize color:_segmentView.segmentTintColor borderColor:_segmentView.backgroundColor];
    }];
}

- (void)addCurrentBadgeByNumber_1 {
    [self.segmentView.selectedButton addNumber_1];
}

- (void)reduceCurrentBadgeByNumber_1 {
    [self.segmentView.selectedButton reduceNumber_1];
}

- (void)clearAllBadges {
    [_segmentView.buttons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj clearNumberBadge];
    }];
}

- (void)clearCurrentBadge {
    [self.segmentView.selectedButton clearNumberBadge];
}

@end

#pragma mark ---- 分类(UIViewController)

#import <objc/runtime.h>

@implementation UIViewController(ZWMSegment)
@dynamic segmentController;

- (ZWMSegmentController *)segmentController {
    if ([self.parentViewController isKindOfClass:[ZWMSegmentController class]] && self.parentViewController) {
        return (ZWMSegmentController *)self.parentViewController;
    }
    return nil;
}

- (void)addSegmentController:(ZWMSegmentController *)segment {
    if (self == segment) {
        return;
    }
    
    [self.view addSubview:segment.view];
    [self addChildViewController:segment];
    
    // 默认加入第一个控制器
    UIViewController *firstViewController = segment.viewControllers.firstObject;
    [segment performSelector:@selector(updateFrameChildViewController:atIndex:) withObject:firstViewController withObject:0];
}
@end
