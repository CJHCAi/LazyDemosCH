//
//  XMGGroupBuyViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGGroupBuyViewController.h"
#import "XMGTitleView.h"

@interface XMGGroupBuyViewController ()

@property (nonatomic, weak) UIButton *titleView;

@end

@implementation XMGGroupBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *titleView = [XMGTitleView buttonWithType:UIButtonTypeCustom];
    
    _titleView = titleView;
    
    [titleView setTitle:@"全部彩种" forState:UIControlStateNormal];
    
    [titleView setImage:[UIImage imageNamed:@"YellowDownArrow"] forState:UIControlStateNormal];
    
    [titleView sizeToFit];
    
    // titleView
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"助手" style:UIBarButtonItemStyleBordered target:self action:@selector(help)];
}

- (void)help
{
    
//    [_titleView setTitle:@"全部彩种全部彩种" forState:UIControlStateNormal];
    
    [_titleView setImage:nil forState:UIControlStateNormal];
    
    NSLog(@"%s",__func__);
}

@end