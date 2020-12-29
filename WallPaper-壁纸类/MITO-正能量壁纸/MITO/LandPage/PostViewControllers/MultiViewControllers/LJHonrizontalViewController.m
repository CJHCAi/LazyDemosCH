//
//  LJHonrizontalViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJHonrizontalViewController.h"

@interface LJHonrizontalViewController ()<UIScrollViewDelegate> {
    NSArray *_controllers;  //控制器数组
    UIScrollView *_scrollView;//承载子控制器视图的scrollView
}

@end

@implementation LJHonrizontalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化
- (instancetype)initWithControllers:(NSArray *)controllers {
    if (self = [super init]) {
        _controllers = controllers;
        for (UIViewController *vc in _controllers) {
            [self addChildViewController:vc];
        }
    }
    return self;
}

//创建UI
- (void) setupUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    CGFloat scrollViewHeight = _scrollView.frame.size.height;
    CGFloat scrollViewWidth = _scrollView.frame.size.width;
    [_controllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        CGRect rect = CGRectMake(idx * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
        vc.view.frame = rect;
        [_scrollView addSubview:vc.view];
    }];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(scrollViewWidth * _controllers.count, scrollViewHeight);
    [self.view addSubview:_scrollView];
    
}

- (void)scrollViewIndex:(NSInteger)index {
    CGPoint scrollOffSet = CGPointMake(index * _scrollView.frame.size.width, 0);
    
    [_scrollView setContentOffset:scrollOffSet animated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    if (self.block) {
        self.block(page);
    }
}

@end
