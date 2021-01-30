//
//  ViewController.m
//  LvCircleLoadingViewTest
//
//  Created by lv on 2016/11/10.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "ViewController.h"
#import "LvCircleLoadingView.h"
#import "UIColor+CHColor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor=[UIColor blackColor];
    
//     UIColor *colorStart=[[UIColor whiteColor]colorWithAlphaComponent:1];//[UIColor colorWithHexString:@"4F94CD"];
//     UIColor *colorEnd=[[UIColor whiteColor]colorWithAlphaComponent:0.5];//[UIColor colorWithHexString:@"BFEFFF"];
    UIColor *colorStart=[UIColor colorWithHexString:@"4F94CD"];//[UIColor colorWithHexString:@"4F94CD"];
    UIColor *colorEnd=[UIColor colorWithHexString:@"BFEFFF"];//[UIColor colorWithHexString:@"BFEFFF"];
    
    LvCircleLoadingView *circle=[[LvCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    circle.center=self.view.center;
    circle.imageLogo=[UIImage imageNamed:@"logo"];
//    circle.lineSpacing=10;
    circle.alertText=@"1111";
    circle.colorStart=colorStart;
    circle.colorEnd=colorEnd;
    [self.view addSubview:circle];
//    [LvCircleLoadingView showWithText:@"加载数据中"];
//    [LvCircleLoadingView showWithText:@"加载数据中1" imgLogo:[UIImage imageNamed:@"logo"]];
    
//    [LvCircleLoadingView hidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
