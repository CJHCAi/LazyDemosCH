//
//  HKMyFollowsContainerViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFollowsContainerViewController.h"
#import "CBSegmentView.h"
#import "HKMyFollowsViewController.h"
#import "HKMyFollowsEnterpriseViewController.h"

@interface HKMyFollowsContainerViewController ()

@property (nonatomic, strong) CBSegmentView *segment;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) HKMyFollowsViewController *myFollowsVc;
@property (nonatomic, strong) HKMyFollowsEnterpriseViewController *myFollowsEnterpriseVc;

@end

@implementation HKMyFollowsContainerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CBSegmentView *)segment {
    if (!_segment) {
        _segment = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [_segment setTitleArray:@[@"我关注的人",@"我关注的企业"] titleFont:14 titleColor:UICOLOR_HEX(0x7c7c7c) titleSelectedColor:UICOLOR_HEX(0x0092ff) withStyle:CBSegmentStyleSlider];
        @weakify(self);
        _segment.titleChooseReturn = ^(NSInteger x) {
            @strongify(self);
            [self.scrollView setContentOffset:CGPointMake(kScreenWidth * x, 0) animated:YES];
        };
    }
    return _segment;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.scrollEnabled = NO;
        scrollView.pagingEnabled = YES;
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(41);
            make.left.right.bottom.equalTo(self.view);
        }];
        scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-64-40);
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (HKMyFollowsViewController *)myFollowsVc {
    if (!_myFollowsVc) {
        _myFollowsVc = [[HKMyFollowsViewController alloc] init];
    }
    return _myFollowsVc;
}

- (HKMyFollowsEnterpriseViewController *)myFollowsEnterpriseVc {
    if (!_myFollowsEnterpriseVc) {
        _myFollowsEnterpriseVc = [[HKMyFollowsEnterpriseViewController alloc] init];
    }
    return _myFollowsEnterpriseVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    [self setNavItem];
    [self.view addSubview:self.segment];
    [self addChildVc];
}

- (void)addChildVc {
    [self addChildViewController:self.myFollowsVc];
    [self.scrollView addSubview:self.myFollowsVc.view];
    [self.myFollowsVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
    }];

    [self addChildViewController:self.myFollowsEnterpriseVc];
    [self.scrollView addSubview:self.myFollowsEnterpriseVc.view];
    [self.myFollowsEnterpriseVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.left.equalTo(self.myFollowsVc.view.mas_right);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
