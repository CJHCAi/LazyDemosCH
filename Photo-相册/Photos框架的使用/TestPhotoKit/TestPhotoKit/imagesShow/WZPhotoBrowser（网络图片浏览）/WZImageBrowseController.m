//
//  WZImageBrowseController.m
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageBrowseController.h"

#pragma mark - WZImageBrowseController
@interface WZImageBrowseController ()<UIPageViewControllerDataSource,
                                      UIPageViewControllerDelegate,
                                      UIViewControllerTransitioningDelegate,
                                      WZProtocolImageScrollView
                                     >

@end

@implementation WZImageBrowseController

#pragma mark - Initialize
- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options {
    NSMutableDictionary *configOptions = [NSMutableDictionary dictionaryWithDictionary:options?:@{}];
    //页面间隔设置
    configOptions[UIPageViewControllerOptionInterPageSpacingKey] = @(10);
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:navigationOrientation options:configOptions]) {
        //自定义模态跳转模式
        //        self.modalPresentationStyle = UIModalPresentationCustom;
        //模态过渡模式
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        /*
         UIModalTransitionStyleCoverVertical：画面从下向上徐徐弹出，关闭时向下隐 藏（默认方式）。
         UIModalTransitionStyleFlipHorizontal：从前一个画面的后方，以水平旋转的方式显示后一画面。
         UIModalTransitionStyleCrossDissolve：前一画面逐渐消失的同时，后一画面逐渐显示。
         */
        //自定义跳转代理
        //        self.transitioningDelegate = self;
        
        _currentIndex = 0;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.dataSource = self;
    self.delegate = self;
    [self createViews];
}

- (void)createViews {
}

#pragma mark - WZProtocolImageBrowseNavigationView
- (void)leftButtunAction {
    [self dismissViewControllerAnimated:true completion:^{}];
}
- (void)rightButtunAction {
}

#pragma mark - Match VC use index
- (WZImageContainerController *)matchControllerIndexWithIndex:(NSInteger)index {
    
    if (index < 0
        || index > _numberOfIndexs) {
        return nil;
    }
    
    WZImageContainerController *VC = self.imageContainersReuseableArray[index % self.imageContainersReuseableArray.count];
    VC.index = index;
    [self matchThumnailImageWith:VC];
    return VC;
}

#pragma mark - Show VC in index
- (void)showInIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index <= 0) {index = 0;}
    if (index > _numberOfIndexs) {index = _numberOfIndexs;}
    _currentIndex  = index;
    
    WZImageContainerController *VC = [self matchControllerIndexWithIndex:_currentIndex];
    [self matchClearImageWith:VC];
    [self setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:^(BOOL finished) {}];
    self.currentContainerVC = VC;
}


#pragma mark - Match image
- (void)matchThumnailImageWith:(WZImageContainerController *)VC {
    if (!VC) {
        return;
    }
    NSUInteger index = VC.index;
    if (index >= _mediaAssetArray.count) {
        return;
    }
}

- (void)matchClearImageWith:(WZImageContainerController *)VC {
    if (!VC) {
        return;
    }
    NSUInteger index = VC.index;
    if (index >= _mediaAssetArray.count) {
        return;
    }
}

#pragma mark - WZProtocolImageScrollView
- (void)singleTap:(UIGestureRecognizer *)gesture {
    //单击
}

- (void)doubleTap:(UIGestureRecognizer *)gesture  {
    //变焦动画
    [self.currentContainerVC focusingWithGesture:gesture];
}

- (void)longPress:(UIGestureRecognizer *)gesture {
    //保存图片
    
}

#pragma mark - WZProtocolImageContainer

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    WZImageContainerController *VC = pageViewController.viewControllers.firstObject;
    if (self.currentContainerVC != VC) {
        [self matchClearImageWith:VC];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(WZImageContainerController *)viewController {
    return [self matchControllerIndexWithIndex:viewController.index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(WZImageContainerController *)viewController {
    return [self matchControllerIndexWithIndex:viewController.index + 1];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}

#pragma mark - Accessor
- (NSArray <WZImageContainerController *>*)imageContainersReuseableArray {
    if (!_imageContainersReuseableArray) {
        NSMutableArray *tmpMArr = [NSMutableArray array];
        NSUInteger reuseCount = 5;//重用控制器数目
        for (NSUInteger i = 0; i < reuseCount; i++) {
            WZImageContainerController *VC = [[WZImageContainerController alloc] init];
            VC.index = i;
            VC.delegate = (id<WZProtocolImageContainer>)self;
            VC.mainVC = self;
            [tmpMArr addObject:VC];
        }
        _imageContainersReuseableArray = [NSArray arrayWithArray:tmpMArr];
    }
    return _imageContainersReuseableArray;
}

- (void)setMediaAssetArray:(NSArray<WZMediaAsset *> *)mediaAssetArray {
    if ([mediaAssetArray isKindOfClass:[NSArray class]]) {
        _mediaAssetArray = mediaAssetArray;
        _numberOfIndexs = _mediaAssetArray.count - 1;
        if (_numberOfIndexs < 0) {
            _numberOfIndexs = 0;
        }
    }
}

@end
