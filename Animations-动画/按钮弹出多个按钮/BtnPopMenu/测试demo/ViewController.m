//
//  ViewController.m
//  测试demo
//
//  Created by mac on 2016/12/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "GBPopMenuButtonView.h"



#define GBScreenH [UIScreen mainScreen].bounds.size.height
#define GBScreenW [UIScreen mainScreen].bounds.size.width
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testScrollMenuView];
    
   
    
}

#pragma mark -- 测试 GBTopScrollMenuView
- (void)testScrollMenuView{
    GBPopMenuButtonView *view = [[GBPopMenuButtonView alloc] initWithItems:@[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg"] size:CGSizeMake(50, 50) type:GBMenuButtonTypeRoundLeft isMove:YES];
    view.frame = CGRectMake(200, 300, 50, 50);
    [self.view addSubview:view];
    
   
}

@end
