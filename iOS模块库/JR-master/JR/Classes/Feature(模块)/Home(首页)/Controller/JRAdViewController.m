
//
//  JRAdViewController.m
//  JR
//
//  Created by 张骏 on 17/8/25.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRAdViewController.h"

@interface JRAdViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation JRAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JRWhiteColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(0, JRHeight(2292 / 2));
    _scrollView.contentInset=UIEdgeInsetsMake(-20, 0, 0, 0);
    [self.view addSubview:_scrollView];

    _imgView = [UIImageView imageViewWithFrame:CGRectMake(0, 0, JRScreenWidth, JRHeight(2292 / 2)) image:[UIImage imageNamed:@"ad1"]];
    
    [_scrollView addSubview:_imgView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
