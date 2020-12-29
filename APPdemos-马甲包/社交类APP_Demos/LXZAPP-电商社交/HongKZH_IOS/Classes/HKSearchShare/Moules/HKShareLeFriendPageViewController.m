//
//  HKShareLeFriendPageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShareLeFriendPageViewController.h"
#import "HKCategoryBarView.h"
#import "HKShareCircleViewController.h"
#import "HKShareFriendViewController.h"
@interface HKShareLeFriendPageViewController ()<HJTabViewControllerDataSource,HKShareFriendViewControllerDelegate,HKShareCircleViewControllerDelegate>
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@property (nonatomic, strong)HKShareCircleViewController *circleVc;
@property (nonatomic, strong)HKShareFriendViewController *friendVc;
@end

@implementation HKShareLeFriendPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    self.title = @"选择";
}
-(void)backVc{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (self.isPre) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return ;
    }
    
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController{
    return self.array_vc.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index{
    return self.array_vc[index];
}
- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController{
    return self.categoryView;
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
        @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"好友",@"圈子"] selectCategory:^(int index) {
            @strongify(self)
             [self scrollToIndex:index animated:YES];
        }];
        _categoryView.frame = CGRectMake(0, 0, kScreenWidth, 41);
    }
    return _categoryView;
}
-(void)setIndexVC:(NSInteger)indexVC{
    _indexVC = indexVC;
    [self.categoryView setSelectTag:(int)indexVC];
    [self scrollToIndex:indexVC animated:YES];
}
-(NSMutableArray *)array_vc{
    if (!_array_vc) {
        NSMutableArray*array = [NSMutableArray arrayWithArray:@[self.friendVc,self.circleVc]];
        _array_vc = array;
    }
    return _array_vc;
}
-(void)setShareM:(HKShareBaseModel *)shareM{
    _shareM = shareM;
    self.friendVc.sharModel = shareM;
    self.circleVc.sharModel = shareM;
}
-(HKShareFriendViewController *)friendVc{
    if (!_friendVc) {
        _friendVc = [[HKShareFriendViewController alloc]init];
        _friendVc.delegate= self;
    }
    return _friendVc;
}
-(HKShareCircleViewController *)circleVc{
    if (!_circleVc) {
        _circleVc = [[HKShareCircleViewController alloc]init];;
        _circleVc.delegate = self;
    }
    return _circleVc;
}
@end
