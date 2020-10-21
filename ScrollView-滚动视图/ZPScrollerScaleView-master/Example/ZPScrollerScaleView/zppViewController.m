//
//  zppViewController.m
//  ZPScrollerScaleView
//
//  Created by 张朋朋 on 08/02/2019.
//  Copyright (c) 2019 张朋朋. All rights reserved.
//

#import "zppViewController.h"
#import <ZPScrollerScaleView/ZPScrollerScaleView.h>

// 颜色
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBColor(r, g, b)     RGBAColor((r), (g), (b), 1.0)
#define RandomColor           RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface zppViewController ()
/**<#name#>*/
@property (nonatomic, strong) ZPScrollerScaleView *scrollerView;
@end

@implementation zppViewController

- (ZPScrollerScaleView *)scrollerView
{
    if (_scrollerView == nil) {
        
        /**初始化配置项*/
        ZPScrollerScaleViewConfig * config = [[ZPScrollerScaleViewConfig alloc]init];
        config.scaleMin = 0.9;
        config.scaleMax = 1;
        config.pageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 400);
        config.ItemMaingin = 5;
        
        
        /**初始化滚动缩放视图*/
        ZPScrollerScaleView * tempView = [[ZPScrollerScaleView alloc] initWithConfig:config];
        tempView.backgroundColor = [UIColor grayColor];
        
        _scrollerView = tempView;
    }
    return _scrollerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //1:创建子视图 并添加到数组中
    NSMutableArray <UIView *>* items = @[].mutableCopy;
    for(int i =0; i < 10; i++){
        UIView * view = [UIView new];
        view.backgroundColor =RandomColor;
        [items addObject:view];
    }
    
    
    [self.view addSubview:self.scrollerView];
    self.scrollerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 400);
    
    //至少要是等于 2-8
    self.scrollerView.defalutIndex = 9;
    
    //2:将子视图数组传递 ZPScrollerScaleView
    self.scrollerView.items = items;
}


@end
