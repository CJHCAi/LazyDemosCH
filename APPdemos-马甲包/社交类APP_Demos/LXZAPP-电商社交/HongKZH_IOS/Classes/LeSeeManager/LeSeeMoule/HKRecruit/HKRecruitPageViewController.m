//
//  HKRecruitPageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecruitPageViewController.h"
#import "HKRecruitViewController.h"
#import "HKRecruitHeadView.h"
#import "HKLeSeeViewModel.h"
#import "HKSowingRespone.h"
#import "HKSeleMediaCliceViewController.h"
@interface HKRecruitPageViewController ()<HJTabViewControllerDelagate,HJTabViewControllerDataSource,HKRecruitHeadViewDelegate>
@property (nonatomic, strong)HKRecruitHeadView * headView;
@end

@implementation HKRecruitPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    self.tabDelegate = self;
    self.headerZoomIn = NO;
    self.isNOTScrollEnabled = YES;
    [self getCategoryCarouselList];
}
-(void)getCategoryCarouselList{
    //轮播图
    [HKLeSeeViewModel getCategoryCarouselList:@{@"categoryId":self.categoryId} success:^(HKSowingRespone *responde) {
        if (responde.responeSuc) {
            self.headView.model = responde;
        }
    }];
}
-(void)switchVc:(NSInteger)tag{
    BOOL anim = labs(tag - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:tag animated:anim];
}
- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return 2;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    if (index == 0) {
        HKRecruitViewController*vc = [[HKRecruitViewController alloc]init];
        vc.categoryId = self.categoryId;
        return vc;
    }else{
        HKSeleMediaCliceViewController*vc= [[HKSeleMediaCliceViewController alloc]init];
        vc.categoryId = self.categoryId;
        return vc;
    }
   
}

- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    
    return self.headView;
}

- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    return 0;
    //    return 365;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(HKRecruitHeadView *)headView{
    if (!_headView) {
        _headView = [[HKRecruitHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        _headView.delegate = self;
    }
    return _headView;
}
@end
