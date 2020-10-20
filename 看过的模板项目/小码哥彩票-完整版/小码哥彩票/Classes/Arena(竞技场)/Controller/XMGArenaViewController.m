//
//  XMGArenaViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGArenaViewController.h"

@interface XMGArenaViewController ()

@end

@implementation XMGArenaViewController

// 重写，自定义控制器view
- (void)loadView
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"足球",@"篮球"]];
    seg.width += 40;
    
    // 设置UISegmentedControl背景图片
    [seg setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentBG"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [seg setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentSelectedBG"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    seg.selectedSegmentIndex = 0;
    // 设置边框颜色
    seg.tintColor = XMGColor(0, 142, 143);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [seg setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    self.navigationItem.titleView = seg;
}


@end
