//
//  ParentClassScrollViewController.m
//  LD_app_ios_NetWin
//
//  Created by 苟应航 on 2018/6/28.
//  Copyright © 2018年 lddtgroup. All rights reserved.
//

#import "ParentClassScrollViewController.h"

@interface ParentClassScrollViewController ()<UIGestureRecognizerDelegate>
@property(strong, nonatomic)UIScrollView *scrollView;

@end

@implementation ParentClassScrollViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(self.delegate)
    {
        [self.delegate scrollViewChangeTab:self.scrollView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        //离开顶部
        if(self.delegate)
        {
            [self.delegate scrollViewLeaveAtTheTop:scrollView];
        }
    }
    if (!self.scrollView) {
        if(self.delegate)
        {
            [self.delegate scrollViewChangeTab:scrollView];
        }
    }
    _scrollView = scrollView;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    // 首先判断otherGestureRecognizer是不是系统pop手势
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
//        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
//
//            return YES;
//        }
//    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

