//
//  ViewController.m
//  YLColorSlider
//
//  Created by wlx on 17/3/21.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "ViewController.h"
#import "YLColorSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200, 300, 50, 50)];
    [self.view addSubview:view];
    YLColorSlider *colorSlider = [[YLColorSlider alloc] initWithFrame:CGRectMake(50, 100, 300, 30) selectedColorBlock:^(UIColor *color) {
        view.backgroundColor = color;
    }];
    [self.view addSubview:colorSlider];
}
@end
