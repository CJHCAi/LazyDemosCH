//
//  ViewController.m
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ViewController.h"
#import "ToolView.h"
#import "DrawView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ToolView *toolView = [[ToolView alloc] initWithFrame:CGRectMake(0, 20,kWidth, 110)];
    [self.view addSubview:toolView];
    
    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 130, kWidth, kHeight-110)];
    [self.view addSubview:drawView];
    
    toolView.colorBlock = ^(UIColor *color) {
        drawView.color = color;
    };
    
    toolView.widthBlock = ^(float width) {
        drawView.width = width;
    };
    
    toolView.eraserBlock = ^{
        drawView.color = [UIColor whiteColor];
    };
    
    toolView.backBlock = ^{
        [drawView backAction];
    };
    
    toolView.clearBlock = ^{
        [drawView clearAction];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
