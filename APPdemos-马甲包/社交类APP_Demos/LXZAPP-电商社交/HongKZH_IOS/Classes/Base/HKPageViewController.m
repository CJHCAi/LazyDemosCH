//
//  HKPageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPageViewController.h"

@interface HKPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation HKPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageVC.delegate = self;
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
        [self setPageView];
    // 在页面上，显示UIPageViewController
    
}
//- (void)setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion{
//
//}
-(void)setPageView{
    self.pageVC.delegate = self;
   
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    HK_BaseView *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self setPageVcFrame];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
}
-(void)setPageVcFrame{
     self.pageVC.view.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight-40);
}
+(instancetype)pageViewControllerWithVcArray:(NSArray*)vcArray{
    HKPageViewController *vc = [[HKPageViewController alloc]init];
    [vc.array_VC addObjectsFromArray:vcArray];
    return vc;
}
-(NSMutableArray *)array_VC{
    if (!_array_VC) {
        _array_VC = [NSMutableArray array];
    }
    return _array_VC;
}
//-(void)setArray_VC:(NSMutableArray *)array_VC{
//    _array_VC = array_VC;
//
//}



#pragma mark - 根据index得到对应的UIViewController

- (HK_BaseView *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.array_VC count] == 0) || (index >= [self.array_VC count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    HK_BaseView *contentVC = [[HK_BaseView alloc] init];
    contentVC = [self.array_VC objectAtIndex:index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(HK_BaseView *)viewController {
    return [self.array_VC indexOfObject:viewController];
}
-(void)btnClicks:(int)expressType{
    self.index = expressType;
    HK_BaseView *initialViewController = [self viewControllerAtIndex:expressType];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
-(UIPageViewController *)pageVC{
    if (!_pageVC) {
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
    }
    return _pageVC;
}
-(void)setLeftANdRight{
     self.pageVC.dataSource = self;
    
}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if (self.index>0) {
        self.index --;
        return self.array_VC[self.index];
    }
    return nil;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (self.index<self.array_VC.count-1) {
        self.index ++;
         return self.array_VC[self.index];
    }else{
        return nil;
    }
    
}
@end
