//
//  HKSearchShareViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchShareViewController.h"
#import "ExpressTypeView.h"
#import "HKShareCircleViewController.h"
#import "HKShareFriendViewController.h"
#import "HKShareMessageViewController.h"
@interface HKSearchShareViewController ()<ExpressTypeViewDelegate,UIGestureRecognizerDelegate,UIPageViewControllerDelegate>
@property (nonatomic, strong)UIPageViewController *pageVC;
@property (nonatomic, strong)ExpressTypeView *typeView;
@property (nonatomic, strong)HKShareCircleViewController *circleVc;
@property (nonatomic, strong)HKShareFriendViewController *friendVc;
@property(nonatomic, assign) int type;
@property (nonatomic, strong)UIPanGestureRecognizer *fakePan;
@end

@implementation HKSearchShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HKBaseViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    self.pageVC.view.frame = CGRectMake(0, self.view.bounds.origin.y+45, kScreenWidth, self.view.bounds.size.height-45);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.view addSubview:self.typeView];
    __block UIScrollView *scrollView = nil;
    [self.pageVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) scrollView = (UIScrollView *)obj;
        
    }];
    if(scrollView)
    {
        //新添加的手势，起手势锁的作用
        _fakePan = [UIPanGestureRecognizer new];
        _fakePan.delegate = self;
        [scrollView addGestureRecognizer:_fakePan];
//        [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.fd_fullscreenPopGestureRecognizer];
        [scrollView.panGestureRecognizer requireGestureRecognizerToFail:_fakePan];
//        [_fakePan requireGestureRecognizerToFail:self.navigationController.fd_fullscreenPopGestureRecognizer];
    }
    // Do any additional setup after loading the view.
}
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0)
    {
        if (translation.x <-8) {
            if (self.type < 2) {
                self.type = self.type+1;
                [self btnClicks:self.type];
            }
        }
    }
    else
    {
        if (translation.x > 8) {
            if (self.type >0 ) {
                self.type = self.type-1;
                [self btnClicks:self.type];
            }
        }
    }
    return YES;
}
#pragma mark - 数组元素值，得到下标值
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([self indexOfViewController:(HKBaseViewController*)viewController]==1) {
        self.type = 0;
        return self.array_VC[0];
    }else if ([self indexOfViewController:(HKBaseViewController*)viewController]==2){
        self.type = 1;
        return self.array_VC[1];
    }
    self.type = 0;
    return nil;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if ([self indexOfViewController:(HKBaseViewController*)viewController]==0) {
        self.type = 1;
        return self.array_VC[1];
    }else if ([self indexOfViewController:(HKBaseViewController*)viewController]==1){
        self.type = 2;
        return self.array_VC[2];
    }
    self.type = 2;
    return nil;
}
- (NSUInteger)indexOfViewController:(HKBaseViewController *)viewController {
    return [self.array_VC indexOfObject:viewController];
}
-(void)btnClicks:(ExpressType)expressType{
    self.type = expressType;
    HKBaseViewController *initialViewController = [self viewControllerAtIndex:expressType];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
- (HKBaseViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.array_VC count] == 0) || (index >= [self.array_VC count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    HKBaseViewController *contentVC = [[HKBaseViewController alloc] init];
    contentVC = [self.array_VC objectAtIndex:index];
    return contentVC;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIPageViewController *)pageVC{
    if (!_pageVC) {
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageVC.delegate = self;
    }
    return _pageVC;
}
-(NSMutableArray *)array_VC{
    if (!_array_VC) {
        _array_VC = [NSMutableArray array];
        HKShareMessageViewController*expressVC0 = [[HKShareMessageViewController alloc]init];
        HKShareCircleViewController *expressVC2 = [[HKShareCircleViewController alloc]init];
        // CustomBackButtonViewController *expressVC2 = [[CustomBackButtonViewController alloc]init];
        HKShareFriendViewController *expressVC1 = [[HKShareFriendViewController alloc] init];
        [_array_VC addObject:expressVC0];
        [_array_VC addObject:expressVC1];
        [_array_VC addObject:expressVC2];
//        [_array_VC addObject:expressVC3];
    }
    return _array_VC;
}
-(ExpressTypeView *)typeView{
    if (!_typeView) {
        _typeView = [ExpressTypeView getExpressTypeView];
        _typeView.delegete = self;
    }
    return _typeView;
    
}
-(void)setType:(int)type{
    _type = type;
    self.typeView.type = type;
}
@end
